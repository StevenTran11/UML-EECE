library ieee;
use ieee.std_logic_1164.all;
use work.ads.all;

entity mode is
    port (
        complex_input : in complex;
        mode : in std_logic;
        z, c : out complex
    );
end entity mode;

architecture behavior of mode is
begin
    process(complex_input, mode)
    begin
        if mode = '0' then
            -- When mode is 0, z is zero and c is the complex input
            z <= (0.0, 0.0);
            c <= complex_input;
        else
            -- When mode is 1, c is zero and z is the complex input
            z <= complex_input;
            c <= (0.0, 0.0);
        end if;
    end process;
end architecture behavior;
