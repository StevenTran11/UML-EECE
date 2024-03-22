library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
library ads;
library vga;
USE vga.vga_data.all;
USE ads.ads_fixed.all;
USE ads.ads_complex_pkg.all;

entity project2 is
    generic (
        total_stages : natural := 25;  -- Adjust the number of pipeline stages as needed
        entities     : natural := 4;
        vga_res: vga_timing := vga_res_default;
		  threshold : ads_sfixed := to_ads_sfixed(4)
    );
    port (
        mode_in         : in std_logic; --SW9 on Board PIN_F15
        -- Define ports here if needed
        reset           : in std_logic;
        vga_clock       : in std_logic; -- LOC="PIN_V11";;
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
	 
    component vga_fsm is
        generic (
            vga_res: vga_timing := vga_res_default
        );
        port (
            vga_clock:      in std_logic;
            reset:          in std_logic;
            point:          out coordinate;
            point_valid:    out boolean;
            h_sync:         out std_logic;
            v_sync:         out std_logic
        );
    end component vga_fsm;

    component to_complex is
        generic (
            vga_res: vga_timing := vga_res_default
        );
        port (
            clock : in std_logic;
            point : in coordinate;
            complex_number : out ads_complex
        );
    end component;


	component mode is
		port (
			complex_input : in ads_complex;
			mode : in std_logic;
			output_data : out complex_record
		);
	end component mode;

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
			h_sync_out: out STD_LOGIC;
			v_sync_out: out STD_LOGIC
		);
	end component FlipFlop;    

	-- Signal declarations for connections
	signal point : coordinate;
	signal point_valid : boolean;
	signal complex_input : ads_complex;
	signal h_sync, v_sync : std_logic_vector(0 to total_stages + entities);
	type Complex_Record_Array is array (natural range <>) of Complex_Record;
	signal stage_outputs : Complex_Record_Array(0 to total_stages);
	signal pll_output_signal : std_logic;

begin

    -- Instantiation of sub-entities and connections
	 -- Instantiate PLL
    PLL_inst : PLL
        port map (
            inclk0 => vga_clock,
            c0 => pll_output_signal
            -- Connect other PLL ports as needed
        );
	 
    vga_fsm_inst : vga_fsm
        generic map (
            -- Assign generics if needed
            vga_res => vga_res
        )
        port map (
            vga_clock => pll_output_signal,
            reset => reset,
            point => point,
            point_valid => point_valid,
            h_sync => h_sync(0),
            v_sync => v_sync(0)
        );

        to_complex_inst : to_complex
        generic map (
          vga_res => vga_res
        )
        port map (
          clock => pll_output_signal,
          point => point,
          complex_number => complex_input
        );

    mode_inst : mode
        port map (
            complex_input => complex_input,
            mode => mode_in,
            output_data => stage_outputs(0)
        );

            -- Generate pipeline stages
    pipeline_stages: for i in 1 to total_stages generate
    pipeline_stage_inst : pipeline_stage
        generic map (
            threshold => threshold,
            stage_number => i
        )
        port map (
            reset => reset,
            clk => pll_output_signal,
            stage_input => stage_outputs(i-1),
            stage_output => stage_outputs(i)
        );
    end generate pipeline_stages;

--      -- Instantiate color map only for the last pipeline output
--    color_map_inst : color_map
--        generic map (
--            total_stages => total_stages
--        )
--        port map (
--            clk => pll_output_signal,
--            reset => reset,
--            stage_input => stage_outputs(total_stages),
--            vga_red => vga_red,
--            vga_green => vga_green,
--            vga_blue => vga_blue
--        );
		
	vga_red <= "1111" when point_valid else "0000";
	vga_blue <= "1111" when point_valid else "0000";
	vga_green <= "1111" when point_valid else "0000";

	-- Generate flip-flop instances
    flipflop_instances: for i in 1 to total_stages + entities  generate
        flipflop_inst : FlipFlop
            port map (
                clk => pll_output_signal,
                reset => reset,
                h_sync => h_sync(i-1),
                v_sync => v_sync(i-1),
                h_sync_out => h_sync(i),
                v_sync_out => v_sync(i)
            );
    end generate flipflop_instances;

    h_syncff <= h_sync(0);  -- Connect to the last flip-flop output
    v_syncff <= v_sync(0);  -- Connect to the last flip-flop output
end architecture Behavioral;