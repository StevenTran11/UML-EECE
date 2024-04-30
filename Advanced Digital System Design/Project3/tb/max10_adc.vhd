library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----
-- port map:
--
-- pll_clk:	clock input (10 MHz)
-- chsel:	channel select
-- soc:		start of conversion
-- tsen:	0 - normal mode
--			1 - temperature sensing mode
-- dout:	data output
-- eoc:		end of conversion
-- clk_dft:	clock output from clock divider

entity max10_adc is
	port (
		pll_clk:	in	std_logic;
		chsel:		in	natural range 0 to 2**5 - 1;
		soc:		in	std_logic;
		tsen:		in	std_logic;
		dout:		out	natural range 0 to 2**12 - 1;
		eoc:		out	std_logic;
		clk_dft:	out	std_logic
	);
end entity max10_adc;

architecture sim of max10_adc is
begin
	clk_dft <= pll_clk;
	dout <= 200;
	process(soc) is
	begin
		if soc = '1' then
			eoc <= '1' after 2 us;
		else
			eoc <= '0';
		end if;
	end process;
	-- eoc <= '1' after 50 us when soc = '1' else '0';
end architecture sim;
