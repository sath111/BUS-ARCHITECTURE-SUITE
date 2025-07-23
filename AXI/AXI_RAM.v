`include "FSM_MASTER_READ.v"
`include "FSM_MASTER_WRITE.v"
`include "BRESP.v"
`include "FIFO.v"
`include "RAM.v"
`include "LANE_EN_WRITE.v"
`include "DECODE_ADDR.v"

module AXI_RAM(
    input clk, rst_n,

    //S_AW
    output s_awready,
    input s_awvalid,
    input [1:0] s_awburst,
    input [2:0] s_awsize,
    input [7:0] s_awlen,
    input [31:0] s_awaddr,

    //S_W
    output s_wready,
    input s_wvalid,
    input s_wlast,
    input [63:0] s_wdata,
    input [7:0] s_wstrb,

    //S_B
    output s_bvalid,
    input s_bready,
    output [1:0] s_bresp,

    //S_AR
    output s_arready,
    input s_arvalid,
    input [1:0] s_arburst,
    input [2:0] s_arsize,
    input [7:0] s_arlen,
    input [31:0] s_araddr,

    //S_R
    output s_rvalid,
    input s_rready,
    output s_rlast,
    output [63:0] s_rdata,
    output [1:0] s_rresp
);

//AW
wire m_awready, m_awvalid;
wire empty_AW;
assign m_awvalid = ~empty_AW;
wire [44:0] o_data_AW;
FIFO #(
    .d_width(45)
)
FIFO_AW(
    .clk(clk),
    .rst_n(rst_n),
    .i_push(s_awvalid),
    .i_pop(m_awready),
    .i_data({s_awburst, s_awlen, s_awsize, s_awaddr}),
    .o_empty(empty_AW),
    .o_full(s_awready),
    .o_data(o_data_AW)
);

//W
wire m_wready, m_wvalid;
wire empty_W;
assign m_wvalid = ~empty_W;
wire [72:0] o_data_W;
FIFO #(
    .d_width(73)
)
FIFO_W(
    .clk(clk),
    .rst_n(rst_n),
    .i_push(s_wvalid),
    .i_pop(m_wready),
    .i_data({s_wlast, s_wdata, s_wstrb}),
    .o_empty(empty_W),
    .o_full(s_wready),
    .o_data(o_data_W)
);

//B
wire [1:0] m_bresp;
wire m_bvalid, m_bready;
wire full_B;
assign m_bvalid = ~full_B;
FIFO #(
    .d_width(2)
)
FIFO_B(
    .clk(clk),
    .rst_n(rst_n),
    .i_push(m_bready),
    .i_pop(s_bready),
    .i_data(m_bresp),
    .o_empty(s_bvalid),
    .o_full(full_B),
    .o_data(s_bresp)
);

//AR
wire m_arready, m_arvalid;
wire empty_AR;
assign m_arvalid = ~empty_AR;
wire [44:0] o_data_AR;
FIFO #(
    .d_width(45)
)
FIFO_AR(
    .clk(clk),
    .rst_n(rst_n),
    .i_push(s_arvalid),
    .i_pop(m_arready),
    .i_data({s_arburst, s_arlen, s_arsize, s_araddr}),
    .o_empty(empty_AR),
    .o_full(s_arready),
    .o_data(o_data_AR)
);

//R
wire m_rready, m_rvalid;
wire m_rlast;
wire full_R;
assign m_rvalid = ~full_R;
wire [1:0] m_rresp;
wire [63:0] m_rdata;
FIFO #(
    .d_width(67)
)
FIFO_R(
    .clk(clk),
    .rst_n(rst_n),
    .i_push(m_rready),
    .i_pop(s_rready),
    .i_data({m_rlast, m_rdata, m_rresp}),
    .o_empty(s_rvalid),
    .o_full(full_R),
    .o_data({s_rlast, s_rdata, s_rresp})
);

wire [2:0] b_resp;
wire select_address_write;
wire wen_RAM;
FSM_MASTER_WRITE FSM_MASTER_WRITE_inst(
    .clk(clk),
    .rst_n(rst_n),
    .m_awvalid(m_awvalid),
    .m_awready(m_awready),
    .m_awburst(o_data_AW[44:43]),
    .m_awlen(o_data_AW[42:35]),
    .m_wvalid(m_wvalid),
    .m_wready(m_wready),
    .m_wlast(o_data_W[72]),
    .b_reps(b_resp),
    .select_address(select_address_write),
    .o_wen(wen_RAM)
);
wire [31:0] address_write_RAM;
DECODE_ADDR DECODE_ADDR_inst0(
    .clk(clk),
    .rst_n(rst_n),
    .size(o_data_AW[34:32]),
    .addr(o_data_AW[31:0]),
    .select(select_address_write),
    .addr_decode(address_write_RAM)
);

BRESP BRESP_inst(
    .clk(clk),
    .rst_n(rst_n),
    .b_resp(b_resp),
    .m_bvalid(m_bvalid),
    .m_bready(m_bready),
    .m_bresp(m_bresp)
);

wire select_address_read;
wire ren_RAM;
FSM_MASTER_READ FSM_MASTER_READ_inst(
    .clk(clk),
    .rst_n(rst_n),
    .m_arvalid(m_arvalid),
    .m_arready(m_arready),
    .m_arburst(o_data_AR[44:43]),
    .m_arlen(o_data_AR[42:35]),
    .m_rvalid(m_rvalid),
    .m_rready(m_rready),
    .m_rlast(m_rlast),
    .m_rresp(m_rresp),
    .select_address(select_address_read),
    .o_ren(ren_RAM)
);
wire [31:0] address_read_RAM;
DECODE_ADDR DECODE_ADDR_inst1(
    .clk(clk),
    .rst_n(rst_n),
    .size(o_data_AR[34:32]),
    .addr(o_data_AR[31:0]),
    .select(select_address_read),
    .addr_decode(address_read_RAM)
);

wire [63:0] write_data_RAM;
LANE_EN_WRITE LANE_EN_WRITE_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_data(o_data_W[71:8]),
    .byte_enable(o_data_W[7:0]),
    .o_data(write_data_RAM)
);

RAM RAM_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_wen(wen_RAM),
    .i_write_address(address_write_RAM),
    .i_data(write_data_RAM),
    .i_ren(ren_RAM),
    .i_read_address(address_read_RAM),
    .o_data(m_rdata)
);


endmodule