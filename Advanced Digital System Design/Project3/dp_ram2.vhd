library ieee;
use ieee.std_logic_1164.all;

entity dp_ram2 is
  generic (
    dat_t : std_logic_vector(7 downto 0)  -- Replace with actual data width
  );
  port (
    q      : out std_logic_vector(dat_t'range);
    d      : in std_logic_vector(dat_t'range);
    waddr  : in std_logic_vector(1 downto 0);    -- Assuming RAM depth is 2
    raddr  : in std_logic_vector(1 downto 0);    -- Assuming RAM depth is 2
    we     : in std_logic;
    clk    : in std_logic
  );
end entity dp_ram2;

architecture rtl of dp_ram2 is

  signal mem : std_logic_vector(dat_t'range) := (others => '0');  -- Initialize memory

begin

  process(clk)
  begin
    if rising_edge(clk) then
      if we then
        mem(waddr'range) <= d;
      end if;
    end if;
  end process;

  q <= mem(raddr'range);

end architecture rtl;
