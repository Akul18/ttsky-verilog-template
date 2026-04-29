# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start Flappy VGA test")

    # 100 kHz test clock
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Initial values
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)

    # uio pins are unused, so they should be disabled and driven low internally
    assert int(dut.uio_oe.value) == 0, "uio_oe should be 0 because uio pins are unused"
    assert int(dut.uio_out.value) == 0, "uio_out should be 0 because uio pins are unused"

    # VGA outputs should not be X/Z after reset
    assert dut.uo_out.value.is_resolvable, "uo_out contains X/Z after reset"

    # Press START: ui_in[0]
    dut.ui_in.value = 0b00000001
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 20)

    # Press JUMP: ui_in[1]
    dut.ui_in.value = 0b00000010
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    # Check that HSYNC toggles.
    # uo_out[6] = HSYNC, uo_out[7] = VSYNC
    seen_hs_toggle = False
    last_hs = int(dut.uo_out.value[6])

    for _ in range(2000):
        await ClockCycles(dut.clk, 1)

        assert dut.uo_out.value.is_resolvable, "uo_out became X/Z during VGA operation"

        hs = int(dut.uo_out.value[6])
        if hs != last_hs:
            seen_hs_toggle = True

        last_hs = hs

    assert seen_hs_toggle, "HSYNC did not toggle"

    dut._log.info("Flappy VGA smoke test passed")