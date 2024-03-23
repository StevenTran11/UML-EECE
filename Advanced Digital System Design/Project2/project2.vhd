library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

library vga;
USE vga.vga_data.all;

library ads;
USE ads.ads_fixed.all;
USE ads.ads_complex_pkg.all;

entity project2 is
    generic (
        total_stages : natural := 25;  -- Adjust the number of pipeline stages as needed
        entities     : natural := 3;
        vga_res: vga_timing := vga_res_default;
		threshold : ads_sfixed := to_ads_sfixed(4)
    );
    port (
        mode_in         : in std_logic; --SW9 on Board PIN_F15
        -- Define ports here if needed
        reset           : in std_logic;
        vga_clock       : in std_logic; -- LOC="PIN_V10";;
        -- VGA signals
        vga_red         : out std_logic_vector(3 downto 0); --LOC="PIN_AA1, PIN_V1, PIN_Y2, PIN_Y1";  -- Red components (LSB to MSB)
        vga_green       : out std_logic_vector(3 downto 0); --LOC="PIN_W1, PIN_T2, PIN_R2, PIN_R1";  -- Green components (LSB to MSB)
        vga_blue        : out std_logic_vector(3 downto 0); --LOC="PIN_P1, PIN_T1, PIN_P4, PIN_N2";   -- Blue components (LSB to MSB)
        h_syncff          : out std_logic; -- LOC="PIN_N3";
        v_syncff          : out std_logic --LOC="PIN_N1"
    );
end entity project2;

architecture Behavioral of project2 is

    -- Component declarations
	 component PLL is
        port (
            inclk0 : in std_logic;
            c0 : out std_logic
            -- Add other PLL ports as needed
        );
    end component;
	 
--    component vga_fsm is
--        generic (
--            vga_res: vga_timing := vga_res_default
--        );
--        port (
--            vga_clock:      in std_logic;
--            reset:          in std_logic;
--            point:          out coordinate;
--            point_valid:    out boolean;
--            h_sync:         out std_logic;
--            v_sync:         out std_logic
--        );
--    end component vga_fsm;
--
--    component to_complex is
--        generic (
--            vga_res: vga_timing := vga_res_default
--        );
--        port (
--            clock : in std_logic;
--            point : in coordinate;
--            complex_number : out ads_complex
--        );
--    end component;


--	component mode_select is
--		port (
--			clock: in std_logic;
--			complex_input : in ads_complex;
--			mode_in : in std_logic;
--			output_data : out complex_record
--		);
--	end component mode_select;

	component pipeline_stage is
		generic (
			threshold : ads_sfixed := to_ads_sfixed(4);
			stage_number : natural 
		);
		port (
			reset           : in std_logic;
			clk             : in std_logic;
			stage_input     : in complex_record; -- Input signal of type complex_record
			stage_output    : out complex_record -- Output signal of type complex_record
		);
	end component pipeline_stage;

    component color_map is
        generic (
          total_stages : natural
        );
        port (
            clk             : in std_logic;
            reset           : in std_logic;
            stage_input     : in complex_record;
            point_valid     : in boolean;
            vga_red         : out std_logic_vector(3 downto 0);  -- Red component (4 bits)
            vga_green       : out std_logic_vector(3 downto 0);  -- Green component (4 bits)
            vga_blue        : out std_logic_vector(3 downto 0)
        );
    end component color_map;

	component FlipFlop is
		Port (
			clk   : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			h_sync: in  STD_LOGIC;
			v_sync: in  STD_LOGIC;
            point_valid_in: in  boolean;
			h_sync_out: out STD_LOGIC;
			v_sync_out: out STD_LOGIC;
            point_valid_out: out  boolean
		);
	end component FlipFlop;    

	
	-- functions
	function get_seed (
			point_in:	in	coordinate
		) return ads_complex
	is
		variable x_coordinate, y_coordinate: ads_sfixed;
	begin
		x_coordinate := to_ads_sfixed(3.2/real(vga_res.horizontal.active)) * to_ads_sfixed(point_in.x) - to_ads_sfixed(2.2);
		y_coordinate := to_ads_sfixed(1.2) - to_ads_sfixed(2.4/real(vga_res.vertical.active)) * to_ads_sfixed(point_in.y);
		return ads_cmplx(x_coordinate, y_coordinate);
	end function get_seed;
	
	-- Signal declarations for connections
	signal point : coordinate;
	-- signal complex_input : ads_complex;
	signal h_sync, v_sync : std_logic_vector(0 to total_stages + entities);
	type Complex_Record_Array is array (0 to total_stages) of Complex_Record;
	signal stage_outputs : Complex_Record_Array;
	signal pll_output_signal : std_logic;
    type boolean_array is array (0 to total_stages + entities) of boolean;
    signal point_valid_out : boolean_array;
	
