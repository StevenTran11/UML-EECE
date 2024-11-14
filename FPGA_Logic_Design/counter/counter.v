module counter (
    input wire clk_10MHz,   // Input clock of 10 MHz
    input wire rst,         // Reset
    // Seven-Segment Display Ports
    output wire HEX00,      // Segment a
    output wire HEX01,      // Segment b
    output wire HEX02,      // Segment c
    output wire HEX03,      // Segment d
    output wire HEX04,      // Segment e
    output wire HEX05,      // Segment f
    output wire HEX06,      // Segment g
    output wire HEX07       // Decimal point (not used here)
);

    // Internal signals
    reg [23:0] counter = 24'd0;  // 24-bit counter for delay (10 MHz to approx 1 Hz)
    reg [3:0] count_value = 4'd15;  // Countdown from F (15) to 0
    seven_segment_config seg_data;  // Segment data for 7-segment display

    // Clock Divider Process: Creates a 1-second delay using 10 MHz input clock
    always @(posedge clk_10MHz or posedge rst) begin
        if (rst) begin
            counter <= 24'd0;
            count_value <= 4'd15;  // Initialize to start counting from F (15)
        end else begin
            if (counter == 24'd10_000_000 - 1) begin  // 1-second delay at 10 MHz
                counter <= 24'd0;
                if (count_value == 4'd0) begin
                    count_value <= 4'd15;  // Reset to F after reaching 0
                end else begin
                    count_value <= count_value - 1;
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // 7-Segment Display Process: Converts count_value to 7-segment output
    always @(*) begin
        seg_data = get_hex_digit(count_value);  // Get segment configuration for the current count
        // Assign each segment to its respective output pin
        HEX00 = seg_data.a;
        HEX01 = seg_data.b;
        HEX02 = seg_data.c;
        HEX03 = seg_data.d;
        HEX04 = seg_data.e;
        HEX05 = seg_data.f;
        HEX06 = seg_data.g;
        HEX07 = 1'b1;  // Decimal point (not used here, set to off)
    end

endmodule