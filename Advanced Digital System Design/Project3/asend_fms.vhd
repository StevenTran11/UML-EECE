library ieee;
use ieee.std_logic_1164.all;

-- Define the state enumeration type
type state_type is (READY, BUSY);

entity asend_fsm is
  port (
    aclk : in  signal logic;
    arst_n : in  signal logic;
    asend : in  signal logic;
    aack : in  signal logic;
    aready : out signal logic
  );
end entity asend_fsm;

architecture rtl of asend_fsm is

  signal state, next_state : state_type;

begin

  -- Reset process
  process(arst_n)
  begin
    if rising_edge(arst_n) then
      state <= READY;
    end if;
  end process;

  -- State transition process
  process(clk, state, asend, aack)
  begin
    if rising_edge(clk) then
      if state = READY then
        if asend then
          next_state <= BUSY;
        else
          next_state <= READY;
        end if;
      elsif state = BUSY then
        if aack then
          next_state <= READY;
        else
          next_state <= BUSY;
        end if;
      end if;
      state <= next_state;
    end if;
  end process;

  -- Output assignment
  aready <= state;

end architecture rtl;
