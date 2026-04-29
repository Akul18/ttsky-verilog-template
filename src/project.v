/*
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_flappy_vga_Akul18 (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire HS, VS, blank;
    wire [2:0] r, g, b;

    wire _unused = &{ena, ui_in[7:2], uio_in, blank, r[0], g[0], b[0], 1'b0};

    flappy_top flappy (
        .CLOCK_50  (clk),
        .reset     (~rst_n),
        .btn_start (ui_in[0]),
        .btn_jump  (ui_in[1]),
        .HS        (HS),
        .VS        (VS),
        .blank     (blank),
        .r         (r),
        .g         (g),
        .b         (b)
    );

    // Match TinyVGA PMOD-style 2-bit RGB + sync
    assign uo_out[0] = r[1];  // VGA R0
    assign uo_out[1] = r[2];  // VGA R1
    assign uo_out[2] = g[1];  // VGA G0
    assign uo_out[3] = g[2];  // VGA G1
    assign uo_out[4] = b[1];  // VGA B0
    assign uo_out[5] = b[2];  // VGA B1
    assign uo_out[6] = HS;
    assign uo_out[7] = VS;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule