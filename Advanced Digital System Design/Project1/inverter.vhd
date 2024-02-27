library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity inverter is
port (input: in STD_LOGIC;
      output: out STD_LOGIC
		);
end entity inverter; 

architecture BEHAVIORAL of inverter is
begin
  output <= NOT input;
end BEHAVIORAL;