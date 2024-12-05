library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier_tb is
-- Testbench has no ports
end Multiplier_tb;

architecture Behavioral of Multiplier_tb is
    -- Component declaration
    component Multiplier is
        Port (
            Data_A  : in  std_logic_vector(17 downto 0);
            Data_B  : in  std_logic_vector(17 downto 0);
            Data_Out : out std_logic_vector(35 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal Data_A  : std_logic_vector(17 downto 0) := (others => '0');
    signal Data_B  : std_logic_vector(17 downto 0) := (others => '0');
    signal Data_Out : std_logic_vector(35 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: Multiplier
        port map (
            Data_A => Data_A,
            Data_B => Data_B,
            Data_Out => Data_Out
        );

    -- Test Process
    stimulus_process: process
    begin
        -- Test Case 1: 0 * 0 = 0
        Data_A <= "000000000000000000"; -- 0
        Data_B <= "000000000000000000"; -- 0
        wait for 10 ns;

        -- Test Case 2: 1 * 1 = 1
        Data_A <= "000000000000000001"; -- 1
        Data_B <= "000000000000000001"; -- 1
        wait for 10 ns;

        -- Test Case 3: Max * 1
        Data_A <= "111111111111111111"; -- Maximum 18-bit value
        Data_B <= "000000000000000001"; -- 1
        wait for 10 ns;

        -- Test Case 4: Max * Max
        Data_A <= "111111111111111111"; -- Maximum 18-bit value
        Data_B <= "111111111111111111"; -- Maximum 18-bit value
        wait for 10 ns;

        -- Test Case 5: Random values
        Data_A <= "000000000000001011"; -- 11
        Data_B <= "000000000000000101"; -- 5
        wait for 10 ns;
		
		--Test Case 6: Random values
        Data_A <= "001100001101010000"; -- 50000
        Data_B <= "000000101000111101"; -- 2621
        wait for 10 ns;

        -- End of simulation
        wait;
    end process;

end Behavioral;
