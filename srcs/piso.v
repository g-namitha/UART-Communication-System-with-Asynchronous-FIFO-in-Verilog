`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:44:56
// Design Name: 
// Module Name: piso
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


module piso(
    input clk,
    input rst,
    input load,
    input shift,
    input [7:0] tx_data,

    output serial_out
);

reg [7:0] shift_reg;

always @(posedge clk or posedge rst)
begin
    if(rst)
        shift_reg <= 8'b0;

    else if(load)
        shift_reg <= tx_data;

    else if(shift)
        shift_reg <= shift_reg >> 1;
end

assign serial_out = shift_reg[0];

endmodule