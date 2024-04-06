module sync2 (
    output logic q,
    input logic d, clk, rst_n
);
    logic q1; // 1st stage ff output
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            q <= 0;
            q1 <= 0;
        end
        else begin
            q <= {q1, d};
            q1 <= d;
        end
endmodule
