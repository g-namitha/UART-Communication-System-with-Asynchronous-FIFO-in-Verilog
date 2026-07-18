module sync_r2w
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                 wr_clk,
    input  wire                 wr_rst,
    input  wire [ADDRSIZE:0]    rptr_gray,

    output reg  [ADDRSIZE:0]    rq2_wptr
);

reg [ADDRSIZE:0] rq1_wptr;

always @(posedge wr_clk or posedge wr_rst)
begin
    if(wr_rst)
    begin
        rq1_wptr <= 0;
        rq2_wptr <= 0;
    end
    else
    begin
        rq1_wptr <= rptr_gray;
        rq2_wptr <= rq1_wptr;
    end
end

endmodule