`timescale 1ns/1ps

//tt_um_top_lvl.v
//Top level design file, this will instantiate the design files and wire the ports together

module tt_um_top_lvl(
    input wire clk,
    input wire rst_n,
    input wire signal_in,//signal provided by the user
    output wire signal_out,//output to an LED on board
    output wire [2:0] state_dbg, // debug state output
    output wire spike  // alias for signal_out (if not already connected)

);


wire add_en, sub_en, load_reset;
wire thresh_hit;
wire [7:0] acc;


LIF_Accumulator #(
    .WIDTH(8),
    .THRESH(8'd20)
) u_acc(
    .clk(clk),
    .rst_n(rst_n),
    .add_en(add_en),
    .sub_en(sub_en),
    .load_reset(load_reset),
    .add(8'd20),
    .sub(8'd1),
    .VRESET(8'd0),
    .acc(acc),
    .thresh_hit(thresh_hit)
);


LIF_neuron_FSM u_fsm (
    .clk(clk),
    .rst_n(rst_n),
    .signal_in(signal_in),
    .add_en(add_en),
    .sub_en(sub_en),
    .load_reset(load_reset),
    .thresh_hit(thresh_hit),
    .signal_out(spike),         // output from FSM
    .state_dbg(state_dbg)       // new debug signal
);
assign signal_out = spike; // connect spike to signal_out

endmodule
