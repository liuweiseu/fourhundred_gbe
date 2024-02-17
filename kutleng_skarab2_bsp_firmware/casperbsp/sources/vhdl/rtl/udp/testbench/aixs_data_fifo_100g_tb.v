`timescale 1ns/1ns

module axis_data_fifo_100g_tb;

parameter PERIOD = 2;
parameter G_AXIS_DATA_WIDTH = 512;
parameter CYC = 64;

reg clk;
reg rst;
//s axis
wire s_axis_aresetn;
wire s_axis_aclk;
reg s_axis_tvalid;
wire s_axis_tready;
reg [G_AXIS_DATA_WIDTH - 1 : 0] s_axis_tdata;
reg [(G_AXIS_DATA_WIDTH/8) - 1 : 0] s_axis_tkeep;
reg s_axis_tlast;
reg s_axis_tuser;
// m axis
wire m_axis_aclk;
wire m_axis_tvalid;
reg m_axis_tready;
wire [G_AXIS_DATA_WIDTH - 1 : 0] m_axis_tdata;
wire [(G_AXIS_DATA_WIDTH/8) - 1 : 0] m_axis_tkeep;
wire m_axis_tlast;
wire m_axis_tuser;
//-----------------reset & clk init-----------------
initial 
begin
    clk = 0;
    rst = 0;
    #10 rst = 1;
end
//-----------------clock generation-----------------
// 100MHz clock
always #(PERIOD/2)
begin
    clk = ~clk;
end
// connect clk and rst
assign s_axis_aresetn = rst;
assign s_axis_aclk = clk;
assign m_axis_aclk = clk;
//---------------------s axis--------------------
reg [7:0] cnt;
always @(posedge s_axis_aclk)
begin
    if(~s_axis_aresetn)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end
// s_axis_tvalid
always @(posedge s_axis_aclk)
begin
    if(~s_axis_aresetn)
        s_axis_tvalid <= 0;
    else if(cnt < CYC)
        s_axis_tvalid <= 1;
    else
        s_axis_tvalid <= 0;
end
// s_axis_tlast
always @(posedge s_axis_aclk)
begin
    if(~s_axis_aresetn)
        s_axis_tlast <= 0;
    else if(cnt == CYC - 1)
        s_axis_tlast <= 1;
    else
        s_axis_tlast <= 0;
end
// s_axis_tkeep
always @(posedge s_axis_aclk)
begin
    if(~s_axis_aresetn)
        s_axis_tkeep <= 0;
    else if(cnt < CYC)
        s_axis_tkeep <= 64'hffffffffffffffff;
    else
        s_axis_tkeep <= 0;
end
// s_axis_tuser
always @(posedge s_axis_aclk)
begin
    if(~s_axis_aresetn)
        s_axis_tuser <= 0;
    else if(cnt < CYC)
        s_axis_tuser <= 0;
    else
        s_axis_tuser <= 0;
end
// s_axis_tdata
always @(posedge s_axis_aclk)
begin
    if(~s_axis_aresetn)
        s_axis_tdata <= 0;
    else if(s_axis_tvalid)
        s_axis_tdata <= s_axis_tdata + 1;
    else
        s_axis_tdata <= 0;
end
// m_axis_tready
always @(posedge m_axis_aclk)
begin
    if(~s_axis_aresetn)
        m_axis_tready <= 0;
    else
        m_axis_tready <= 1;
end
axis_data_fifo_0  #(
    .G_AXIS_DATA_WIDTH(G_AXIS_DATA_WIDTH)
)axis_data_fifo_400g_inst(
    .s_axis_aresetn(s_axis_aresetn),
    .s_axis_aclk(s_axis_aclk),     
    .s_axis_tvalid(s_axis_tvalid),   
    .s_axis_tready(s_axis_tready),
    .s_axis_tdata (s_axis_tdata),
    .s_axis_tkeep (s_axis_tkeep),
    .s_axis_tlast (s_axis_tlast),
    .s_axis_tuser (s_axis_tuser),
    .m_axis_aclk (m_axis_aclk),
    .m_axis_tvalid (m_axis_tvalid),
    .m_axis_tready (m_axis_tready),
    .m_axis_tdata (m_axis_tdata),
    .m_axis_tkeep (m_axis_tkeep),
    .m_axis_tlast (m_axis_tlast),
    .m_axis_tuser (m_axis_tuser)
);
endmodule