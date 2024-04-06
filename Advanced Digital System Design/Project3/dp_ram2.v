module dp_ram2 #(
    parameter type dat_t = logic [7:0]
)(
    output dat_t q,
    input dat_t d,
    input logic waddr,
    input logic raddr,
    input logic we,
    input logic clk
);
    dat_t mem [0:1];
    always_ff @(posedge clk)
        if (we) begin
            mem[waddr] <= d;
        end
    assign q = mem[raddr];
endmodule
