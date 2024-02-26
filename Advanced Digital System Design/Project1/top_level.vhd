library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.log2;	-- bring in log2()
use ieee.math_real.ceil;	-- bring in ceil()

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
	constant challenge_bits : positive := 8; -- Define the number of challenge bits
    constant delay_us : positive := 10;      -- Define the delay in microseconds
    constant clock_frequency : positive := 200; -- Define the clock frequency here (200 MHz)
	
	-- Signal declarations for internal signals
	signal counter_enable : std_logic;
	signal counter_reset : std_logic;
	signal challenge : std_logic_vector(challenge_bits - 1 downto 0);
	signal store_response : std_logic;
	signal done : std_logic;
	-- Add any other signals you may need here
	signal reset_asserted : std_logic := '1';  -- Initial state of reset signal
	signal enable_asserted : std_logic := '0';  -- Initial state of enable signal
	signal challenge_data : std_logic_vector(challenge_bits - 1 downto 0);
	signal enable : std_logic := '0';  -- Initial state of enable signal
	
	-- Component declaration for ro_puf
	component ro_puf is
		generic (
			ro_length:	positive := 13;
			ro_count:	positive := 16
		);
        port (
            reset:      in  std_logic;
            enable:     in  std_logic;
            challenge:  in  std_logic_vector(2*positive(ceil(log2(real(ro_count / 2)))) - 1 downto 0);
            response:   out std_logic
        );
    end component;
    -- Component declaration for control unit
	component control_unit is
		generic (
			challenge_bits:		positive := 8;
			clock_frequency:	positive := 200;	-- in MHz
			delay_us:			positive := 10		-- in microseconds
		);
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
		-- Step 7: Store the result in a RAM using the challenge as an address

		wait;
	end process control_process;
    -- Instantiation of ro_puf
    puf_inst : ro_puf
        generic map (
            ro_length => ro_length,
            ro_count => ro_count
        )
        port map (
            reset => reset,
            enable => enable,
            challenge => challenge,
            response => response
        );

    -- Instantiation of control unit
	control_inst : control_unit
		generic map (
			challenge_bits => challenge_bits,
			clock_frequency => clock_frequency,
			delay_us => delay_us 
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