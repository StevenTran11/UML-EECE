module asend_fsm (
    output logic aready,
    input logic asend,
    input logic aack,
    input logic aclk, arst_n
);
    enum logic {READY = '1, BUSY = '0} state, next;
    always_ff @(posedge aclk or negedge arst_n)
        if (!arst_n) begin
            state <= READY;
        else begin
            state <= next;
        end

    always_comb begin
        case (state)
            READY: if (asend) begin
                        next = BUSY;
                    end
                    else begin
                        next = READY;
                    end
            BUSY: if (aack) begin
                        next = READY;
                    end
                    else begin
                        next = BUSY;
                    end
        endcase
    end
    assign aready = state;
endmodule
