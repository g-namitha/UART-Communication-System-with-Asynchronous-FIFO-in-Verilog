`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 17:22:45
// Design Name: 
// Module Name: sipo
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


module sipo(

    input clk,          // 16x baud clock
    input rst,
    input shift,
    input sample_done,
    input rx_in,

    output [7:0] sipo_out,
    output reg data_ready

);

reg [7:0] temp;
reg [2:0] bit_count;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        temp       <= 8'b0;
        bit_count  <= 3'b0;
        data_ready <= 1'b0;
    end

    else
    begin

        data_ready <= 1'b0;

        if(shift && sample_done)
        begin

            temp <= {rx_in, temp[7:1]};

            if(bit_count == 3'd7)
            begin
                data_ready <= 1'b1;
                bit_count  <= 3'b0;
            end

            else
            begin
                bit_count <= bit_count + 1'b1;
            end

        end

    end

end

assign sipo_out = temp;

endmodule