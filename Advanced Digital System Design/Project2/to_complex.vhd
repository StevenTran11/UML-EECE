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
    signal x_coordinate : ads_sfixed;
    signal y_coordinate : ads_sfixed;
begin
    -- Assuming to_complex_number function exists and converts to ads_sfixed
    complex_number <= ads_cmplx(x_coordinate, y_coordinate);


    --process (clock)
    --begin
    --    if rising_edge(clock) then
			x_coordinate <= to_ads_sfixed(3.2/real(vga_res.horizontal.active)) * to_ads_sfixed(point.x) - to_ads_sfixed(2.2);
			y_coordinate <= to_ads_sfixed(1.2) - to_ads_sfixed(2.4/real(vga_res.vertical.active)) * to_ads_sfixed(point.y);
    --    end if;
    --end process;
end architecture behavior;