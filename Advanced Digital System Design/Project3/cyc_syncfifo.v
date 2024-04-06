module cdc_syncfifo #(
    parameter type dat_t = logic [7:0]
)(
    input dat_t wdata,
    output logic wrdy,
    input logic wput,
    input logic wclk,
    input logic wrst_n,
    output dat_t rdata,
    output logic rrdy,
    input logic rget,
    input logic rclk,
    input logic rrst_n
);
    logic wptr, we, wq2_rptr;
    logic rptr, rq2_wptr;
    wctl wctl (
        .wrdy(),
        .wptr(),
        .we(),
        .wput(),
        .wq2_rptr(),
        .wclk(),
        .wrst_n()
    );
    rctl rctl (
        .rrdy(),
        .rptr(),
        .rget(),
        .rq2_wptr(),
        .rclk(),
        .rrst_n()
    );
    sync2 w2r_sync (
        .q(rq2_wptr),
        .d(wptr),
        .clk(rclk),
        .rst_n(rrst_n)
    );
    sync2 r2w_sync (
        .q(wq2_rptr),
        .d(rptr),
        .clk(wclk),
        .rst_n(wrst_n)
    );
    // dual-port 2-deep ram
    dp_ram2 #(dat_t) dpram (
        .q(rdata),
        .d(wdata),
        .waddr(wptr),
        .raddr(rptr),
        .we(we),
        .clk(wclk)
    );
endmodule
