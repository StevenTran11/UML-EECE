library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ads;
use ads.ads_fixed.all;
use ads.ads_complex.all;

entity pipeline_stage is
    generic (
        threshold : ads_sfixed := 4; 
        stage_number : natural 
    );
    port (
        reset : in std_logic;
        clk : in std_logic;
        stage_input : in complex_record; -- Input signal of type complex_record
        stage_output : out complex_record -- Output signal of type complex_record
    );
end entity pipeline_stage;

architecture rtl of pipeline_stage is
    -- add any signals you may need
begin
    -- perform computations and complete assignments
    stage: process(clk, reset) is
    begin
        if reset = '0' then
        -- reset pipeline stage
        stage_output.stage_data <= 0; -- Initialize to 0
        stage_output.c <= 0; -- Initialize to 0
        stage_output.z <= 0; -- Initialize to 0
        stage_output.stage_overflow <= false; -- Initialize to false
        elsif rising_edge(clk) then
            if stage_input.stage_overflow = true then
                stage_output.stage_data <= stage_input.stage_data;
            else
                stage_output.stage_data <= stage_number;
            end if;
            stage_output.c <= stage_input.c;
            stage_output.z <= stage_input.z * stage_input.z + stage_input.c;
            if abs2(stage_input.z) > threshold then
                stage_output.stage_overflow <= stage_input.stage_overflow;
            else
                stage_output.stage_overflow <= false;
            end if;
        end if;
    end process stage;
end architecture rtl;
    