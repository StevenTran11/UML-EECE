library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

entity vga_fsm is
	generic (
		vga_res:	vga_timing := vga_res_default
	);
	port (
		vga_clock:		in	std_logic;
		reset:			in	std_logic;

		point:			out	coordinate;
		point_valid:	out	boolean;

		h_sync:			out	std_logic;
		v_sync:			out std_logic
	);
end entity vga_fsm;

architecture fsm of vga_fsm is
	-- any internal signals you may need
	-- Define internal signals
	signal current_point: coordinate := make_coordinate(0, 0);
begin
	-- implement methodology to drive outputs here
	-- use vga_data functions and types to make your life easier
	process(vga_clock, reset)
    begin
        if reset = '0' then
            -- Reset the FSM and any internal signals
            current_point <= make_coordinate(0, 0);
            --h_sync <= '1';
            --v_sync <= '1';
            -- Optionally, set any other initial states
        elsif rising_edge(vga_clock) then
            current_point <= next_coordinate(current_point, vga_res);
        end if;
    end process;
	h_sync <= do_horizontal_sync(current_point, vga_res);
	v_sync <= do_vertical_sync(current_point, vga_res);
	point <= current_point;
	point_valid <= point_visible(current_point);
end architecture fsm;