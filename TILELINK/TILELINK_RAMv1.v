`include "RAM.v"
`include "FSM_a_slavev1.v"
`include "FIFO.v"
`include "FSM_d_masterv1.v"

module TILELINK_RAMv1(
    input clk, rst_n,
    
    output s_a_ready,
    input s_a_valid,
    input [100:0] i_data,

    output m_d_valid,
    input m_d_ready,
    output [100:0] o_data
);

//FIFO A
wire m_a_valid, m_a_ready;
wire [100:0] i_header_a_slave;
FIFO FIFO_inst0(
    .clk(clk),
    .rst_n(rst_n),
    .i_push(s_a_valid),
    .o_full(s_a_ready),
    .i_data(i_data),
    .o_empty(m_a_valid),
    .i_pop(m_a_ready),
    .o_data(i_header_a_slave)
);
assign m_a_validv1 = ~m_a_valid;

wire o_wen;
wire [95:0] o_packet;
wire [36:0] o_read_request;
wire o_push_request;
wire i_full_FIFO_request;
FSM_a_slavev1 FSM_a_slavev1_inst(
    .clk(clk),
    .rst_n(rst_n),
    .m_a_valid(m_a_validv1),
    .m_a_ready(m_a_ready),
    .i_header(i_header_a_slave),
    .o_wen(o_wen),
    .o_packet(o_packet),
    .o_read_request(o_read_request),
    .o_push_request(o_push_request),
    .i_full_FIFO_request(i_full_FIFO_request)
);
wire i_full_FIFO_requestv1;
assign i_full_FIFO_request = ~i_full_FIFO_requestv1;
wire o_empty_FIFO_request;
wire i_pop_FIFO_request;
wire [36:0] o_data_FIFO_request;
FIFO #(
    .d_width(37)
)
FIFO_inst2(
    .clk(clk),
    .rst_n(rst_n),
    .i_push(o_push_request),
    .o_full(i_full_FIFO_requestv1),
    .i_data(o_read_request),
    .o_empty(o_empty_FIFO_request),
    .i_pop(i_pop_FIFO_request),
    .o_data(o_data_FIFO_request)
);
wire o_empty_FIFO_requestv1;
assign o_empty_FIFO_requestv1 = ~o_empty_FIFO_request;
wire s_d_ready, s_d_valid;
wire [36:0] o_header;
FSM_d_masterv1 FSM_d_masterv1_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_empty_FIFO_request(o_empty_FIFO_requestv1),
    .i_read_request(o_data_FIFO_request),
    .o_pop_FIFO_request(i_pop_FIFO_request),
    .o_ren(i_ren),
    .o_read_address(i_read_address),
    .s_d_ready(s_d_readyv1),
    .s_d_valid(s_d_valid),
    .o_header(o_header)
);

//RAM
wire i_ren;
wire [31:0] i_read_address;
wire [63:0] o_data_ram;
RAM RAM_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_wen(o_wen),
    .i_write_address(o_packet[95:64]),
    .i_data(o_packet[63:0]),
    .i_ren(i_ren),
    .i_read_address(i_read_address),
    .o_data(o_data_ram)
);


assign s_d_readyv1 = ~s_d_ready;
//FIFO D

FIFO FIFO_inst1(
    .clk(clk),
    .rst_n(rst_n),
    .o_empty(m_d_valid),
    .i_pop(m_d_ready),
    .o_data(o_data),
    .o_full(s_d_ready),
    .i_push(s_d_valid),
    .i_data({o_header, o_data_ram})
);


endmodule