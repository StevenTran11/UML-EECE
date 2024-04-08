library ieee;
use ieee.std_logic_1164.all;

entity sync3 is
  port (
    clk : in  signal logic;
    rst_n : in  signal logic;
    d : in  signal logic;
    q : out signal logic
  );
end entity sync3;

architecture rtl of sync3 is

  signal q1, q2 : signal logic;

begin

  process(clk, rst_n)
  begin
    if rising_edge(clk) then
      if not rst_n then
        q <= '0';
        q1 <= '0';
        q2 <= '0';
      else
        q <= q2;
        q1 <= q;
        q2 <= d;
      end if;
    end if;
  end process;

end architecture rtl;