begin

    -- Instantiation of sub-entities and connections
	 -- Instantiate PLL
    PLL_inst : PLL
        port map (
            inclk0 => vga_clock,
            c0 => pll_output_signal
            -- Connect other PLL ports as needed
        );
	 
    vga_fsm_inst: entity vga.vga_fsm
        generic map (
            -- Assign generics if needed
            vga_res => vga_res
        )
        port map (
            vga_clock => pll_output_signal,
            reset => reset,
            point => point,
            point_valid => point_valid_out(0),
            h_sync => h_sync(0),
            v_sync => v_sync(0)
        );

--     to_complex_inst : to_complex
--        generic map (
--          vga_res => vga_res
--        )
--        port map (
--          clock => pll_output_signal,
--          point => point,
--          complex_number => complex_input
--        );

--    mode_inst : mode_select
--        port map (
--			clock => pll_output_signal,
--            complex_input => complex_input,
--            mode_in => mode_in,
--            output_data => stage_outputs(0)
--        );

	stage_input_driver: process(pll_output_signal) is
	begin
		if rising_edge(pll_output_signal) then
			if mode_in = '0' then
				stage_outputs(0).z <= complex_zero;
				stage_outputs(0).c <= get_seed(point);
			else
				stage_outputs(0).z <= get_seed(point);
				stage_outputs(0).c <= ads_cmplx(to_ads_sfixed(-1), to_ads_sfixed(0));
			end if;
		end if;
	end process stage_input_driver;
	--stage_outputs(0).z <= complex_zero when mode_in = '0' else complex_input;
	--stage_outputs(0).c <= complex_input when mode_in = '0' else ads_cmplx(to_ads_sfixed(-1), to_ads_sfixed(0));
	stage_outputs(0).stage_data <= 0;
	stage_outputs(0).stage_overflow <= false;

    -- Generate pipeline stages
    pipeline_stages: for i in 0 to total_stages-1 generate
		pipeline_stage_inst : pipeline_stage
			generic map (
				threshold => threshold,
				stage_number => i
			)
			port map (
				reset => reset,
				clk => pll_output_signal,
				stage_input => stage_outputs(i),
				stage_output => stage_outputs(i + 1)
			);
    end generate pipeline_stages;

      -- Instantiate color map only for the last pipeline output
    color_map_inst : color_map
        generic map (
            total_stages => total_stages
        )
        port map (
            clk => pll_output_signal,
            reset => reset,
            stage_input => stage_outputs(total_stages),
            point_valid => point_valid_out(total_stages + entities),
            vga_red => vga_red,
            vga_green => vga_green,
            vga_blue => vga_blue
        );

    -- Generate flip-flop instances
    flipflop_instances: for i in 1 to total_stages + entities  generate
        flipflop_inst : FlipFlop
            port map (
                clk => pll_output_signal,
                reset => reset,
                h_sync => h_sync(i-1),
                v_sync => v_sync(i-1),
                point_valid_in => point_valid_out(i-1),
                h_sync_out => h_sync(i),
                v_sync_out => v_sync(i),
                point_valid_out => point_valid_out(i)
            );
    end generate flipflop_instances;

    h_syncff <= h_sync(total_stages + entities);  -- Connect to the last flip-flop output
    v_syncff <= v_sync(total_stages + entities);  -- Connect to the last flip-flop output
end architecture Behavioral;