library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

library vga;
use vga.vga_data.all;

entity tb_project2 is
end entity tb_project2;

architecture test of tb_project2 is

	component project2 is
	    generic (
	        total_stages : natural := 25;  -- Adjust the number of pipeline stages as needed
	        entities     : natural := 4;
	        vga_res: vga_timing := vga_res_default;
			threshold : ads_sfixed := to_ads_sfixed(4)
	    );
	    port (
	        mode_in         : in std_logic; --SW9 on Board PIN_F15
	        -- Define ports here if needed
	        reset           : in std_logic;
	        vga_clock       : in std_logic; -- LOC="PIN_V10";;
	        -- VGA signals
	        vga_red         : out std_logic_vector(3 downto 0); --LOC="PIN_AA1, PIN_V1, PIN_Y2, PIN_Y1";  -- Red components (LSB to MSB)
	        vga_green       : out std_logic_vector(3 downto 0); --LOC="PIN_W1, PIN_T2, PIN_R2, PIN_R1";  -- Green components (LSB to MSB)
	        vga_blue        : out std_logic_vector(3 downto 0); --LOC="PIN_P1, PIN_T1, PIN_P4, PIN_N2";   -- Blue components (LSB to MSB)
	        h_syncff          : out std_logic; -- LOC="PIN_N3";
	        v_syncff          : out std_logic --LOC="PIN_N1"
	    );
	end component project2;

	signal mode_in, reset, vga_clock: std_logic := '0';
	signal vga_red, vga_green, vga_blue: std_logic_vector(3 downto 0);

	signal h_syncff, v_syncff: std_logic;

	signal test_done: boolean := false;
begin

	vga_clock <= not vga_clock after 1 ps when not test_done else '0';

	dut: project2
		port map (
			mode_in => mode_in,
			reset => reset,
			vga_clock => vga_clock,
			vga_red =>		vga_red,
			vga_green =>	vga_green,
			vga_blue =>		vga_blue,
			h_syncff => h_syncff,
			v_syncff => v_syncff
		);

	stimulus: process is
	begin
		reset <= '0';
		wait until rising_edge(vga_clock);
		reset <= '1';

		for i in 0 to 40 loop
			wait until rising_edge(vga_clock);
		end loop;

		test_done <= true;
		wait;
	end process stimulus;

end architecture test;
