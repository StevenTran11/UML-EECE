library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package seven_segment_pkg is
    type seven_segment_config is
    record
        a, b, c, d, e, f, g : std_logic;
    end record seven_segment_config;

    -- Define an unconstrained array type based on the seven_segment_config record
    type seven_segment_array is array (natural range<>) of seven_segment_config;
    type num_arr is array (natural range<>) of std_logic_vector(0 to 3);

    -- Define the enumerated type lamp_configuration
    type lamp_configuration is (common_anode, common_cathode);

    -- Define a constant of type lamp_configuration    
    constant default_lamp_config: lamp_configuration := common_anode;

    -- Define the subtype hex_digit constrained to the range of the seven_segment_table
    constant seven_segment_table : seven_segment_array(0 to 15);
    subtype hex_digit is natural range 0 to 15;
    subtype hex_number is natural range 0 to 2**12 - 1;
    
    function get_hex_digit(
        digit: in hex_digit;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config;
end package seven_segment_pkg;

package body seven_segment_pkg is
    -- Define the contents of seven_segment_table in the package body
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

    function get_hex_digit(
        digit: in hex_digit;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config
    is
        variable ret: seven_segment_config;
    begin
        ret := seven_segment_table(digit);
        if lamp_mode = common_anode then
            ret.a := not ret.a;
            ret.b := not ret.b;
            ret.c := not ret.c;
            ret.d := not ret.d;
            ret.e := not ret.e;
            ret.f := not ret.f;
            ret.g := not ret.g;
        end if;
        return ret;
    end function get_hex_digit;
end package body seven_segment_pkg;
