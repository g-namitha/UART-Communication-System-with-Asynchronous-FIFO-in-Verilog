module wptr_full
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                 wr_clk,
    input  wire                 wr_rst,
    input  wire                 wr_en,

    // Read pointer synchronized into write domain
    input  wire [ADDRSIZE:0]    rq2_wptr,

    output reg                  full,

    output reg [ADDRSIZE:0]     wbin,
    output reg [ADDRSIZE:0]     wptr
);

wire [ADDRSIZE:0] wbinnext;
wire [ADDRSIZE:0] wgraynext;
wire              wfull_val;


// Next binary write pointer
assign wbinnext =
       wbin + (wr_en && !full);


// Binary to Gray conversion
assign wgraynext =
       (wbinnext >> 1) ^ wbinnext;


// Full detection
assign wfull_val =
       (wgraynext ==
        {~rq2_wptr[ADDRSIZE:ADDRSIZE-1],
          rq2_wptr[ADDRSIZE-2:0]});


// Register updates
always @(posedge wr_clk or posedge wr_rst)
begin
    if(wr_rst)
    begin
        wbin <= 0;
        wptr <= 0;
        full <= 0;
    end
    else
    begin
        wbin <= wbinnext;
        wptr <= wgraynext;
        full <= wfull_val;
    end
end

endmodule