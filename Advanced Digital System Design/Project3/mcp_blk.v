module mcp_blk #(
    parameter type dat_t = logic [7:0]
)(
    output logic aready,
    input logic [7:0] adatain,
    input logic asend,
    input logic aclk,
    input logic arst_n,
    output logic [7:0] bdata,
    output logic bvalid,
    input logic bload,
    input logic bclk,
    input logic brst_n
);
    logic [7:0] adata; // internal data bus
    logic b_ack; // acknowledge enable signal
    logic a_en; // control enable signal
    logic bq2_en; // control - sync output
    logic aq2_ack; // feedback - sync output
    sync2 async (
        .q(aq2_ack),
        .d(b_ack),
        .clk(aclk),
        .rst_n(arst_n)
    );
    sync2 bsync (
        .q(bq2_en),
        .d(a_en),
        .clk(bclk),
        .rst_n(brst_n)
    );
    amcp_send alogic (
        .adata(),
        .a_en(),
        .aready(),
        .adatain(adatain),
        .asend(asend),
        .aq2_ack(aq2_ack),
        .aclk(aclk),
        .arst_n(arst_n)
    );
    bmcp_recv blogic (
        .bdata(bdata),
        .bvalid(bvalid),
        .b_ack(b_ack),
        .adata(adata),
        .bload(bload),
        .bq2_en(bq2_en),
        .bclk(bclk),
        .brst_n(brst_n)
    );
endmodule
