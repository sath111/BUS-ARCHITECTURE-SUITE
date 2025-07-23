`include "TILELINK_RAMv1.v"

module TILELINK_RAMv1_tb;

reg clk, rst_n;
    
wire s_a_ready;
reg s_a_valid;
reg [100:0] i_data;

wire m_d_valid;
reg m_d_ready;
wire [100:0] o_data;

TILELINK_RAMv1 dut(
    .clk(clk),
    .rst_n(rst_n),
    .s_a_ready(s_a_ready),
    .s_a_valid(s_a_valid),
    .i_data(i_data),
    .m_d_ready(m_d_ready),
    .m_d_valid(m_d_valid),
    .o_data(o_data)
);


always #5 clk = ~clk;

initial begin
    $dumpfile("TILELINK_RAMv1_tb.vcd");
    $dumpvars(0, TILELINK_RAMv1_tb);

    clk = 0;
    rst_n = 0;
    s_a_valid = 0;
    i_data = 0;
    m_d_ready = 0;

    #50 rst_n = 1;
    #10 m_d_ready = 1;

    #10 s_a_valid = 1;
        i_data = {6'b000110, 4'd15, 27'd0, 64'd5};
    #10 i_data = {6'b000110, 4'd15, 27'd0, 64'd6};
    #10 i_data = {6'b000110, 4'd15, 27'd0, 64'd7};
    #10 i_data = {6'b000110, 4'd15, 27'd0, 64'd8};
    #10 i_data = {6'b000110, 4'd15, 27'd0, 64'd9};
    #10 i_data = {6'b000110, 4'd15, 27'd0, 64'd10};
    #10 i_data = {6'b000110, 4'd15, 27'd0, 64'd11};
    #10 i_data = {6'b000110, 4'd15, 27'd0, 64'd12};
//    #10 s_a_valid = 0; i_data = 0;

    #10 s_a_valid = 1; i_data = {3'd4, 3'd6, 4'd15, 27'd0, 64'd0};
//   #10 s_a_valid = 0; i_data = 0;

    #10 s_a_valid = 1;
        i_data = {6'b000110, 4'd15, 27'd1, 64'd12};
    #10 i_data = {6'b000110, 4'd15, 27'd1, 64'd13};
    #10 i_data = {6'b000110, 4'd15, 27'd1, 64'd14};
    #10 i_data = {6'b000110, 4'd15, 27'd1, 64'd15};
    #10 i_data = {6'b000110, 4'd15, 27'd1, 64'd16};
    #10 i_data = {6'b000110, 4'd15, 27'd1, 64'd17};
    #10 i_data = {6'b000110, 4'd15, 27'd1, 64'd18};
    #10 i_data = {6'b000110, 4'd15, 27'd1, 64'd19};
//    #10 s_a_valid = 0; i_data = 0;

    #10 s_a_valid = 1; i_data = {3'd4, 3'd6, 4'd15, 27'd1, 64'd0};
    #10 s_a_valid = 0; i_data = 0;

    #300;
/*

    #10 s_a_valid = 1; i_data = {6'b00001, 4'd15, 27'd0, 64'd5};
    #10 s_a_valid = 1; i_data = {6'b00001, 4'd15, 27'd1, 64'd6};
    #10 s_a_valid = 1; i_data = {6'b00001, 4'd15, 27'd2, 64'd7};
    #10 s_a_valid = 1; i_data = {3'd4, 3'd1, 4'd15, 27'd1, 64'd0};
    #10 s_a_valid = 1; i_data = {3'd4, 3'd1, 4'd15, 27'd2, 64'd0};
    #10 s_a_valid = 1; i_data = {3'd4, 3'd1, 4'd15, 27'd0, 64'd0};
    #10 s_a_valid = 0; i_data = 0;
    #200
*/
    $finish;

end

endmodule