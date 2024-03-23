

.PHONY: fractal-tgt ads-tgt vga-tgt all clean

all: fractal-tgt
	ghdl analyze tb_project2.vhd
	ghdl elaborate tb_project2

clean:
	-rm -f *.o *.cf tb_project2

run: all
	ghdl run tb_project2 $(SIM_ARGS)

fractal-tgt: ads-tgt vga-tgt ../to_complex.vhd ../pipeline_stage.vhd ../FlipFlop.vhd ../color_map.vhd ../mode.vhd pll.vhd ../project2.vhd
	ghdl analyze -Wall ../to_complex.vhd
	ghdl analyze -Wall ../pipeline_stage.vhd
	ghdl analyze -Wall ../FlipFlop.vhd
	ghdl analyze -Wall ../color_map.vhd
	ghdl analyze -Wall ../mode.vhd
	ghdl analyze -Wall pll.vhd
	ghdl analyze -Wall ../project2.vhd

ads-tgt: ../ads_fixed.vhd ../ads_complex.vhd
	ghdl analyze -Wall --work=ads ../ads_fixed.vhd
	ghdl analyze -Wall --work=ads ../ads_complex.vhd

vga-tgt: ../vga_data.vhd ../vga_fsm.vhd
	ghdl analyze -Wall --work=vga ../vga_data.vhd
	ghdl analyze -Wall --work=vga ../vga_fsm.vhd

