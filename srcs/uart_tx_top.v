`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:46:52
// Design Name: 
// Module Name: uart_tx_top
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


module uart_tx_top(

    input clk,
    input rst,

    input txstart,
    input [7:0] tx_data,

    input baud_tick,

    output tx,
    output txbusy

);

wire load;
wire shift;

wire [1:0] sel;

wire data_bit;
wire parity_bit;

/////////////////////////////////////////////////
// FSM
/////////////////////////////////////////////////

tx_fsm TX_FSM(

    .clk(clk),
    .rst(rst),
    .txstart(txstart),
    .baud_tick(baud_tick),

    .shift(shift),
    .load(load),
    .sel(sel),
    .txbusy(txbusy)

);

/////////////////////////////////////////////////
// PISO
/////////////////////////////////////////////////

piso PISO(

    .clk(clk),
    .rst(rst),
    .load(load),
    .shift(shift),

    .tx_data(tx_data),

    .serial_out(data_bit)

);

/////////////////////////////////////////////////
// Parity Generator
/////////////////////////////////////////////////

parity_gen PARITY_GEN(

    .clk(clk),
    .rst(rst),

    .txdata(tx_data),
    .load(load),

    .parity_bit(parity_bit)

);

/////////////////////////////////////////////////
// TX MUX
/////////////////////////////////////////////////

tx_mux TX_MUX(

    .start_bit(1'b0),
    .data_bit(data_bit),
    .parity_bit(parity_bit),
    .stop_bit(1'b1),

    .sel(sel),

    .data_out(tx)

);

endmodule