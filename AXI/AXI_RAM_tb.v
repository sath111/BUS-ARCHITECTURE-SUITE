`include "AXI_RAM.v"

module AXI_RAM_tb;

reg clk, rst_n;

    //S_AW
    wire s_awready;
    reg s_awvalid;
    reg [1:0] s_awburst;
    reg [2:0] s_awsize;
    reg [7:0] s_awlen;
    reg [31:0] s_awaddr;

    //S_W
    wire s_wready;
    reg s_wvalid;
    reg s_wlast;
    reg [63:0] s_wdata;
    reg [7:0] s_wstrb;

    //S_B
    wire s_bvalid;
    reg s_bready;
    wire [1:0] s_bresp;

    //S_AR
    wire s_arready;
    reg s_arvalid;
    reg [1:0] s_arburst;
    reg [2:0] s_arsize;
    reg [7:0] s_arlen;
    reg [31:0] s_araddr;

    //S_R
    wire s_rvalid;
    reg s_rready;
    wire s_rlast;
    wire [63:0] s_rdata;
    wire [1:0] s_rresp;

AXI_RAM dut(
    .clk(clk),
    .rst_n(rst_n),

    .s_awready(s_awready),
    .s_awvalid(s_awvalid),
    .s_awburst(s_awburst),
    .s_awsize(s_awsize),
    .s_awlen(s_awlen),
    .s_awaddr(s_awaddr),

    .s_wready(s_wready),
    .s_wvalid(s_wvalid),
    .s_wlast(s_wlast),
    .s_wdata(s_wdata),
    .s_wstrb(s_wstrb),

    .s_bvalid(s_bvalid),
    .s_bready(s_bready),
    .s_bresp(s_bresp),

    .s_arready(s_arready),
    .s_arvalid(s_arvalid),
    .s_arburst(s_arburst),
    .s_arsize(s_arsize),
    .s_arlen(s_arlen),
    .s_araddr(s_araddr),

    .s_rvalid(s_rvalid),
    .s_rready(s_rready),
    .s_rlast(s_rlast),
    .s_rdata(s_rdata),
    .s_rresp(s_rresp)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("AXI_RAM_tb.vcd");
    $dumpvars(0, AXI_RAM_tb);

    clk = 0;
    rst_n = 0;

    s_awvalid = 0;
    s_awburst = 0;
    s_awsize = 0;
    s_awlen = 0;
    s_awaddr = 0;

    s_wvalid = 0;
    s_wlast = 0;
    s_wdata = 0;
    s_wstrb = 0;

    s_bready = 0;

    s_arvalid = 0;
    s_arburst = 0;
    s_arsize = 0;
    s_arlen = 0;
    s_araddr = 0;

    s_rready = 0;

    #30 rst_n = 1;
    //
    #10 
    s_awvalid = 1;
    s_awburst = 1;
    s_awsize = 3;
    s_awlen = 7;
    s_awaddr = 0;

    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 5;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 6;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 7;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 8;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 9;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 10;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 11;
    s_wstrb = 8'b11111111;

    #10
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 1;
    s_wdata = 12;
    s_wstrb = 8'b11111111;
//

    #10
    s_wvalid = 0;
    s_bready = 1;

    s_rready = 1;
    s_arvalid = 1;
    s_arburst = 1;
    s_arsize = 3;
    s_arlen = 7;
    s_araddr = 0;


//
    #10 
    s_arvalid = 0;
    s_awvalid = 1;
    s_awburst = 1;
    s_awsize = 3;
    s_awlen = 7;
    s_awaddr = 64;

    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 13;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 14;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 15;
    s_wstrb = 8'b11111111;

    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 16;
    s_wstrb = 8'b11111111;
    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 17;
    s_wstrb = 8'b11111111;
    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 18;
    s_wstrb = 8'b11111111;
    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 0;
    s_wdata = 19;
    s_wstrb = 8'b11111111;
    #10 
    s_awvalid = 0;
    s_wvalid = 1;
    s_wlast = 1;
    s_wdata = 20;
    s_wstrb = 8'b11111111;

    #10
    s_wvalid = 0;
    s_rready = 1;
    s_arvalid = 1;
    s_arburst = 1;
    s_arsize = 3;
    s_arlen = 7;
    s_araddr = 64;
    #10 s_arvalid = 0;
    #300;
    $finish;

end

endmodule