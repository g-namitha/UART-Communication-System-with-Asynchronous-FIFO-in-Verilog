module rx_fsm(

    input clk,
    input rst,

    input start_valid,
    input baud_tick,

    output reg shift,
    output reg sample_done,
    output reg parity_load,
    output reg check_stop,
    output reg rx_done

);

reg [1:0] state;
reg [2:0] bit_count;

localparam IDLE   = 2'd0;
localparam DATA   = 2'd1;
localparam PARITY = 2'd2;
localparam STOP   = 2'd3;

//////////////////////////////////////////////////
// State Machine
//////////////////////////////////////////////////

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state     <= IDLE;
        bit_count <= 3'd0;
        rx_done   <= 1'b0;
    end
    else
    begin
        // Default
        rx_done <= 1'b0;

        case(state)

        //////////////////////////////////////////////////
        
        //////////////////////////////////////////////////
        IDLE:
        begin
            bit_count <= 3'd0;

            if(start_valid)
                state <= DATA;
        end

        //////////////////////////////////////////////////
        
        //////////////////////////////////////////////////
        DATA:
        begin
            if(baud_tick)
            begin
                if(bit_count == 3'd7)
                begin
                    bit_count <= 3'd0;
                    state <= PARITY;
                end
                else
                    bit_count <= bit_count + 1'b1;
            end
        end

        //////////////////////////////////////////////////
        
        //////////////////////////////////////////////////
        PARITY:
        begin
            if(baud_tick)
                state <= STOP;
        end

        //////////////////////////////////////////////////
        
        //////////////////////////////////////////////////
        STOP:
        begin
            if(baud_tick)
            begin
                rx_done <= 1'b1;   // One-clock pulse
                state   <= IDLE;
            end
        end

        default:
            state <= IDLE;

        endcase
    end
end

//////////////////////////////////////////////////
// Output Logic
//////////////////////////////////////////////////

always @(*)
begin

    shift       = 1'b0;
    sample_done = 1'b0;
    parity_load = 1'b0;
    check_stop  = 1'b0;

    case(state)

    DATA:
    begin
        if(baud_tick)
        begin
            shift       = 1'b1;
            sample_done = 1'b1;
        end
    end

    PARITY:
    begin
        if(baud_tick)
            parity_load = 1'b1;
    end

    STOP:
    begin
        if(baud_tick)
            check_stop = 1'b1;
    end

    endcase
end

endmodule 