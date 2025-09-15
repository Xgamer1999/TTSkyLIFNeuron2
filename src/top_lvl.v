`timescale 1ns/1ps

//tt_um_top_lvl.v
//Top level design file, this will instantiate the design files and wire the ports together

module tt_um_top_lvl(
    input wire clk,
    input wire rst_n,
    input wire signal_in,//signal provided by the user
    output wire signal_out//output to an LED on board
);


wire add_en, sub_en, load_reset;
wire thresh_hit;
wire [7:0] acc;


LIF_Accumulator #(
    .WIDTH(8),
    .THRESH(8'd100)
) u_acc(
    .clk(clk),
    .rst_n(rst_n),
    .add_en(add_en),
    .sub_en(sub_en),
    .load_reset(load_reset),
    .add(8'd25),
    .sub(8'd1),
    .VRESET(8'd0),
    .acc(acc),
    .thresh_hit(thresh_hit)
);


LIF_neuron_FSM #(
    .WIDTH(8)
) u_fsm(
    .clk(clk),
    .rst_n(rst_n),
    .signal_in(signal_in),
    .add_en(add_en),
    .sub_en(sub_en),
    .load_reset(load_reset),
    .thresh_hit(thresh_hit),
    .signal_out(signal_out)
);

endmodule
