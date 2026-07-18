module fifo_mem
#(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)
(
    input wire wr_clk,
    input wire wr_en,

    input wire [ADDRSIZE-1:0] waddr,
    input wire [ADDRSIZE-1:0] raddr,

    input wire [DATASIZE+1:0] wdata,

    output wire [DATASIZE+1:0] rdata
);

reg [DATASIZE+1:0] mem [0:(1<<ADDRSIZE)-1];

always @(posedge wr_clk)
begin
    if(wr_en)
        mem[waddr] <= wdata;
end

assign rdata = mem[raddr];

endmodule