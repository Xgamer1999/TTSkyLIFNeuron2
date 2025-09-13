`timescale 1ns/1ps

//LIF_neuron_FSM.v
//General FSM that dictates direction in which logic is going

module LIF_neuron_FSM #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst_n,
    input wire signal_in,
    input wire thresh_hit,
    output reg add_en,
    output reg sub_en,
    output reg load_reset,
    output reg signal_out
);

    reg [2:0] state, state_n;
    localparam ini = 3'b000;
    localparam charge = 3'b001;
    localparam leak = 3'b010;
    localparam impulse = 3'b100;
    
    always @* begin
    state_n = state;
    signal_out = 1'b0;
    add_en = 1'b0;
    sub_en = 1'b0;
    load_reset = 1'b0;

        case(state)
            ini: begin
                load_reset = 1;
                if(signal_in) begin
                    state_n = charge;
                end
                else begin
                    state_n = ini;
                end
            end
            charge: begin
                add_en = signal_in;
                //assign +1 to accumulator
                if(thresh_hit) begin
                    state_n = impulse;
                end
                else begin
                    state_n = leak;
                end
            end
            leak: begin
                sub_en = 1;
                //use subtractor to subtract values from accumulator
                if(thresh_hit) begin
                    state_n = impulse;
                end
                else if(signal_in) begin
                    state_n = charge;//add value to accumulator
                end
                else begin
                state_n = leak;
                end
            end
            impulse: begin
                signal_out = 1;
                load_reset = 1;
                state_n = ini;
            end
            default: state_n = ini;
        endcase
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            state = ini;
        end else begin
            state = state_n;
        end
    end
endmodule
