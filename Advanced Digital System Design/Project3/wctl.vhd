library ieee;
use ieee.std_logic_1164.all;

entity wctl is
  port (
    wrdy   : out std_logic;
    wptr   : out std_logic_vector(n-1 downto 0), -- Replace n with actual width
    we     : out std_logic;
    wput   : in std_logic;
    wq2_rptr : in std_logic_vector(n-1 downto 0), -- Replace n with actual width
    wclk    : in std_logic;
    wrst_n  : in std_logic
  );
end entity wctl;

architecture rtl of wctl is

  constant N : positive := wptr'length;  -- Assuming wptr and wq2_rptr have the same width

begin

  process(wclk, wrst_n)
  begin
    if rising_edge(wclk) then
      if wrst_n = '0' then
        wptr <= (others => '0');
      else
        wptr <= wptr xor (wrdy and wput);
      end if;
    end if;
  end process;

  we <= wrdy and wput;

  wrdy <= not (wq2_rptr = wptr);

end architecture rtl;
