`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 17:22:01
// Design Name: 
// Module Name: start_detector
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


module start_detector(

    input clk,
    input rst,
    input rx_in,

    output reg start_valid

);

reg rx_d;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        rx_d <= 1'b1;
        start_valid <= 1'b0;
    end
    else
    begin
        start_valid <= rx_d & ~rx_in;
        rx_d <= rx_in;
    end
end

endmodule