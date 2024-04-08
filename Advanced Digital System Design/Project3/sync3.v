module sync3 (
    output logic q,
    input logic d,
    clk,
    rst_n
);

    logic q1, q2; // Additional stages for 3-flop sync

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= '0;
            q1 <= '0;
            q2 <= '0;
        end else begin
            q <= q2;
            q2 <= q1;
            q1 <= d;
        end
    end
endmodule