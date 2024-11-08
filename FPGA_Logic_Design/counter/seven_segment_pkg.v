module seven_segment_pkg;

    // Define the seven_segment_config struct
    typedef struct {
        logic a, b, c, d, e, f, g;
    } seven_segment_config;

    // Define the seven_segment_array type
    typedef seven_segment_config seven_segment_array[16];

    // Define the lamp_configuration enum
    typedef enum logic {
        common_anode,
        common_cathode
    } lamp_configuration;

    // Define the default lamp configuration
    localparam lamp_configuration default_lamp_config = common_anode;

    // Define the seven_segment_table constant
    seven_segment_array seven_segment_table = '{
        // Hexadecimal 0
        '{1, 1, 1, 1, 1, 1, 0},
        // Hexadecimal 1
        '{0, 1, 1, 0, 0, 0, 0},
        // Hexadecimal 2
        '{1, 1, 0, 1, 1, 0, 1},
        // Hexadecimal 3
        '{1, 1, 1, 1, 0, 0, 1},
        // Hexadecimal 4
        '{0, 1, 1, 0, 0, 1, 1},
        // Hexadecimal 5
        '{1, 0, 1, 1, 0, 1, 1},
        // Hexadecimal 6
        '{1, 0, 1, 1, 1, 1, 1},
        // Hexadecimal 7
        '{1, 1, 1, 0, 0, 0, 0},
        // Hexadecimal 8
        '{1, 1, 1, 1, 1, 1, 1},
        // Hexadecimal 9
        '{1, 1, 1, 1, 0, 1, 1},
        // Hexadecimal A
        '{1, 1, 1, 0, 1, 1, 1},
        // Hexadecimal B
        '{0, 0, 1, 1, 1, 1, 1},
        // Hexadecimal C
        '{1, 0, 0, 1, 1, 1, 0},
        // Hexadecimal D
        '{0, 1, 1, 1, 1, 0, 1},
        // Hexadecimal E
        '{1, 0, 0, 1, 1, 1, 1},
        // Hexadecimal F
        '{1, 0, 0, 0, 1, 1, 1}
    };

    // Function to get the hex digit configuration
    function seven_segment_config get_hex_digit(
        input int digit,
        input lamp_configuration lamp_mode = default_lamp_config
    );
        seven_segment_config ret;
        ret = seven_segment_table[digit];
        if (lamp_mode == common_anode) begin
            ret.a = ~ret.a;
            ret.b = ~ret.b;
            ret.c = ~ret.c;
            ret.d = ~ret.d;
            ret.e = ~ret.e;
            ret.f = ~ret.f;
            ret.g = ~ret.g;
        end
        return ret;
    endfunction

endmodule