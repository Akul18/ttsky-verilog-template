/*
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // Bidirectional inputs
    output wire [7:0] uio_out,  // Bidirectional outputs
    output wire [7:0] uio_oe,   // Bidirectional output enables
    input  wire       ena,      // always 1 when powered
    input  wire       clk,      // clock
    input  wire       rst_n     // active-low reset
);

    // -------------------------
    // Internal signals
    // -------------------------
    wire HS, VS, blank;
    wire [2:0] r, g, b;

    // -------------------------
    // Unused inputs
    // -------------------------
    wire _unused = &{ena, ui_in[7:2], uio_in[7:0], 1'b0};

    // -------------------------
    // flappy_top instantiation
    // -------------------------
    flappy_top uut (
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

    // -------------------------
    // Output pin mapping
    // 12 total outputs:
    // HS, VS, blank, r[2:0], g[2:0], b[2:0]
    // -------------------------

    // Dedicated outputs
    assign uo_out[0] = HS;
    assign uo_out[1] = VS;
    assign uo_out[2] = blank;
    assign uo_out[5:3] = r;
    assign uo_out[7:6] = g[2:1];

    // Bidirectional outputs used as outputs
    assign uio_out[0] = g[0];
    assign uio_out[3:1] = b;
    assign uio_out[7:4] = 4'b0000;

    // Enable only the used uio outputs
    assign uio_oe = 8'b0000_1111;

endmodule