module async_fifo_top
#(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)
(
    input  wire                  wr_clk,
    input  wire                  rd_clk,

    input  wire                  wr_rst,
    input  wire                  rd_rst,

    input  wire                  wr_en,
    input  wire                  rd_en,

    input  wire [DATASIZE-1:0]   wdata,
    input wire sop_in,
    input wire eop_in,

    output wire [DATASIZE-1:0]   rdata,
    output wire sop_out,
    output wire eop_out,

    output wire                  full,
    output wire                  empty,

    output wire                  almost_full,
    output wire                  almost_empty,
     output wire [ADDRSIZE:0] occupancy
);


//--------------------------------------------------
// Internal Signals
//--------------------------------------------------

wire [ADDRSIZE:0] wbin;
wire [ADDRSIZE:0] wptr;

wire [ADDRSIZE:0] rbin;
wire [ADDRSIZE:0] rptr;

wire [ADDRSIZE:0] rq2_wptr;
wire [ADDRSIZE:0] wq2_rptr;
wire [DATASIZE+1:0] fifo_wdata;
wire [DATASIZE+1:0] fifo_rdata;




//--------------------------------------------------
// Occupancy Calculation
//--------------------------------------------------
assign fifo_wdata =
{
    sop_in,
    eop_in,
    wdata
};
assign occupancy = wbin - rbin;

assign almost_full =
       (occupancy >= ((1<<ADDRSIZE)-2));

assign almost_empty =
       (occupancy <= 1);


//--------------------------------------------------
// Read Pointer Synchronizer
// Read Domain --> Write Domain
//--------------------------------------------------

sync_r2w #(
    .ADDRSIZE(ADDRSIZE)
)
u_sync_r2w
(
    .wr_clk    (wr_clk),
    .wr_rst    (wr_rst),

    .rptr_gray (rptr),

    .rq2_wptr  (rq2_wptr)
);


//--------------------------------------------------
// Write Pointer Synchronizer
// Write Domain --> Read Domain
//--------------------------------------------------

sync_w2r #(
    .ADDRSIZE(ADDRSIZE)
)
u_sync_w2r
(
    .rd_clk    (rd_clk),
    .rd_rst    (rd_rst),

    .wptr_gray (wptr),

    .wq2_rptr  (wq2_rptr)
);


//--------------------------------------------------
// Write Pointer + Full Logic
//--------------------------------------------------

wptr_full #(
    .ADDRSIZE(ADDRSIZE)
)
u_wptr_full
(
    .wr_clk    (wr_clk),
    .wr_rst    (wr_rst),
    .wr_en     (wr_en),

    .rq2_wptr  (rq2_wptr),

    .full      (full),

    .wbin      (wbin),
    .wptr      (wptr)
);


//--------------------------------------------------
// Read Pointer + Empty Logic
//--------------------------------------------------

rptr_empty #(
    .ADDRSIZE(ADDRSIZE)
)
u_rptr_empty
(
    .rd_clk    (rd_clk),
    .rd_rst    (rd_rst),
    .rd_en     (rd_en),

    .wq2_rptr  (wq2_rptr),

    .empty     (empty),

    .rbin      (rbin),
    .rptr      (rptr)
);


//--------------------------------------------------
// FIFO Memory
//--------------------------------------------------

fifo_mem #(
    .DATASIZE(DATASIZE),
    .ADDRSIZE(ADDRSIZE)
)
u_fifo_mem
(
    .wr_clk (wr_clk),

    .wr_en  (wr_en && !full),

    .waddr  (wbin[ADDRSIZE-1:0]),
    .raddr  (rbin[ADDRSIZE-1:0]),

    .wdata(fifo_wdata),
.rdata(fifo_rdata)
);
assign sop_out = fifo_rdata[DATASIZE+1];

assign eop_out = fifo_rdata[DATASIZE];

assign rdata =
       fifo_rdata[DATASIZE-1:0];
endmodule