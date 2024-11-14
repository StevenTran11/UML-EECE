library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end entity counter_tb;

architecture behavioral of counter_tb is
  -- Component declaration for the Unit Under Test (UUT)
  component counter is
    port (
      clk_10MHz : in  std_logic;
      rst       : in  std_logic;
      HEX00     : out std_logic;
      HEX01     : out std_logic;
	  HEX02     : out std_logic;
      HEX03     : out std_logic;
	  HEX04     : out std_logic;
	  HEX05     : out std_logic;
	  HEX06     : out std_logic;
      HEX07     : out std_logic
    );
  end component counter;

  -- Signals for the UUT
  signal clk_10MHz_sig : std_logic := '0';
  signal rst_sig       : std_logic := '0';
  signal HEX00_sig     : std_logic;
  signal HEX01_sig     : std_logic;
  signal HEX02_sig     : std_logic;
  signal HEX03_sig     : std_logic;
  signal HEX04_sig     : std_logic;
  signal HEX05_sig     : std_logic;
  signal HEX06_sig     : std_logic;
  signal HEX07_sig     : std_logic;

begin
  -- Instantiate the UUT
  uut: counter port map (
    clk_10MHz => clk_10MHz_sig,
    rst       => rst_sig,
    HEX00     => HEX00_sig,
    HEX01     => HEX01_sig,
    HEX02     => HEX02_sig,
    HEX03     => HEX03_sig,
    HEX04     => HEX04_sig,
    HEX05     => HEX05_sig,
    HEX06     => HEX06_sig,
    HEX07     => HEX07_sig
  );

  -- Clock generation process
  clk_process: process
  begin
    while true loop
      clk_10MHz_sig <= '0';
      wait for 5 ns;
      clk_10MHz_sig <= '1';
      wait for 5 ns;
    end loop;
  end process;

  -- Testbench stimulus process
  stim_process: process
  begin
    -- Initial reset
    rst_sig <= '1';
    wait for 10 ns;
    rst_sig <= '0';

    -- Wait for a few clock cycles to allow the counter to stabilize
    wait for 1000000 ms;

    -- Monitor the 7-segment displays and check for expected values
    -- (Adjust the simulation time and expected values as needed)
    wait;
  end process;
end architecture behavioral;