module FSM_d_masterv1 #(
    parameter band_width = 3
)
(
    input clk, rst_n,
    input i_empty_FIFO_request,
    output reg o_pop_FIFO_request,
    input [36:0] i_read_request,

    output reg o_ren,
    output reg [31:0] o_read_address,

    input s_d_ready,
    output reg s_d_valid,
    output reg [36:0] o_header
);

localparam IDLE = 0,
           READ_BURST = 1;
reg state, next_state;


reg [36:0] reg_read_request;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reg_read_request <= 0;
        o_pop_FIFO_request <= 1'b0;
    end
    else begin
        if(i_empty_FIFO_request && state == IDLE) begin
            reg_read_request <= i_read_request;
            o_pop_FIFO_request <= 1'b1;
        end
        else begin
//            reg_read_request <= 0;
            o_pop_FIFO_request <= 1'b0;
        end
    end
end

wire [2:0] opcode;
wire [2:0] size;
wire [3:0] mark;
wire [26:0] address;
assign opcode = reg_read_request[36:34];
assign size = reg_read_request[33:31];
assign mark = reg_read_request[30:27];
assign address = reg_read_request[26:0];

wire [3:0] beat;
wire [3:0] cnt_read_burst;
assign beat = ({1'b0, size}) - ({1'b0, band_width});
assign cnt_read_burst = (beat >= 0) ? ((1 << beat)) : 1;
reg [3:0] cnt;


always @(*) begin
    case(state)
        IDLE: next_state = (i_empty_FIFO_request) ? READ_BURST : IDLE;
        READ_BURST: next_state = (opcode == 0 || cnt == cnt_read_burst) ? IDLE : READ_BURST;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end


reg [5:0] offset;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 0;
    end
    else begin
        if(state == READ_BURST && opcode == 1 && s_d_ready && cnt != cnt_read_burst) begin
            cnt <= cnt + 1;
        end
        else if(cnt == cnt_read_burst || state == IDLE) begin
            cnt <= 0;
        end
    end
end
always @(*) begin
    offset = cnt << 3;
end

always @(*) begin
    if(state == READ_BURST && opcode == 1 && cnt != cnt_read_burst && s_d_ready) begin
        o_ren <= 1'b1;
        o_read_address <= {address, offset};
    end
    else begin
        o_ren <= 1'b0;
        o_read_address <= 32'd0; 
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        s_d_valid <= 0;
    end
    else begin
        if((state == READ_BURST) && s_d_ready && cnt != cnt_read_burst) begin
            s_d_valid <= 1;
        end
        else begin
            s_d_valid <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        o_header <= 0;
    end
    else begin
        if((opcode == 0 || opcode == 1) && s_d_ready ) begin
            o_header =  {opcode, size, mark, address};
        end
    end
end


endmodule