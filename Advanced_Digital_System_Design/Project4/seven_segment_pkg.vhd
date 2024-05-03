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
    subtype hex_digit is natural range seven_segment_table'range;
    subtype hex_number is natural range 0 to 2**12 - 1;
    
    function get_hex_digit(
        digit: in hex_digit;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config;
    
    function lamps_off(
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config;
    
    function get_hex_number(
        num: std_logic_vector(23 downto 0);
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_array;

    function to_bcd(
        data_value: in std_logic_vector(15 downto 0)
    ) return std_logic_vector;

    function concatenate_segments(
        segments : seven_segment_array(5 downto 0)
    ) return std_logic_vector;
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

    function lamps_off(
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config
    is
        variable ret: seven_segment_config;
    begin
        if lamp_mode = common_cathode then
            ret := ('0', '0', '0', '0', '0', '0', '0');
        else
            ret := ('1', '1', '1', '1', '1', '1', '1');
        end if;
        return ret;
    end function lamps_off;

    function get_hex_number(
        num: std_logic_vector(23 downto 0);
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_array
    is
        variable ret: seven_segment_array(5 downto 0);
    begin
        -- Convert binary to hexadecimal
        for i in ret'range loop
           ret(i) := get_hex_digit(to_integer(unsigned(num(4 * i + 3 downto 4 * i))), lamp_mode);
        end loop;
        return ret;
    end function get_hex_number;

    function to_bcd (
        data_value: in std_logic_vector(15 downto 0)
    ) return std_logic_vector
    is
        variable ret: std_logic_vector(19 downto 0);
        variable temp: std_logic_vector(data_value'range);
    begin
        temp := data_value;
        ret := (others => '0');
        for i in data_value'range loop
            for j in 0 to ret'length/4 - 1 loop
                if unsigned(ret(4*j + 3 downto 4*j)) >= 5 then
                    ret(4*j + 3 downto 4*j) := std_logic_vector(unsigned(ret(4*j + 3 downto 4 * j)) + 3);
                end if;
            end loop;
            ret := ret(ret'high -1 downto 0) & temp(temp'high);
            temp := temp(temp'high - 1 downto 0) & '0';
        end loop;
        return ret;
    end function to_bcd;

    function concatenate_segments(segments : seven_segment_array(5 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(41 downto 0); -- 6 segments * 7 bits each
    begin
        -- Loop through each seven_segment_config in the array
        for i in segments'range loop
            -- Concatenate from g to a for each seven_segment_config and assign to the correct position
            result(7 * i + 6 downto i * 7) := segments(i).g & segments(i).f & segments(i).e & segments(i).d & segments(i).c & segments(i).b & segments(i).a;
        end loop;
        return result;
    end function;
end package body seven_segment_pkg;
