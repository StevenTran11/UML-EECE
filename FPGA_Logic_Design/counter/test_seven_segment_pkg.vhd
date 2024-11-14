library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.seven_segment_pkg.all;

entity seven_segment_tb is
end entity;

architecture behavioral of seven_segment_tb is
    signal digit : hex_digit;
    signal seg : seven_segment_config;

begin
    -- Testbench process
    process
    begin
        -- Test all hexadecimal digits
        for i in 0 to 15 loop
            digit <= i;
            wait for 20 ns;
            seg <= get_hex_digit(digit, common_cathode);
        end loop;

        -- Finish simulation
        wait;
    end process;
end architecture behavioral;