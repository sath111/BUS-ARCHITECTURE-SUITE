module RAM(
    input clk, rst_n,

    input i_wen,
    input [31:0] i_write_address,
    input [63:0] i_data,

    input i_ren,
    input [31:0] i_read_address,
    output reg [63:0] o_data
);

reg [7:0] mem_data [0:1023];
integer i;
initial begin
    for(i = 0; i < 1024; i = i + 1) begin
        mem_data[i] = 8'd0;
    end
end

always @(posedge clk) begin
    if(i_wen) begin
        mem_data[i_write_address] <= i_data[7:0];
        mem_data[i_write_address + 1] <= i_data[15:8];
        mem_data[i_write_address + 2] <= i_data[23:16];
        mem_data[i_write_address + 3] <= i_data[31:24];
        mem_data[i_write_address + 4] <= i_data[39:32];
        mem_data[i_write_address + 5] <= i_data[47:40];
        mem_data[i_write_address + 6] <= i_data[55:48];
        mem_data[i_write_address + 7] <= i_data[63:56];
    end
end

always @(posedge clk) begin
    o_data <= 64'd0;
    if(i_ren) begin
        o_data[7:0] <= mem_data[i_read_address];
        o_data[15:8] <= mem_data[i_read_address + 1];
        o_data[23:16] <= mem_data[i_read_address + 2];
        o_data[31:24] <= mem_data[i_read_address + 3];
        o_data[39:32] <= mem_data[i_read_address + 4];
        o_data[47:40] <= mem_data[i_read_address + 5];
        o_data[55:48] <= mem_data[i_read_address + 6];
        o_data[63:56] <= mem_data[i_read_address + 7];
    end
end


endmodule