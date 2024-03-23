library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use work.ads_complex_pkg.all;

library vga;
use vga.vga_data.all;

entity tb_pipeline is
    generic (
		vga_res:	vga_timing := vga_res_640x480;
		pipeline_depth:	positive := 25
	);
end entity tb_pipeline;

architecture testbench of tb_pipeline is
    -- Component
    component pipeline_stage is
		generic (
			threshold : ads_sfixed := to_ads_sfixed(4);
			stage_number : natural 
		);
		port (
			reset           : in std_logic;
			clk             : in std_logic;
			stage_input     : in complex_record;
			stage_output    : out complex_record
		);
	end component pipeline_stage;

    -- functions
	function vga_horizontal
        return positive
    is
    begin
        return (vga_res.horizontal.active + vga_res.horizontal.front_porch
                    + vga_res.horizontal.sync_width
                    + vga_res.horizontal.back_porch);
    end function vga_horizontal;

    function vga_vertical
        return positive
    is
    begin
        return (vga_res.vertical.active + vga_res.vertical.front_porch
                    + vga_res.vertical.sync_width
                    + vga_res.vertical.back_porch);
    end function vga_vertical;

    function vga_total_pixels
        return positive
    is
    begin
        return vga_horizontal * vga_vertical;
    end function vga_total_pixels;

    -- signals
    signal clk: std_logic := '0';
    signal reset: std_logic := '0';
    signal input_data: complex_record;
    signal output_data: complex_record;
    signal h_sync, v_sync: std_logic;
    signal system_ready: boolean;
    signal test_done: boolean := false;

    file pbm_file: text;
begin
    -- Clock process
    clk <= not clk after 1 ps when not test_done else '0';
    -- DUT instantiation
    dut: pipeline_stage
    generic map (
        threshold => to_ads_sfixed(4),
        stage_number => 0
    )
    port map (
        reset => reset,
        clk => clk,
        stage_input => input_data,
        stage_output => output_data
    );

    -- Stimulus process
    stimulus_process: process
        procedure do_reset
            is
            begin
                reset <= '0';
                wait until rising_edge(clk);
                wait until rising_edge(clk);
                reset <= '1';
            end procedure do_reset;
    begin
        do_reset; --(clk, reset);
        -- Generate input data for the pipeline
        input_data.z.re <= to_ads_sfixed(0.0);
        input_data.z.im <= to_ads_sfixed(0.0);
        input_data.c.re <= to_ads_sfixed(0.0);
        input_data.c.im <= to_ads_sfixed(0.0);
        input_data.stage_data <= 0;
        input_data.stage_overflow <= false;

        test_done <= true;
        wait;
    end process stimulus_process;

end architecture testbench;
