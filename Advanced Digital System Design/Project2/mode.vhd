library ieee;
use ieee.std_logic_1164.all;
library ads;
USE ads.ads_fixed.all;
USE ads.ads_complex_pkg.all;

entity mode_select is
    port (
		clock:	in	std_logic;
        complex_input : in ads_complex;
        mode_in : in std_logic ; --SW9 on Board
        output_data : out complex_record
    );
end entity mode_select;

architecture behavior of mode_select is
begin

--	output_data <= (
--			z => ( re => to_ads_sfixed(0.0), im => to_ads_sfixed(0.0) ),
--			c => complex_input,
--			stage_data => 0,
--			stage_overflow => false )
--				when mode_in = '0' else (
--			z => complex_input,
--			c => ( re => to_ads_sfixed(-1.0), im => to_ads_sfixed(0.0) ),
--			stage_data => 0,
--			stage_overflow => false
--		);	

    process(clock)
    begin
		if rising_edge(clock) then
			if mode_in = '0' then
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
		end if;
    end process;
end architecture behavior;
