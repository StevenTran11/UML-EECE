module rctl (
    output logic rrdy,
    output logic rptr,
    input logic rget,
    input logic rq2_wptr,
    input logic rclk,
    input logic rrst_n
);
    typedef enum {xxx, VALID} status_e;
    status_e status;
    assign status = status_e'(rrdy);
    assign rinc = rrdy & rget;
    assign rrdy = (rq2_wptr ^ rptr);
    always_ff @(posedge rclk or negedge rrst_n)
        if (!rrst_n) begin
            rptr <= '0;
        end
        else if (rinc) begin
            rptr <= rptr ^ rinc;
        end
endmodule
