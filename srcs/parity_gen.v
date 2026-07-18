`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:45:19
// Design Name: 
// Module Name: parity_gen
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


module parity_gen(
    input clk,
    input rst,
    input [7:0] txdata,
    input load,
    output reg parity_bit
);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        parity_bit <= 1'b0;
    end
    else if(load)
    begin
        parity_bit <= ^txdata;    // Even parity
    end
    else
    begin
        parity_bit <= parity_bit; // Hold previous value
    end
end

endmodule