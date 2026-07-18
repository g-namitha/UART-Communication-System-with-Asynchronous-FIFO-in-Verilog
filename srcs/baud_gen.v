`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:44:42
// Design Name: 
// Module Name: baud_gen
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


module baud_gen#(
    parameter clockfreq = 100_000_000,
    parameter baud =10000000

)(
    input clk,
    input rst,
    output reg baud_tick
);

localparam divisor = clockfreq / baud;

reg [15:0] count;


always @(posedge clk or posedge rst) begin
    if(rst) begin
        count <= 0;
        baud_tick <= 0;
    end
    else if(count == divisor-1) begin
        count <= 0;
        baud_tick <= 1;
    end
    else begin
        count <= count + 1;
        baud_tick <= 0;
    end
end

endmodule