library ieee;
use ieee.std_logic_1164.all;

entity PLL is
	port (
		inclk0:	in	std_logic;
		c0:	out	std_logic
	);
end entity PLL;

architecture passthrough of PLL is
begin
	c0 <= inclk0;
end architecture passthrough;
