library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.seven_segment_pkg.all;

entity counter is
    port (
        clk_10MHz : in std_logic;   -- Input clock of 10 MHz PIN_N5
	rst       : in  std_logic;  -- Reset PIN_B8
        -- Seven-Segment Display Ports
        HEX00 : out std_logic;  -- PIN_C14
        HEX01 : out std_logic;  -- PIN_E15
        HEX02 : out std_logic;  -- PIN_C15
        HEX03 : out std_logic;  -- PIN_C16
        HEX04 : out std_logic;  -- PIN_E16
        HEX05 : out std_logic;  -- PIN_D17
        HEX06 : out std_logic;  -- PIN_C17
        HEX07 : out std_logic   -- PIN_D15
    );
end entity counter;

architecture rtl of counter is
    signal counter        : unsigned(23 downto 0) := (others => '0');  -- 24-bit counter for delay (10 MHz to approx 1 Hz)
    signal count_value    : integer range 0 to 15 := 15;               -- Countdown from F (15) to 0
    signal seg_data       : seven_segment_config;                      -- Segment data for 7-segment display
    
begin
    -- Clock Divider Process: Creates a 1-second delay using 10 MHz input clock
    process(clk_10MHz, rst)
    begin
        if rst = '1' then
            counter <= (others => '0');
            count_value <= 15;  -- Initialize to start counting from F (15)
        elsif rising_edge(clk_10MHz) then
            if counter = 10_000_000 - 1 then  -- 1-second delay at 10 MHz
                counter <= (others => '0');
                if count_value = 0 then
                    count_value <= 15;  -- Reset to F after reaching 0
                else
                    count_value <= count_value - 1;
                end if;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- 7-Segment Display Process: Converts count_value to 7-segment output
    process(count_value)
    begin
        seg_data <= get_hex_digit(count_value, common_cathode);  -- Get segment configuration for the current count
        -- Assign each segment to its respective output pin
        HEX00 <= seg_data.a;
        HEX01 <= seg_data.b;
        HEX02 <= seg_data.c;
        HEX03 <= seg_data.d;
        HEX04 <= seg_data.e;
        HEX05 <= seg_data.f;
        HEX06 <= seg_data.g;
        HEX07 <= '1';  -- Decimal point (not used here, set to off)
    end process;
end architecture rtl;
