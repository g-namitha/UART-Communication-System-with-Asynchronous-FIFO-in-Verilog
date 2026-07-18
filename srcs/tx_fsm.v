`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:46:26
// Design Name: 
// Module Name: tx_fsm
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

module tx_fsm(

    input clk,
    input rst,

    input txstart,
    input baud_tick,

    output reg shift,
    output reg load,
    output reg [1:0] sel,
    output reg txbusy

);

localparam IDLE   = 3'd0;
localparam START  = 3'd1;
localparam DATA   = 3'd2;
localparam PARITY = 3'd3;
localparam STOP   = 3'd4;

reg [2:0] state;
reg [2:0] bit_count;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state     <= IDLE;
        bit_count <= 3'd0;

        load   <= 1'b0;
        shift  <= 1'b0;
        sel    <= 2'b11;
        txbusy <= 1'b0;
    end
    else
    begin

        // Default outputs
        load   <= 1'b0;
        shift  <= 1'b0;
        txbusy <= 1'b1;

        case(state)

        //////////////////////////////////////
        //IDLE
        //////////////////////////////////////
        IDLE:
        begin
            txbusy <= 1'b0;
            sel    <= 2'b11;
            bit_count <= 3'd0;

            if(txstart)
            begin
                load  <= 1'b1;      // one clock pulse
                sel   <= 2'b00;     // Start bit
                state <= START;
                txbusy <= 1'b1;
            end
        end

        //////////////////////////////////////
        //START
        //////////////////////////////////////
        START:
        begin
            sel <= 2'b00;

            if(baud_tick)
                state <= DATA;
        end

        //////////////////////////////////////
        //DATA
        //////////////////////////////////////
        DATA:
        begin
            sel <= 2'b01;

            if(baud_tick)
            begin
                shift <= 1'b1;

                if(bit_count == 3'd7)
                begin
                    bit_count <= 3'd0;
                    state <= PARITY;
                end
                else
                    bit_count <= bit_count + 1'b1;
            end
        end

        //////////////////////////////////////
       // PARITY
        //////////////////////////////////////
        PARITY:
        begin
            sel <= 2'b10;

            if(baud_tick)
                state <= STOP;
        end

        //////////////////////////////////////
        //STOP
        //////////////////////////////////////
        STOP:
        begin
            sel <= 2'b11;

            if(baud_tick)
                state <= IDLE;
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule
