import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


@cocotb.test()
async def test_fixture(dut):
	clk10 = Clock(dut.clk_10MHz, 1, "us")
	clk50 = Clock(dut.clk_50MHz, 20, 'ns')

	dut.rst.value = 0

	cocotb.start_soon(clk10.start())
	cocotb.start_soon(clk50.start())

	for _ in range(2):
		await RisingEdge(dut.clk_10MHz)

	dut.rst.value = 1

	for _ in range(200):
		await RisingEdge(dut.clk_10MHz)
