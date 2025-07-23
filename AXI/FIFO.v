module FIFO #(
    parameter d_width = 101
)
(
    input clk, rst_n,
    input i_push, i_pop,
    input [d_width -1 : 0] i_data,

    output o_empty,
    output o_full,
    output [d_width -1 : 0] o_data
);

reg [3:0] w_ptr, r_ptr;
reg [d_width -1 : 0] mem_data [0:15];
integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 16; i = i + 1) begin
            mem_data[i] <= 101'd0;
        end
        w_ptr <= 0;
        r_ptr <= 0;
    end
    else begin
        if(i_push && !o_full) begin
            mem_data[w_ptr] <= i_data;
            w_ptr <= w_ptr + 1;
        end
        if(i_pop && !o_empty) begin
            r_ptr <= r_ptr + 1;
        end
    end
end

assign o_data = mem_data[r_ptr];
assign o_full = ((w_ptr + 1) == r_ptr) ? 1 : 0;
assign o_empty = (w_ptr == r_ptr) ? 1 : 0;

endmodule