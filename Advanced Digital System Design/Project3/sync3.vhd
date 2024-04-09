library ieee;
use ieee.std_logic_1164.all;

entity sync3 is
  port (
    clk1 : in  signal logic;
	clk2 : in  signal logic;
    rst_n : in  signal logic;
    d : in  signal logic;
    q : out signal logic
  );
end entity sync3;

architecture rtl of sync3 is

  signal q1, q2 : signal logic;

begin

  process(clk1, rst_n)
  begin
    if rising_edge(clk1) then
    	if not rst_n then
        q <= '0';
        q1 <= '0';
      else
        q <= q1;
        q1 <= q2;
      end if;
    end if;
  end process;

  process(clk2, rst_n)
  begin
    if rising_edge(clk2) then
    	if not rst_n then
        q2 <= '0';
      else
        q2 <= d;
      end if;
    end if;
  end process;
end architecture rtl;
