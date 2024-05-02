library ieee;
use ieee.std_logic_1164.all;

package seven_segment_pkg is
    -- Q1
    -- Define the seven_segment_config record type
    type seven_segment_config is record
        a, b, c, d, e, f, g : std_logic;
    end record;

    -- Define an unconstrained array type based on the seven_segment_config record
    type seven_segment_array is array (natural range <>) of seven_segment_config;
    -- Q2
    -- Define the enumerated type lamp_configuration
    type lamp_configuration is (common_anode, common_cathode);

    -- Define a constant of type lamp_configuration
    constant default_lamp_config : lamp_configuration := common_anode; -- Set it to your board's configuration

    -- Define the subtype hex_digit constrained to the range of the seven_segment_table
    subtype hex_digit is natural range seven_segment_table'range;
    -- Q4
    -- Define the get_hex_digit function prototype
    function get_hex_digit (
        digit: in hex_digit;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config;
    -- Q5
    -- Define the lamps_off function prototype
    function lamps_off (
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config;

end package seven_segment_pkg;

package body seven_segment_pkg is
    -- Q3
    -- Define the constant seven_segment_table
    constant seven_segment_table : seven_segment_array(0 to 15) := (
        -- Hexadecimal 0
        (a => '1', b => '1', c => '1', d => '1', e => '1', f => '1', g => '0'),
        -- Hexadecimal 1
        (a => '0', b => '1', c => '1', d => '0', e => '0', f => '0', g => '0'),
        -- Hexadecimal 2
        (a => '1', b => '1', c => '0', d => '1', e => '1', f => '0', g => '1'),
        -- Hexadecimal 3
        (a => '1', b => '1', c => '1', d => '1', e => '0', f => '0', g => '1'),
        -- Hexadecimal 4
        (a => '0', b => '1', c => '1', d => '0', e => '0', f => '1', g => '1'),
        -- Hexadecimal 5
        (a => '1', b => '0', c => '1', d => '1', e => '0', f => '1', g => '1'),
        -- Hexadecimal 6
        (a => '1', b => '0', c => '1', d => '1', e => '1', f => '1', g => '1'),
        -- Hexadecimal 7
        (a => '1', b => '1', c => '1', d => '0', e => '0', f => '0', g => '0'),
        -- Hexadecimal 8
        (a => '1', b => '1', c => '1', d => '1', e => '1', f => '1', g => '1'),
        -- Hexadecimal 9
        (a => '1', b => '1', c => '1', d => '1', e => '0', f => '1', g => '1'),
        -- Hexadecimal A
        (a => '1', b => '1', c => '1', d => '0', e => '1', f => '1', g => '1'),
        -- Hexadecimal B
        (a => '0', b => '0', c => '1', d => '1', e => '1', f => '1', g => '1'),
        -- Hexadecimal C
        (a => '1', b => '0', c => '0', d => '1', e => '1', f => '1', g => '0'),
        -- Hexadecimal D
        (a => '0', b => '1', c => '1', d => '1', e => '1', f => '0', g => '1'),
        -- Hexadecimal E
        (a => '1', b => '0', c => '0', d => '1', e => '1', f => '1', g => '1'),
        -- Hexadecimal F
        (a => '1', b => '0', c => '0', d => '0', e => '1', f => '1', g => '1')
    );
    -- Q4 - This does not activate the lamp
    -- Define the implementation of the get_hex_digit function
    function get_hex_digit (
        digit: in hex_digit;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config is
    begin
        return seven_segment_table(digit);
    end function;
    -- Q5 
    -- Define the implementation of the lamps_off function
    function lamps_off (
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config is
        variable result : seven_segment_config;
    begin
        -- Set all lamps off based on the lamp_mode
        case lamp_mode is
            when common_anode =>
                result := (a => '1', b => '1', c => '1', d => '1', e => '1', f => '1', g => '1');
            when common_cathode =>
                result := (a => '0', b => '0', c => '0', d => '0', e => '0', f => '0', g => '0');
        end case;

        return result;
    end function;

end package body seven_segment_pkg;