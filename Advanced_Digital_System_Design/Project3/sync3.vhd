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
	process(clk2, rst_n)
	begin
		if rising_edge(clk2) then
			if rst_n = '0' then
				q <= (others => '0');  -- Representing vector of zeros using '0' attribute
				q2 <= (others => '0'); -- Representing vector of zeros using '0' attribute
			else
				q <= q2;
        		q2 <= q1;
      		end if;
    	end if;
	end process;

process(clk1, rst_n)
	begin
    if rising_edge(clk1) then
    	if rst_n = '0' then
        	q1 <= (others => '0');  -- Representing vector of zeros using '0' attribute
      	else
        	q1 <= d;
		end if;
	end if;
	end process;
end architecture rtl;
