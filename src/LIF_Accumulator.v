`timescale 1ns/1ps

//LIF_Accumulator.v
//Accumulator that adds and subtracts values to hit threshold voltage necessary for neuron spike

module LIF_Accumulator #(
    parameter WIDTH = 8,//bit width of bus used in design
    parameter [WIDTH-1:0] THRESH = 8'd100//defines what the required threshold is to send an impulse
)(
    input wire clk,//clock cycle
    input wire rst_n,//reset active low to prevent reset while register has values
    input wire add_en,//enable bit to turn on adding portion of accumulator
    input wire sub_en,//enable bit to turn on subtracting portion of the accumulator
    input wire load_reset,//enable bit to determine if the register needs to be reset to zero
    input wire [WIDTH-1:0] add,//bus that determines how many bits are added to the accumulator
    input wire [WIDTH-1:0] sub,//bus that determines how many bits are subtracted from the accumulator
    input wire [WIDTH-1:0] VRESET,//bus that holds the value 8'b00000000 and resets the accumulator to that value
    output reg [WIDTH-1:0] acc,//bus that holds the accumulator's value in 8 bits
    output wire thresh_hit//threshold has been met flag that tells design to send an impulse
);

reg [WIDTH-1:0] acc_n;
wire [WIDTH-1:0] sum = acc + add;
wire [WIDTH-1:0] dec = (acc > sub) ? (acc - sub) : {WIDTH{1'b0}};//If accumulator value greater than subtractor value then subtract from accumulator and if not then reset to 0
wire ovf = (sum < acc);//1 bit overflow flag
assign thresh_hit = (acc > THRESH);

always @* begin
    acc_n = acc;

    if(load_reset) begin
        acc_n = VRESET;//If load_reset is true then reset the accumulator to all zeroes
    end
    else if(add_en) begin
        acc_n = ovf ? {WIDTH{1'b1}} : sum;//test overflow flag, if overflow is true then saturate bus with 1 and if not then add to sum
    end
    else if(sub_en)  begin
        acc_n = dec;//decrement accumulator, dont need underflow code bc underflow code is incorporated into dec design
    end
end

always @(posedge clk) begin
    if(!rst_n) begin
        acc <= VRESET;
    end
    else begin
        acc <= acc_n;
    end
end
endmodule
