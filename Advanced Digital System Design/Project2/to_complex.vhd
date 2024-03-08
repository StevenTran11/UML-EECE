library ieee;
use ieee.std_logic_1164.all;
use work.vga_data.all;

entity to_complex is
    generic (
        VGA_RESOLUTION_INDEX : natural := 2  -- Index of the VGA resolution in vga_res_data
    );
    port (
        clock : in std_logic;
        point : in coordinate;
        complex_number : out complex
    );
end entity to_complex;

architecture behavior of to_complex is
    signal x_coordinate : integer range 0 to vga_res_data(VGA_RESOLUTION_INDEX).horizontal.active - 1;
    signal y_coordinate : integer range 0 to vga_res_data(VGA_RESOLUTION_INDEX).vertical.active - 1;
begin
    process (clock)
    begin
        if rising_edge(clock) then
            -- Extract X and Y coordinates from the point
            x_coordinate <= point.x;
            y_coordinate <= point.y;
            -- Convert X and Y coordinates into a complex number
            complex_number <= to_complex_number(x_coordinate, y_coordinate);
        end if;
    end process;
end architecture behavior;