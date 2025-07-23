module FSM_MASTER_READ(
    input clk, rst_n,

    input m_arvalid,
    output reg m_arready,

    input [1:0] m_arburst,
    input [7:0] m_arlen,
    
    input m_rvalid,
    output m_rready,

    output m_rlast,

    output [1:0] m_rresp,

    output select_address,

    output reg o_ren
);

localparam IDLE = 0,
           TRANSFER = 1;

reg state, next_state;
reg [7:0] cnt_read;
always @(*) begin
    case(state)
        IDLE: next_state = (m_arvalid) ? TRANSFER : IDLE;
        TRANSFER: next_state = (cnt_read == m_arlen + 1) ? IDLE : TRANSFER;
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

//m_arready
always @(*) begin
    m_arready = 0;
    if(state == TRANSFER && cnt_read == m_arlen + 1) begin
        m_arready = 1;
    end
end

//cnt_read
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_read <= 0;
    end
    else begin
        if(state == TRANSFER && !m_rlast_stage0) begin
            cnt_read <= cnt_read + 1;
        end
        else if(m_rlast_stage0) begin
            cnt_read <= 0;
        end
    end
end

//m_rready
reg m_rready_stage0;
reg m_rready_stage1;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        m_rready_stage0 <= 0;
    end
    else begin
        if(state == TRANSFER && cnt_read != m_arlen + 1) begin
            m_rready_stage0 <= 1;
        end
        else m_rready_stage0 <= 0;
    end
end



//m_rlast
reg m_rlast_stage0;
reg m_rlast_stage1;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        m_rlast_stage0 <= 0;
    end
    else begin
        if(state == TRANSFER && cnt_read == m_arlen) begin
            m_rlast_stage0 <= 1;
        end
        else m_rlast_stage0 <= 0;
    end
end

//m_rresp
reg [1:0] m_rresp_stage0;
reg [1:0] m_rresp_stage1;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        m_rresp_stage0 <= 0;
    end
    else begin
        if(state == TRANSFER) begin
            m_rresp_stage0 <= 2'b00; //okay
        end
        else m_rresp_stage0 <= 2'b11; //error
    end
end

/*
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        m_rready_stage1 <= 0;
        m_rlast_stage1 <= 0;
        m_rresp_stage1 <= 0;
    end
    else begin
        m_rready_stage1 <= m_rready_stage0;
        m_rlast_stage1 <= m_rlast_stage0;
        m_rresp_stage1 <= m_rresp_stage0;
    end
end*/

assign m_rready = m_rready_stage0;
assign m_rlast  = m_rlast_stage0;
assign m_rresp  = m_rresp_stage0;
assign select_address = (state == TRANSFER && m_arburst == 2'b01);


always @(*) begin
    o_ren = 0;
    if(state == TRANSFER) begin
        o_ren = 1;
    end
end

endmodule