`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:44:08
// Design Name: 
// Module Name: uart_fifo
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
module uart_fifo_top(

    input  wire clk,
    input  wire rst,

    input  wire rx_in,
    output wire tx_out

);

//////////////////////////////////////////////////
// Baud Generator
//////////////////////////////////////////////////

wire baud_tick;

baud_gen u_baud(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

//////////////////////////////////////////////////
// UART RX
//////////////////////////////////////////////////

wire [7:0] rx_data;
wire rx_done;

wire parity_error;
wire stop_error;

uart_rx_top u_rx(

    .clk(clk),
    .rst(rst),

    .rx_in(rx_in),
    .baud_tick(baud_tick),

    .rx_data(rx_data),
    .rx_done(rx_done),

    .parity_error(parity_error),
    .stop_error(stop_error)

);

//////////////////////////////////////////////////
// FIFO
//////////////////////////////////////////////////

wire [7:0] fifo_data;

wire full;
wire empty;

wire almost_full;
wire almost_empty;

wire [4:0] occupancy;

reg rd_en;

async_fifo_top #(
    .DATASIZE(8),
    .ADDRSIZE(4)
)
u_fifo(

    .wr_clk(clk),
    .rd_clk(clk),

    .wr_rst(rst),
    .rd_rst(rst),

    .wr_en(rx_done),
    .rd_en(rd_en),

    .wdata(rx_data),

    .sop_in(1'b0),
    .eop_in(1'b0),

    .rdata(fifo_data),

    .sop_out(),
    .eop_out(),

    .full(full),
    .empty(empty),

    .almost_full(almost_full),
    .almost_empty(almost_empty),

    .occupancy(occupancy)

);

//////////////////////////////////////////////////
// TX
//////////////////////////////////////////////////

reg txstart;
wire txbusy;

reg [7:0] tx_data_reg;

uart_tx_top u_tx(

    .clk(clk),
    .rst(rst),

    .txstart(txstart),
    .tx_data(tx_data_reg),

    .baud_tick(baud_tick),

    .tx(tx_out),
    .txbusy(txbusy)

);

//////////////////////////////////////////////////
// Read Controller FSM
//////////////////////////////////////////////////

localparam WAIT_DATA = 2'd0;
localparam READ_FIFO = 2'd1;
localparam START_TX  = 2'd2;

reg [1:0] ctrl_state;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        ctrl_state  <= WAIT_DATA;
        rd_en       <= 1'b0;
        txstart     <= 1'b0;
        tx_data_reg <= 8'h00;
    end

    else
    begin

        rd_en   <= 1'b0;
        txstart <= 1'b0;

        case(ctrl_state)

        //////////////////////////////////////////////////
        // Wait until FIFO has data
        //////////////////////////////////////////////////

        WAIT_DATA:
        begin
            if(!empty && !txbusy)
            begin
                rd_en <= 1'b1;
                ctrl_state <= READ_FIFO;
            end
        end

        //////////////////////////////////////////////////
        // Capture FIFO output
        //////////////////////////////////////////////////

        READ_FIFO:
        begin
            tx_data_reg <= fifo_data;
            ctrl_state <= START_TX;
        end

        //////////////////////////////////////////////////
        // Start UART TX
        //////////////////////////////////////////////////

        START_TX:
        begin
            txstart <= 1'b1;
            ctrl_state <= WAIT_DATA;
        end

        default:
            ctrl_state <= WAIT_DATA;

        endcase

    end

end

endmodule