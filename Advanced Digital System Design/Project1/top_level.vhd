library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.log2;	-- bring in log2()
use ieee.math_real.ceil;	-- bring in ceil()

entity toplevel is
	generic (
		ro_length:	positive := 13;
		ro_count:	positive := 16;
		challenge_bits : positive := 8; -- Define the number of challenge bits
		delay_us : positive := 10;      -- Define the delay in microseconds
		clock_frequency : positive := 200	-- Define the clock frequency here (200 MHz)
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
	signal response : std_logic;
	-- Add any other signals you may need here
	signal reset_asserted : std_logic := '1';  -- Initial state of reset signal
	signal enable_asserted : std_logic := '0';  -- Initial state of enable signal
	signal challenge_data : std_logic_vector(challenge_bits - 1 downto 0);
	signal enable : std_logic := '0';  -- Initial state of enable signal
	signal reset1 : std_logic := '0';  -- Initial state of reset1 signal
	
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
	-- Step 1: Assert the reset signal to the ro_puf entity
	-- Step 2: Provide the challenge to the ro_puf entity
	control_process: process(counter_reset) is
	begin
		if rising_edge(counter_reset) then
			reset1 <= reset_asserted;
			challenge <= challenge_data;
		end if;
	end process control_process;
	-- Step 3: Deassert the reset signal to the ro_puf entity
	-- Step 4: Assert the enable signal to the ro_puf entity
	-- Step 5: Wait for delay_us µs
	-- Step 6: Deassert the enable signal to the ro_puf entity
	deassert: process (counter_enable) is
	begin
		if rising_edge(counter_enable) then
			reset1 <= not reset_asserted;	
			enable <= enable_asserted;
			wait for delay_us * 1 us;
			enable <= not enable_asserted;
		end if;
	end process deassert;
	-- Step 7: Store the result in a RAM using the challenge as an address
	store_process: process (store_response) is
	begin
		if rising_edge(store_response) then
			
		end if;
	end process store_process;
    -- Instantiation of ro_puf
    puf_inst : ro_puf
        generic map (
            ro_length => ro_length,
            ro_count => ro_count
        )
        port map (
            reset => reset1,
            enable => enable,
            challenge => challenge,
            response => response
        );

    -- Instantiation of control unit
	control_inst : control_unit
		port map (
			clock => clock,
			reset => reset1,
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