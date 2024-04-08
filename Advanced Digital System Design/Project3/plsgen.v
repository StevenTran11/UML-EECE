module plsgen (
    output logic pulse, q,
    input logic d,
    input logic clk, rst_n
);
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            q <= 0;
        end
        else begin
            q <= d;
        end
    assign pulse = q ^ d;
endmodule