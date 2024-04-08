library ieee;
use ieee.std_logic_1164.all;

entity rctl is
  port (
    rrdy   : out std_logic;
    rptr   : out std_logic_vector(n-1 downto 0),  -- Replace n with actual width
    rget   : in std_logic;
    rq2_wptr : in std_logic_vector(n-1 downto 0),  -- Replace n with actual width
    rclk   : in std_logic;
    rrst_n  : in std_logic
  );
end entity rctl;

architecture rtl of rctl is

  constant N : positive := rptr'length; -- Assuming rptr and rq2_wptr have the same width
  type status_t is (xxx, VALID);

  signal status : status_t := xxx;

begin

  process(rclk, rrst_n)
  begin
    if rising_edge(rclk) then
      if rrst_n = '0' then
        rptr <= (others => '0');
        status <= xxx;
      else
        if rget then
          if rrdy then
            status <= VALID;
          end if;
          rptr <= rptr xor (rrdy and rget);
        else
          status <= status;  -- Maintain status if not reading
        end if;
      end if;
    end if;
  end process;

  rrdy <= status = VALID;

end architecture rtl;
