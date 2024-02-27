library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity ring_oscillator is
    generic (
        ro_length:  positive := 13
    );
    port (
        enable:     in  std_logic;
        osc_out:    out std_logic
    );
end entity ring_oscillator;

architecture gen of ring_oscillator is
	-- Declare signals
	type t_inverter_outputs is array(0 to ro_length-1) of std_logic;
	signal inverter_outputs:   t_inverter_outputs;
	signal nand_input:         std_logic;
	signal nand_output:        std_logic;
	 
	component own_NAND2 is
		port (
		  A, B: in std_logic;
		  output: out std_logic
		);
	end component;
	
	component inverter is
		port (
		  input: in std_logic;
		  output: out std_logic
		);
	end component;
	
begin
    -- Check if ro_length is odd
    assert ro_length mod 2 /= 0
        report "ro_length must be an odd number"
        severity failure;
	assert ro_length > 1
        report "Must include inverter"
        severity failure;

    -- Instantiate NAND gate
    self_nand2: own_NAND2
        port map (
            A => enable,
            B => inverter_outputs(ro_length-1),
            output => nand_output
        );

	INVERTER1: inverter port map (
		input => nand_output,
		output => inverter_outputs(1)
	);

    -- Instantiate inverters
	inverters: for i in 2 to ro_length - 1 generate
	begin
		INVERTERS: inverter
			port map (
				input => inverter_outputs(i - 1),
				output => inverter_outputs(i)
			);
	end generate inverters;

    -- Connect the output of the last inverter to one input of the NAND gate
    inverter_outputs(ro_length-1) <= nand_input;

    -- Drive osc_out with the output of the last inverter in the chain
    osc_out <= inverter_outputs(ro_length-1);
end architecture gen;
