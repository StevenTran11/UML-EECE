library ieee;
use ieee.std_logic_1164.all;
library ads;
USE ads.ads_fixed.all;
USE ads.ads_complex_pkg.all;

entity mode is
    port (
        complex_input : in ads_complex;
        mode : in std_logic ; --SW9 on Board
        output_data : out complex_record
    );
end entity mode;

architecture behavior of mode is
begin
    process(complex_input, mode)
    begin
        if mode = '0' then
            -- When mode is 0, z is zero and c is the complex input
            output_data.z.re <= to_ads_sfixed(0.0);
            output_data.z.im <= to_ads_sfixed(0.0);
            output_data.c.re <= complex_input.re;
            output_data.c.im <= complex_input.im;
            output_data.stage_data <= 0;
            output_data.stage_overflow <= false;
        else
            -- When mode is 1, c is zero and z is the complex input
            output_data.z.re <= complex_input.re;
            output_data.z.im <= complex_input.im;
            output_data.c.re <= to_ads_sfixed(0.0);
            output_data.c.im <= to_ads_sfixed(0.0);
            output_data.stage_data <= 0;
            output_data.stage_overflow <= false;
        end if;
    end process;
end architecture behavior;
