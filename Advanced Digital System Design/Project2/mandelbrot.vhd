library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ads.ads_fixed.all;
use work.ads_complex_pkg.all;

entity Mandelbrot_Compute_Point is
    generic (
        THRESHOLD   : ads_sfixed := to_ads_sfixed(4);  -- Threshold value
        ITERATIONS  : natural := 1000                   -- Maximum iterations
    );
    port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        c           : in  ads_complex;                  -- Input complex number
        iteration   : out natural                      -- Output iteration count
    );
end Mandelbrot_Compute_Point;

architecture Behavioral of Mandelbrot_Compute_Point is
begin
    process (CLK, RESET)
        variable z, z_next: ads_complex;
        variable iterations: natural := 0;
    begin
        if RESET = '1' then
            iteration <= 0;
        elsif rising_edge(CLK) then
            z := ads_cmplx(to_ads_sfixed(0), to_ads_sfixed(0)); -- Initialize z to 0

            while iterations < ITERATIONS loop
                z_next := z*z + c;  -- Mandelbrot iteration: z = z^2 + c
                
                if abs2(z_next) > THRESHOLD then
                    exit;  -- Break out of loop if threshold is exceeded
                end if;

                z := z_next;
                iterations := iterations + 1;
            end loop;

            iteration <= iterations;
        end if;
    end process;
end Behavioral;
