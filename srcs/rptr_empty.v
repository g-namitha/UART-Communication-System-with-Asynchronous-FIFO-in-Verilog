module rptr_empty
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                 rd_clk,
    input  wire                 rd_rst,
    input  wire                 rd_en,

    // Write pointer synchronized into read domain
    input  wire [ADDRSIZE:0]    wq2_rptr,

    output reg                  empty,

    output reg [ADDRSIZE:0]     rbin,
    output reg [ADDRSIZE:0]     rptr
);

reg rd_en_d;

wire [ADDRSIZE:0] rbinnext;
wire [ADDRSIZE:0] rgraynext;
wire              rempty_val;

//////////////////////////////////////////////////
// Delay rd_en by one clock
//////////////////////////////////////////////////

always @(posedge rd_clk or posedge rd_rst)
begin
    if(rd_rst)
        rd_en_d <= 1'b0;
    else
        rd_en_d <= rd_en;
end

//////////////////////////////////////////////////
// Next binary read pointer
//////////////////////////////////////////////////

assign rbinnext =
       rbin + (rd_en_d && !empty);

//////////////////////////////////////////////////
// Binary to Gray
//////////////////////////////////////////////////

assign rgraynext =
       (rbinnext >> 1) ^ rbinnext;

//////////////////////////////////////////////////
// Empty detection
//////////////////////////////////////////////////

assign rempty_val =
       (rgraynext == wq2_rptr);

//////////////////////////////////////////////////
// Registers
//////////////////////////////////////////////////

always @(posedge rd_clk or posedge rd_rst)
begin
    if(rd_rst)
    begin
        rbin  <= 0;
        rptr  <= 0;
        empty <= 1'b1;
    end
    else
    begin
        rbin  <= rbinnext;
        rptr  <= rgraynext;
        empty <= rempty_val;
    end
end

endmodule