`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:45:36
// Design Name: 
// Module Name: tx_mux
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


module tx_mux(

    input start_bit,
    input data_bit,
    input parity_bit,
    input stop_bit,

    input [1:0] sel,

    output reg data_out
);

always @(*)
begin
    case(sel)

        2'b00: data_out = start_bit;

        2'b01: data_out = data_bit;

        2'b10: data_out = parity_bit;

        2'b11: data_out = stop_bit;

        default: data_out = 1'b1;

    endcase
end

endmodule