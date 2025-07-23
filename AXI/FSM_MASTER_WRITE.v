module FSM_MASTER_WRITE(
    input clk, rst_n,
    
    input m_awvalid,
    output reg m_awready,

    input [1:0] m_awburst,
    input [7:0] m_awlen,
    
    input m_wvalid,
    output reg m_wready,
    input m_wlast,

    output reg [2:0] b_reps,

    output reg select_address,

    output reg o_wen
);

localparam IDLE = 0,
           TRANSFER = 1;

reg state, next_state;
reg [7:0] cnt_push;
always @(*) begin
    case(state)
        IDLE: next_state = (m_awvalid && m_wvalid) ? TRANSFER : IDLE;
        TRANSFER: next_state = (m_wlast) ? IDLE : TRANSFER;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

//m_awready
always @(*) begin
    m_awready = 0;
    if(m_wlast && state == TRANSFER) begin
        m_awready = 1;
    end
end

//cnt_push
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_push <= 0;
    end
    else begin
        if((state == TRANSFER && !m_wlast)|| (state == IDLE && m_awvalid && m_wvalid)) begin
            cnt_push <= cnt_push + 1;
        end
        else if(state == TRANSFER && m_wlast) begin
            cnt_push <= 0;
        end
    end
end

//m_wready
always @(*) begin
    m_wready = 0;
    if(state == TRANSFER || (state == IDLE && m_awvalid && m_wvalid)) begin
        m_wready = 1;
    end
end

//b_reps
always @(*) begin
    if(m_wlast && cnt_push == m_awlen && state == TRANSFER) begin
        b_reps = 3'b100; //okay
    end
    else begin
        b_reps = 3'b111; //error
    end
end

//select_address
always @(*) begin
    select_address = 0;
    if(state == TRANSFER && m_awburst == 2'b01) begin
        select_address = 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        o_wen <= 0;
    end
    else begin
        if(state == TRANSFER || (state == IDLE && m_awvalid && m_wvalid)) begin
            o_wen <= 1;
        end
        else o_wen <= 0;
    end
end

endmodule