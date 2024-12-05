library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier is
    Port (
        Data_A  : in  std_logic_vector(17 downto 0);
        Data_B  : in  std_logic_vector(17 downto 0);
        Data_Out : out std_logic_vector(35 downto 0)
    );
end Multiplier;

architecture Behavioral of Multiplier is
begin
    process(Data_A, Data_B)
        variable product : unsigned(35 downto 0);
    begin
        product := unsigned(Data_A) * unsigned(Data_B);
        Data_Out <= std_logic_vector(product);
    end process;
end Behavioral;
