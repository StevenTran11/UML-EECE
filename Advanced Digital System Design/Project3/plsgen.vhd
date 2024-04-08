library ieee;
use ieee.std_logic_1164.all;

entity plsgen is
  port (
    clk : in  signal logic;
    rst_n : in  signal logic;
    d : in  signal logic;
    q : out signal logic;
    pulse : out signal logic
  );
end entity plsgen;

architecture rtl of plsgen is

  signal prev_d : signal logic;

begin

  process(clk, rst_n)
  begin
    if rising_edge(clk) then
      if not rst_n then
        q <= '0';
        prev_d <= '0';
      else
        q <= d;
        pulse <= d xor prev_d;
        prev_d <= d;
      end if;
    end if;
  end process;

end architecture rtl;
