module sync_w2r
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                 rd_clk,
    input  wire                 rd_rst,
    input  wire [ADDRSIZE:0]    wptr_gray,

    output reg  [ADDRSIZE:0]    wq2_rptr
);

reg [ADDRSIZE:0] wq1_rptr;

always @(posedge rd_clk or posedge rd_rst)
begin
    if(rd_rst)
    begin
        wq1_rptr <= 0;
        wq2_rptr <= 0;
    end
    else
    begin
        wq1_rptr <= wptr_gray;
        wq2_rptr <= wq1_rptr;
    end
end

endmodule