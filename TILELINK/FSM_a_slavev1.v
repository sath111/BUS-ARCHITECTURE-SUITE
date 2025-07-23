module FSM_a_slavev1 #(
    parameter [2:0] band_width = 3
)
(
    input clk, rst_n,

    input m_a_valid,
    output reg m_a_ready,

    input [100:0] i_header,
    output reg o_wen,
    output reg [95:0] o_packet, // address = 32, data = 64;

    output reg [36:0] o_read_request,
    output reg o_push_request,
    input i_full_FIFO_request
);

wire [2:0] opcode;
wire [2:0] size;
wire [3:0] mark; 
wire [26:0] address;
wire [63:0] data;
assign opcode = i_header[100:98];
assign size = i_header[97:95];
assign mark = i_header[94:91];
assign address = i_header[90:64];
assign data = i_header[63:0];

wire [3:0] beat;
wire [3:0] cnt_push_burst;
assign beat = ({1'b0, size}) - ({1'b0, band_width});
assign cnt_push_burst = (beat >= 0) ? ((1 << beat)) : 3'd1;
reg [3:0] cnt;
reg [5:0] offset;



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 1;
    end
    else begin
        if(m_a_valid) begin
            cnt <= cnt + 1;
            if(cnt == cnt_push_burst) begin
                cnt <= 0;
            end
        end
    end
end

always @(*) begin
    offset = (cnt - 1) << 3;
end

always @(*) begin
    m_a_ready = 0;
    if(m_a_valid) begin
        m_a_ready = 1;
    end
end

always @(*) begin
    o_wen = 1'b0;
    o_packet = 96'd0;
    if(m_a_valid && opcode == 0) begin
        o_wen = 1'b1;
        o_packet = {address, offset, data};
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        o_read_request <= 37'd0;
        o_push_request <= 0;
    end
    else begin
        if(opcode == 4 && i_full_FIFO_request) begin
            o_read_request <= {3'b001, size, mark, address};
            o_push_request <= 1'd1;
        end
        else if(opcode == 0 && cnt == cnt_push_burst && cnt != 0 && i_full_FIFO_request) begin
            o_read_request <= {3'd0, size, mark, address};
            o_push_request <= 1'd1;
        end
        else begin
            o_read_request <= 37'd0;
            o_push_request <= 1'd0;
        end
    end
end

endmodule