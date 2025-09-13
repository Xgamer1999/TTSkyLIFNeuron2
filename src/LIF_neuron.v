`timescale 1ns/1ps

// TT wrapper for your LIF design
module LIF_neuron (
  input  wire        clk,
  input  wire        rst_n,
  input  wire        ena,
  input  wire [7:0]  ui_in,
  output wire [7:0]  uo_out,
  input  wire [7:0]  uio_in,
  output wire [7:0]  uio_out,
  output wire [7:0]  uio_oe
);
  // pick simple mappings
  wire signal_in  = ui_in[0];        // user drives switch 0
  wire signal_out;

  // instantiate your actual top
  tt_um_top_lvl u_top (
    .clk(clk),
    .rst_n(rst_n),
    .signal_in(signal_in),
    .signal_out(signal_out)
  );

  // drive outputs
  assign uo_out[0] = signal_out;
  assign uo_out[7:1] = 7'b0;

  // not using bidirectional bus
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;
endmodule
