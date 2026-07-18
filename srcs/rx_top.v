`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 23:12:38
// Design Name: 
// Module Name: rx_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx_top(

    input clk,
    input rst,

    input rx_in,
    input baud_tick,

    output [7:0] rx_data,
    output rx_done,

    output parity_error,
    output stop_error

);

wire start_valid;

wire shift;
wire sample_done;

wire parity_load;
wire check_stop;

wire data_ready;

//
// Start Detector
//
start_detector u_start(

    .clk(clk),
    .rst(rst),
    .rx_in(rx_in),

    .start_valid(start_valid)

);

//
// RX FSM
//
rx_fsm u_fsm(

    .clk(clk),
    .rst(rst),

    .start_valid(start_valid),
    .baud_tick(baud_tick),

    .shift(shift),
    .sample_done(sample_done),

    .parity_load(parity_load),
    .check_stop(check_stop),

    .rx_done(rx_done)

);

//
// SIPO
//
sipo u_sipo(

    .clk(clk),
    .rst(rst),

    .shift(shift),
    .sample_done(sample_done),

    .rx_in(rx_in),

    .sipo_out(rx_data),

    .data_ready(data_ready)

);

//
// Parity Checker
//
parity_checker u_parity(

    .clk(clk),
    .rst(rst),

    .load(parity_load),

    .rx_in(rx_in),

    .sipo_out(rx_data),

    .parity_bit_error(parity_error)

);

//
// Stop Bit Checker
//
stopbit_checker u_stop(

    .clk(clk),
    .rst(rst),

    .rx_in(rx_in),

    .check_stop(check_stop),

    .stopbit_error(stop_error)

);

endmodule