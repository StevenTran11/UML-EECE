library ieee;
use ieee.std_logic_1164.all;

-- Define your own package for ads_sfixed if not already defined
-- package ads_pkg is
--     type ads_sfixed is ...
-- end package ads_pkg;

entity YourEntity is
    generic (
        threshold : ads_sfixed;  -- Generic parameter for threshold
        stage_number : natural  -- Generic parameter for stage number
    );
    port (
        reset : in std_logic;
        clock : in std_logic;
        stage_input : in ads_complex;  -- Using the ads_complex record type
        stage_output : out ads_complex  -- Using the ads_complex record type
    );
end entity YourEntity;
