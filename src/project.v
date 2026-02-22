/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_oe = 8'b0000_0001;  
  wire _unused = &{ena, uio_out[7:1], uio_in[7:3], uio_in[0], 1'b0};

  RangeFinder rf (
    .data_in (ui_in),
    .clock   (clk),
    .reset   (~rst_n),
    .go      (uio_in[2]),
    .finish  (uio_in[1]),
    .range   (uo_out),
    .error   (uio_out[0])
  );

endmodule
