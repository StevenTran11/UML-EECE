module amcp_send (
    output logic [7:0] adata,
    output logic a_en,
    output logic aready,
    input logic [7:0] adatain,
    input logic asend,
    input logic aq2_ack,
    input logic aclk,
    input logic arst_n
);
    logic aack; // acknowledge pulse from pulse generator
    // Pulse Generator
    plsgen pg1 (
        .pulse(aack),
        .q(),
        .d(aq2_ack),
        .clk(aclk),
        .rst_n(arst_n)
    );
    // data ready/acknowledge FSM
    asend_fsm fsm (
        .aready(),
        .asend(asend),
        .aack(aack),
        .aclk(aclk),
        .arst_n(arst_n)
    );
    // send next data word
    assign anxt_data = aready & asend;
    // toggle-flop controlled by anxt_data
    always_ff @(posedge aclk or negedge arst_n)
        if (!arst_n) begin
            a_en <= '0;
        end
        else if (anxt_data) begin
            a_en <= ~a_en;
        end
    always_ff @(posedge aclk or negedge arst_n)
        if (!arst_n) begin
            adata <= '0;
        end
        else if (anxt_data) begin
            adata <= adatain;
        end
endmodule
