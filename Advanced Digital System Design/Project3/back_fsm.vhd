library ieee;
use ieee.std_logic_1164.all;

-- Define the state enumeration type
type state_type is (READY, WAIT);

entity back_fsm is
  port (
    bclk : in signal logic;
    brst_n : in signal logic;
    bload : in signal logic;
    b_en : in signal logic;
    bvalid : out signal logic
  );
end entity back_fsm;

architecture rtl of back_fsm is

  signal state, next_state : state_type;

begin

  -- Reset process
  process(brst_n)
  begin
    if rising_edge(brst_n) then
      state <= WAIT;
    end if;
  end process;

  -- State transition process
  process(bclk, state, bload, b_en)
  begin
    if rising_edge(bclk) then
