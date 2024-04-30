TOPLEVEL_LANG = vhdl

VHDL_SOURCES = \
	$(PWD)/../bin_to_gray.vhd \
	$(PWD)/../gray_to_bin.vhd \
	$(PWD)/../sync3.vhd \
	$(PWD)/../synchronizer.vhd \
	$(PWD)/../consumer_fsm.vhd \
	$(PWD)/../producer_fsm.vhd \
	$(PWD)/../dp_ram2.vhd \
	$(PWD)/../seven_segment_pkg.vhd \
	$(PWD)/max10_adc.vhd \
	$(PWD)/pll.vhd \
	$(PWD)/../project3.vhd

TOPLEVEL ?= project3
SIM=ghdl
MODULE ?= test_design

include $(shell cocotb-config --makefiles)/Makefile.sim
