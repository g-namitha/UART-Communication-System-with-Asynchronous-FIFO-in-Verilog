`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2026 03:25:24
// Design Name: 
// Module Name: uart_fifo_tb
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

`timescale 1ns/1ps

module uart_fifo_top_tb;

reg clk;
reg rst;

reg rx_in;

wire tx_out;

uart_fifo_top dut(
    .clk(clk),
    .rst(rst),
    .rx_in(rx_in),
    .tx_out(tx_out)
);

/////////////////////////////////////////////////
// Clock
/////////////////////////////////////////////////

always #5 clk = ~clk;

/////////////////////////////////////////////////
// Send UART Frame
/////////////////////////////////////////////////

task send_uart_byte;

input [7:0] data;

integer i;
reg parity;

begin

    parity = ^data;

    // Start Bit
    rx_in = 1'b0;
    #120;

    // Data Bits (LSB First)
    for(i=0;i<8;i=i+1)
    begin
        rx_in = data[i];
        #120;
    end

    // Even Parity
    rx_in = parity;
    #120;

    // Stop Bit
    rx_in = 1'b1;
    #300;

end

endtask

/////////////////////////////////////////////////
// Stimulus
/////////////////////////////////////////////////

initial
begin

    clk = 0;
    rst = 1;
    rx_in = 1;

    #50;
    rst = 0;

    // Send A5
    send_uart_byte(8'hA5);

    #5000;

    $finish;

end

endmodule