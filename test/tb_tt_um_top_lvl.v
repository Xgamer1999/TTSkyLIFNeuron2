`timescale 1ns/1ps
module tb_tt_um_top_lvl;

  // Clock & reset
  reg clk   = 0;
  reg rst_n = 0;

  // DUT I/O
  reg  signal_in;
  wire signal_out;

  // Slow clock: 1 MHz (1000 ns period)
  //always #500 clk = ~clk;

  // Very slow clock: 100 kHz
  always #5000 clk = ~clk;

  // Instantiate DUT
  tt_um_top_lvl dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .signal_in (signal_in),
    .signal_out(signal_out)
  );

  // Dump whole TB hierarchy (top signals + submodules)
  initial begin
    $dumpfile("lif_tb.vcd");
    $dumpvars(0, tb_tt_um_top_lvl);
  end

  // Print when spike fires
  always @(posedge clk) begin
    if (signal_out)
      $display("[%0t] >>> Spike fired!", $time);
  end

  // Stimulus
  initial begin
    signal_in = 0;
    rst_n     = 0;

    // Hold reset for 2 cycles
    repeat (2) @(posedge clk);
    rst_n = 1;
    $display("[%0t] Reset deasserted", $time);

    // --------------------------
    // 1) Small burst
    signal_in = 1;
    repeat (5) @(posedge clk);
    signal_in = 0;
    repeat (5) @(posedge clk);

    // 2) Longer burst (should spike with add=25)
    signal_in = 1;
    repeat (8) @(posedge clk);
    signal_in = 0;
    repeat (8) @(posedge clk);

    // 3) Multiple bursts
    repeat (3) begin
      signal_in = 1;
      repeat (6) @(posedge clk);
      signal_in = 0;
      repeat (6) @(posedge clk);
    end

    // Leak only
    signal_in = 0;
    repeat (10) @(posedge clk);

    // Done
    $display("[%0t] Simulation finished", $time);
    $finish;
  end

endmodule
