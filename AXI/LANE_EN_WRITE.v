module LANE_EN_WRITE(
    input clk, rst_n,
    input [63:0] i_data,
    input [7:0] byte_enable,
    output reg [63:0] o_data
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_data <= 64'd0;
        end else begin
            if (byte_enable[0]) o_data[7:0]   <= i_data[7:0];
            if (byte_enable[1]) o_data[15:8]  <= i_data[15:8];
            if (byte_enable[2]) o_data[23:16] <= i_data[23:16];
            if (byte_enable[3]) o_data[31:24] <= i_data[31:24];
            if (byte_enable[4]) o_data[39:32] <= i_data[39:32];
            if (byte_enable[5]) o_data[47:40] <= i_data[47:40];
            if (byte_enable[6]) o_data[55:48] <= i_data[55:48];
            if (byte_enable[7]) o_data[63:56] <= i_data[63:56];
        end
    end

endmodule
