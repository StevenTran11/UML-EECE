module FSM (
    input wire clk,
    input wire reset,
    input wire in,
    output reg [1:0] out
);

    localparam [1:0] 
        state0 = 2'b00,
        state1 = 2'b01,
        state2 = 2'b10,
        state3 = 2'b11;

    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= state0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            state0: begin
                out = state0;
                if (in)
                    next_state = state1;
                else
                    next_state = state0;
            end
            state1: begin
                out = state1;
                if (in)
                    next_state = state2;
                else
                    next_state = state1;
            end
            state2: begin
                out = state2;
                if (in)
                    next_state = state3;
                else
                    next_state = state2;
            end
            state3: begin
                out = state3;
                if (in)
                    next_state = state0;
                else
                    next_state = state3;
            end
            default: begin
                out = state0;
                next_state = state0;
            end
        endcase
    end
endmodule
