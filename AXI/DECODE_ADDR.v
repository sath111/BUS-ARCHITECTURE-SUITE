module DECODE_ADDR(
    input clk, rst_n,
    input [2:0] size,
    input [31:0] addr,
    input select,
    output reg [31:0] addr_decode
);

wire [7:0] offset;
assign offset = 1 << size;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr_decode <= 0;
    end
    else begin
        if(select == 0) begin
            addr_decode <= addr;
        end
        else begin
            addr_decode <= addr_decode + offset;
        end
    end
end

endmodule