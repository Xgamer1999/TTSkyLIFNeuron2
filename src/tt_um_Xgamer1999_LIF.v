`timescale 1ns/1ps

module tt_um_Xgamer1999_LIF (
  input  wire        clk,
  input  wire        rst_n,
  input  wire        ena,         // required by TT
  input  wire [7:0]  ui_in,
  output wire [7:0]  uo_out,
  input  wire [7:0]  uio_in,
  output wire [7:0]  uio_out,
  output wire [7:0]  uio_oe
);
  // Optionally gate behavior with ena (good TT hygiene)
  wire user_in  = ui_in[0] & ena;
  wire out_bit;

  tt_um_top_lvl u_top (
    .clk(clk),
    .rst_n(rst_n),
    .signal_in(user_in),
    .signal_out(out_bit)
  );

  assign uo_out[0]   = out_bit;
  assign uo_out[7:1] = 7'b0;
  assign uio_out     = 8'b0;
  assign uio_oe      = 8'b0;


endmodule
