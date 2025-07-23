module BRESP(
    input clk, rst_n,
    input [2:0] b_resp,
    input m_bvalid,
    output reg m_bready,
    output reg  [1:0] m_bresp
);

always @(*) begin
    m_bready = 0;
    m_bresp = 0;
    if(b_resp == 3'b100 && m_bvalid) begin
        m_bready = 1;
        m_bresp = 0;
    end
end

endmodule