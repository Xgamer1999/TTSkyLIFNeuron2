`timescale 1ns/1ps

module tb_tt_um_top_lvl;

  reg clk;
  reg rst_n;
  reg signal_in;
  wire signal_out;

  // Instantiate your design under test
  tt_um_top_lvl DUT (
    .clk(clk),
    .rst_n(rst_n),
    .signal_in(signal_in),
    .signal_out(signal_out)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;  // 10ns period

  // Simulation logic
  initial begin
    $display("🟢 Simulation started");

    // Enable waveform dumping
    $dumpfile("top_lvl.vcd");
    $dumpvars(0, tb_tt_um_top_lvl);

    // Initial reset
    rst_n = 0;
    signal_in = 0;
    #20;

    $display("✅ Releasing reset");
    rst_n = 1;

      // Hold input high long enough to guarantee FSM sees it
    signal_in = 1;
    $display("🔁 Holding input HIGH at time %0t", $time);
    #100;  // <-- long enough for FSM to catch it
    signal_in = 0;
    $display("🔁 Dropping input LOW at time %0t", $time);

    $display("⏳ Waiting 100ns to observe leak...");
    #100;

    $display("✅ Simulation finished");
    $finish;
  end

  // Print signal values on every clock edge
  always @(posedge clk) begin
    $display("T=%0t | clk=%b | rst_n=%b | signal_in=%b | signal_out=%b", 
             $time, clk, rst_n, signal_in, signal_out);
  end

endmodule
