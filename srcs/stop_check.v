`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 17:23:42
// Design Name: 
// Module Name: stop_check
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


module stopbit_checker(

    input clk,        //16x baud clock
    input rst,
    input rx_in,
    input check_stop,
    output reg stopbit_error
);

always @(posedge clk, posedge rst) begin
    if(rst) begin
        stopbit_error <= 1'b0;
    end
    else if(check_stop) begin
        if(rx_in)
            stopbit_error <= 1'b0;
        else
            stopbit_error <= 1'b1;
    end
    else
        stopbit_error <= stopbit_error;
end

endmodule