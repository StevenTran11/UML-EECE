module back_fsm (
    output logic bvalid,
    input logic bload,
    input logic b_en,
    input logic bclk, brst_n
);
    enum logic {READY = '1, WAIT = '0} state, next;
    always_ff @(posedge bclk or negedge brst_n)
        if (!brst_n) begin
            state <= WAIT;
        end
        else begin
            state <= next;
        end

        always_comb begin
            case (state)
                READY: if (bload) begin
                            next = WAIT;
                        end
                        else begin
                            next = READY;
                        end
                WAIT: if (b_en) begin
                            next = READY;
                        end
                        else begin
                            next = WAIT;
                        end
            endcase
        end
    assign bvalid = state;
endmodule
