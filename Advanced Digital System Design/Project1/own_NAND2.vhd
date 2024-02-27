library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity own_NAND2 is
port (A: in STD_LOGIC;
		B: in STD_LOGIC;
      output: out STD_LOGIC
		);
end entity own_NAND2; 

architecture BEHAVIORAL of own_NAND2 is
begin
  output <= A NAND B;
end BEHAVIORAL;