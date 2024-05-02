library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
	generic (
		ro_length:	positive := 13;
		ro_count:	positive := 16
	);
	port (
		clock:	in	std_logic;	-- global clock input, 50 MHz clock
		reset:	in	std_logic	-- global asynchronous reset, button
	);
end entity toplevel;

architecture top of toplevel is
    -- Signal declarations for internal signals
    signal counter_enable : std_logic;
    signal counter_reset : std_logic;
    signal challenge : std_logic_vector(challenge_bits - 1 downto 0);
    signal store_response : std_logic;
    signal done : std_logic;
    -- Add any other signals you may need here
	
	-- Component declaration for ro_puf
	component ro_puf is
        port (
            reset:      in  std_logic;
            enable:     in  std_logic;
            challenge:  in  std_logic_vector(2*positive(ceil(log2(real(ro_count / 2)))) - 1 downto 0);
            response:   out std_logic
        );
    end component;
    -- Component declaration for control unit
	component control_unit is
		port (
			clock:	in	std_logic;
			reset:	in	std_logic;
			enable:	in	std_logic;
			
			counter_enable:	out	std_logic;
			counter_reset:	out	std_logic;
			challenge:		out	std_logic_vector(challenge_bits - 1 downto 0);
			store_response:	out	std_logic;
			done:	out	std_logic
		);
	end component;
    -- Component declaration for BRAM
	
    -- Add BRAM component declaration here
begin
	-- Process for controlling interactions with the ro_puf entity
	control_process: process
	begin
		-- Step 1: Assert the reset signal to the ro_puf entity
		reset <= reset_asserted;
		wait for 10 ns;  -- Adjust delay as needed

		-- Step 2: Provide the challenge to the ro_puf entity
		challenge <= challenge_data;
		
		-- Step 3: Deassert the reset signal to the ro_puf entity
		reset <= not reset_asserted;
		wait for 10 ns;  -- Adjust delay as needed
		
		-- Step 4: Assert the enable signal to the ro_puf entity
		enable <= enable_asserted;
		wait for 10 ns;  -- Adjust delay as needed
		
		-- Step 5: Wait for probe_delay µs
		wait for probe_delay;
		
		-- Step 6: Deassert the enable signal to the ro_puf entity
		enable <= not enable_asserted;
		
		-- Repeat the process if needed
		wait;
	end process control_process;
    -- Instantiation of ro_puf
    puf_inst: ro_puf
        generic map (
            ro_length => ro_length,
            ro_count => ro_count
        )
        port map (
            reset => reset,
            enable => enable,   -- Assuming you have an 'enable' signal defined
            challenge => challenge,   -- Assuming you have a 'challenge' signal defined
            response => response    -- Assuming you have a 'response' signal defined
        );
    -- Instantiation of control unit
	cont_inst: control_unit
		generic (
			challenge_bits => challenge_bits,
			clock_frequency => clock_frequency,	-- in MHz
			delay_us => delay_us-- in microseconds
		);
		port map (
			clock => clock,
			reset => reset,
			enable => enable,
			counter_enable => counter_enable,
			counter_reset => counter_reset,
			challenge => challenge,
			store_response => store_response,
			done => done
		);
    -- BRAM
	-- create a BRAM using the IP Catalog, instance it here
	-- make sure you enable the In-System Memory Viewer!

end architecture top;