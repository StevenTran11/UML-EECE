library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

entity color_map is
    generic (
        total_stages : natural := 25
    );
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        stage_input : in complex_record;
        vga_red   : out std_logic_vector(3 downto 0);  -- Red component (4 bits)
        vga_green : out std_logic_vector(3 downto 0);  -- Green component (4 bits)
        vga_blue  : out std_logic_vector(3 downto 0)  -- Blue component (4 bits)
    );
end entity color_map;

architecture rtl of color_map is
begin
    process(clk, reset) is
    begin
        if reset = '1' then
            vga_red   <= (others => '0');
            vga_green <= (others => '0');
            vga_blue  <= (others => '0');
        elsif rising_edge(clk) then
            if stage_input.stage_data = total_stages then  -- Assuming total_stages is declared elsewhere
            -- Black color for maximum iterations
            vga_red   <= (others => '0');
            vga_green <= (others => '0');
            vga_blue  <= (others => '0');  -- Set all components to 0 for black
            else
            -- White color for non-maximum iterations
            vga_red   <= (others => '1');
            vga_green <= (others => '1');
            vga_blue  <= (others => '1');
            end if;
        end if;
    end process;
end architecture rtl;
