library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Divide_By_100 is
    Port (
        Data_A  : in  std_logic_vector(17 downto 0);  -- Dividend
        Data_Out : out std_logic_vector(11 downto 0)  -- Quotient
    );
end Divide_By_100;

architecture Behavioral of Divide_By_100 is
    -- Constant representing the scaled reciprocal of 100 (2^24 / 100)
    constant SCALE_FACTOR : std_logic_vector(17 downto 0) := "101000111101011100";

    -- Declare the Multiplier component
    component Multiplier is
        Port (
            Data_A  : in  std_logic_vector(17 downto 0);
            Data_B  : in  std_logic_vector(17 downto 0);
            Data_Out : out std_logic_vector(35 downto 0)
        );
    end component;

    -- Signals to connect to the multiplier
    signal Mul_Result : std_logic_vector(35 downto 0);

begin

    -- Instantiate the Multiplier component to perform multiplication
    U1: Multiplier
        port map (
            Data_A => Data_A,
            Data_B => SCALE_FACTOR,
            Data_Out => Mul_Result
        );

    -- Extract the quotient (upper 12 bits from the 36-bit result)
    process(Mul_Result)
    begin
        Data_Out <= Mul_Result(35 downto 24);
    end process;

end Behavioral;
