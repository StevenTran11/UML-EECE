

.PHONY: fractal-tgt ads-tgt vga-tgt all clean

all: fractal-tgt
	ghdl -a tb_project2.vhd
	ghdl elaborate tb_project2

clean:
	-rm -f *.o *.cf tb_project2

run: all
	ghdl run tb_project2 $(SIM_ARGS)

fractal-tgt: ads-tgt vga-tgt ../to_complex.vhd ../pipeline_stage.vhd ../FlipFlop.vhd ../color_map.vhd ../mode.vhd pll.vhd ../project2.vhd
	ghdl -a  ../to_complex.vhd
	ghdl -a  ../pipeline_stage.vhd
	ghdl -a  ../FlipFlop.vhd
	ghdl -a  ../color_map.vhd
	ghdl -a  ../mode.vhd
	ghdl -a  pll.vhd
	ghdl -a  ../project2.vhd

ads-tgt: ../ads_fixed.vhd ../ads_complex.vhd
	ghdl -a  --work=ads ../ads_fixed.vhd
	ghdl -a  --work=ads ../ads_complex.vhd

vga-tgt: ../vga_data.vhd ../vga_fsm.vhd
	ghdl -a  --work=vga ../vga_data.vhd
	ghdl -a  --work=vga ../vga_fsm.vhd

