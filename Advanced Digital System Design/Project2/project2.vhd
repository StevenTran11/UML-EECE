library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ads;
use ads.ads_fixed.all;
use ads.ads_complex.all;

entity project2 is
    generic (
        total_stages : natural := 25;  -- Adjust the number of pipeline stages as needed
        entities     : natural := 4;
        vga_res: vga_timing := vga_res_default
    );
    port (
        -- Define ports here if needed
        reset:          in std_logic;
        vga_clock:      in std_logic;
        mode_signal:    in std_logic
    );
end entity project2;

architecture Behavioral of project2 is

    -- Component declarations
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
            vga_res:	vga_timing := vga_res_default
        );
        port (
            clock : in std_logic;
            point : in coordinate;
            complex_number : out complex
        );
    end component to_complex;

	component mode is
		port (
			complex_input : in ads_complex;
			mode : in std_logic;
			output_data : out complex_record
		);
	end component mode;

	component pipeline_stage is
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
	end component pipeline_stage;

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
    signal h_sync, v_sync : std_logic;
    signal point : coordinate;
    signal point_valid : boolean;
    signal complex_number : complex;
    signal complex_input, output_data : complex_record;
    signal stage_inputs : array(0 to total_stages-1) of complex_record;
    signal stage_outputs : array(0 to total_stages-1) of complex_record;
    signal h_sync_ff : array(0 to total_stages + entities - 1) of std_logic;
    signal v_sync_ff : array(0 to total_stages + entities - 1) of std_logic;

begin

    -- Instantiation of sub-entities and connections
    vga_fsm_inst : vga_fsm
        generic map (
            -- Assign generics if needed
            vga_res => vga_res
        )
        port map (
            vga_clock => vga_clock, --EDIT CLOCK needs to be 50MHz from board
            reset => reset,
            point => point,
            point_valid => point_valid,
            h_sync => h_sync,
            v_sync => v_sync
        );

    to_complex_inst : to_complex
        generic map (
            vga_res => vga_res
        )
        port map (
            clock => vga_clock,
            point => point,
            complex_number => complex_number
        );

    mode_inst : mode
        port map (
            complex_input => complex_input,
            mode => mode_signal,
            output_data => output_data
        );

end architecture Behavioral;