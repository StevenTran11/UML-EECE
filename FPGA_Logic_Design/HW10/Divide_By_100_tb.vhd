library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Divide_By_100_tb is

end Divide_By_100_tb;

architecture Behavioral of Divide_By_100_tb is
    component Divide_By_100 is
        Port (
            Data_A  : in  std_logic_vector(17 downto 0);
            Data_Out : out std_logic_vector(17 downto 0)
        );
    end component;

    signal Data_A  : std_logic_vector(17 downto 0) := (others => '0');
    signal Data_Out : std_logic_vector(17 downto 0);
	signal Test : std_logic_vector(35 downto 0);

begin
    uut: Divide_By_100
        port map (
            Data_A => Data_A,
            Data_Out => Data_Out
        );

    -- Test Process
    stimulus_process: process
    begin
        -- Test Case 1: 0 / 100 = 0
        Data_A <= "000000000000000000"; -- 0
        wait for 10 ns;

        -- Test Case 2: 100 / 100 = 1
        Data_A <= "000000000001100100"; -- 100
        wait for 10 ns;

        -- Test Case 3: 1000 / 100 = 10
        Data_A <= "000000001111101000"; -- 1000
        wait for 10 ns;

        -- Test Case 4: 1234 / 100 = 12 (approximation)
        Data_A <= "000000010011010010"; -- 1234
        wait for 10 ns;

        -- Test Case 5: 9999 / 100 = 99 (approximation)
        Data_A <= "000010011100001111"; -- 9999
        wait for 10 ns;

        -- Test Case 6: Max value (262143) / 100 = 2621
        Data_A <= "111111111111111111"; -- 262143 (max 18-bit value)
        wait for 10 ns;
		
		-- Test Case 6: Max value (50000) / 100 = 500
        Data_A <= "001100001101010000"; -- 50000(max 18-bit value)
        wait for 10 ns;

        -- End of simulation
        wait;
    end process;

end Behavioral;
