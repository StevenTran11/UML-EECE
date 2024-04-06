module bmcp_recv (
    output logic [7:0] bdata,
    output logic bvalid,
    output logic b_ack,
    input logic [7:0] adata,
    input logic bload,
    input logic bq2_en,
    input logic bclk, brst_n
);
    logic b_en; // enable pulse from pulse generator
    // Pulse Generator
    plsgen pg1 (
        .pulse(b_en),
        .q(),
        .d(bq2_en),
        .clk(bclk),
        .rst_n(brst_n)
    );
    // data ready/acknowledge FSM
    back_fsm fsm (
        .bvalid(),
        .bload(bload),
        .b_en(b_en),
        .bclk(bclk),
        .brst_n(brst_n)
    );
    // load next data word
    assign bload_data = bvalid & bload;
    // toggle-flop controlled by bload_data
    always_ff @(posedge bclk or negedge brst_n)
        if (!brst_n) begin
            b_ack <= '0;
        end
        else if (bload_data) begin
            b_ack <= ~b_ack;
        end
    always_ff @(posedge bclk or negedge brst_n)
        if (!brst_n) begin
            bdata <= '0;
        end
        else if (bload_data) begin
            bdata <= adata;
        end
endmodule
