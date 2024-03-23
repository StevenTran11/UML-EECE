use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;

library vga;
use vga.vga_data.vga_timing;
use vga.vga_data.vga_res_640x480;

library de10_lite;
use de10_lite.color_pkg.color;
use de10_lite.color_pkg.colors_per_channel;
use de10_lite.toplevel;

entity tb_toplevel is
	generic (
		vga_res:	vga_timing := vga_res_640x480;
		pipeline_depth:	positive := 16
	);
end entity tb_toplevel;

architecture test of tb_toplevel is
	-- components
	component toplevel is
		generic (
			vga_res: vga_timing		:= vga_res_640x480;
			pipeline_depth:	positive	:= 16;
			threshold:	ads_sfixed	:= to_ads_sfixed(16)
		);
		port (
			clock:	in	std_logic;
			reset:	in	std_logic;
	
			mode_sw:	in	std_logic;
			action:		in	std_logic;
	
			rgb_out:	out	color;
	
			h_sync:		out	std_logic;
			v_sync:		out	std_logic;
	
			system_ready:	out	boolean
		);
	end component toplevel;

	-- functions
	function vga_horizontal
		return positive
	is
	begin
		return (vga_res.horizontal.active + vga_res.horizontal.front_porch
					+ vga_res.horizontal.sync_width
					+ vga_res.horizontal.back_porch);
	end function vga_horizontal;

	function vga_vertical
		return positive
	is
	begin
		return (vga_res.vertical.active + vga_res.vertical.front_porch
					+ vga_res.vertical.sync_width
					+ vga_res.vertical.back_porch);
	end function vga_vertical;

	function vga_total_pixels
		return positive
	is
	begin
		return vga_horizontal * vga_vertical;
	end function vga_total_pixels;

	-- signals
	signal clock: std_logic := '0';
	signal reset: std_logic := '0';

	signal mode_sw: std_logic := '0';
	signal action: std_logic := '0';

	signal rgb_out: color;
	signal h_sync, v_sync: std_logic;
	signal system_ready: boolean;

	signal test_done: boolean := false;
begin
	clock <= not clock after 1 ps when not test_done else '0';

	dut: toplevel
		generic map (
			pipeline_depth =>	pipeline_depth
		)
		port map (
			clock =>	clock,
			reset =>	reset,
			mode_sw =>	mode_sw,
			action =>	action,
			rgb_out =>	rgb_out,
			h_sync =>	h_sync,
			v_sync =>	v_sync,
			system_ready =>	system_ready
		);

	stimulus: process is

		procedure do_reset
		is
		begin
			reset <= '0';
			wait until rising_edge(clock);
			wait until rising_edge(clock);
			reset <= '1';
		end procedure do_reset;

	begin

		-- write image header

		do_reset; --(clock, reset);

		-- wait for pipeline to be full
		while not system_ready loop
			wait until rising_edge(clock);
		end loop;

		-- go through every point and write the output

		mode_sw <= '1';

		-- render the next fractal by going through every point and write the
		-- data

		-- ensure pipeline is empty before terminating the test fixture

		test_done <= true;
		wait;
	end process stimulus;

end architecture test;