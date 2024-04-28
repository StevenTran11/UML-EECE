library ieee;
use ieee.std_logic_1164.all;

entity sync3 is
  generic (
		input_width: positive := 16
	);
  port (
    clk1 : in	std_logic;
    clk2 : in	std_logic;
    rst_n : in	std_logic;
    d : in std_logic_vector(input_width - 1 downto 0);
    q : out std_logic_vector(input_width - 1 downto 0)
  );
end entity sync3;

architecture rtl of sync3 is
	signal q1, q2 : std_logic_vector(input_width - 1 downto 0);
begin
	process(clk1, rst_n)
	begin
		if rising_edge(clk1) then
			if rst_n = '0' then
				q <= (others => '0');  -- Representing vector of zeros using '0' attribute
				q1 <= (others => '0'); -- Representing vector of zeros using '0' attribute
			else
				q <= q1;
        		q1 <= q2;
      		end if;
    	end if;
	end process;

process(clk2, rst_n)
	begin
    if rising_edge(clk2) then
    	if rst_n = '0' then
        	q2 <= (others => '0');  -- Representing vector of zeros using '0' attribute
      	else
        	q2 <= d;
		end if;
	end if;
	end process;
end architecture rtl;
