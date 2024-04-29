library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.seven_segment_pkg.all; -- Assuming seven_segment_pkg is in the same library

entity project3 is
    generic (
            ADDR_WIDTH : natural := 6
        );
    port (
        clk_10MHz : in std_logic;   -- Input clock of 10 MHz
        clk_50MHz : in std_logic;   -- Input clock of 50 MHz
        LEDR0 : out std_logic;
        LEDR1 : out std_logic;
        LEDR2 : out std_logic;
        LEDR3 : out std_logic;
        LEDR4 : out std_logic;
        LEDR5 : out std_logic;
        LEDR6 : out std_logic;
        LEDR7 : out std_logic;
        LEDR8 : out std_logic;
        LEDR9 : out std_logic
    );
end entity project3;

architecture rtl of project3 is
    -- Components declaration
    -- ... (existing component declarations) ...

    -- Internal signals
    -- ... (existing signal declarations) ...
    signal seven_segment_output : seven_segment_array(0 to 1);
    signal led_output : std_logic_vector(0 to 9);

begin
    -- Instantiate components
    -- ... (existing component instantiations) ...

    -- Conversions
    -- ... (existing conversion logic) ...

    -- Display the value of q_a on the LEDs
    seven_segment_output <= get_hex_number(q_a, default_lamp_config);

    -- Assign the seven segment outputs to the LEDR pins
    led_output(0) <= seven_segment_output(1).a;
    led_output(1) <= seven_segment_output(1).b;
    led_output(2) <= seven_segment_output(1).c;
    led_output(3) <= seven_segment_output(1).d;
    led_output(4) <= seven_segment_output(1).e;
    led_output(5) <= seven_segment_output(1).f;
    led_output(6) <= seven_segment_output(1).g;
    led_output(7) <= seven_segment_output(0).a;
    led_output(8) <= seven_segment_output(0).b;
    led_output(9) <= seven_segment_output(0).c;

    -- Assign the led_output signals to the LED pins
    LEDR0 <= led_output(0);
    LEDR1 <= led_output(1);
    LEDR2 <= led_output(2);
    LEDR3 <= led_output(3);
    LEDR4 <= led_output(4);
    LEDR5 <= led_output(5);
    LEDR6 <= led_output(6);
    LEDR7 <= led_output(7);
    LEDR8 <= led_output(8);
    LEDR9 <= led_output(9);

end architecture rtl;