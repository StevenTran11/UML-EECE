library ieee;
use ieee.std_logic_1164.all;
library vga;
library ads;
USE vga.vga_data.all;
USE ads.ads_fixed.all;
USE ads.ads_complex_pkg.all;

entity to_complex is
    generic (
        vga_res: vga_timing := vga_res_default
    );
    port (
        clock : in std_logic;
        point : in coordinate;
        complex_number : out ads_complex
    );
end entity to_complex;

architecture behavior of to_complex is
    signal x_coordinate : integer range 0 to vga_res.horizontal.active - 1;
    signal y_coordinate : integer range 0 to vga_res.vertical.active - 1;
begin
    process (clock)
    begin
    if rising_edge(clock) then
        -- Extract X and Y coordinates from the point
        x_coordinate <= point.x;
        y_coordinate <= point.y;
        
        -- Assuming to_complex_number function exists and converts to ads_sfixed
        complex_number <= ads_cmplx(to_ads_sfixed(x_coordinate), to_ads_sfixed(y_coordinate));
    end if;
    end process;
end architecture behavior;