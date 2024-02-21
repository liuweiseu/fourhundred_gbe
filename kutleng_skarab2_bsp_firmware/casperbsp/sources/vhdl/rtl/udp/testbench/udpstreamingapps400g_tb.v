`timescale 1ns/1ns

module udpstreamingapps400g_tb;

parameter PERIOD = 2;
parameter G_AXIS_DATA_WIDTH = 1024;
parameter G_SLOT_WIDTH = 4;
parameter CYC = 8;
parameter PKT_LEN = 128 * CYC;

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

//-----------------reset & clk init-----------------
initial 
begin
    clk = 0;
    rst = 0;
    #10 rst = 1;
end
//-----------------clock generation-----------------
// 100MHz clock
always #(PERIOD / 2)
begin
    clk = ~clk;
end

//-------signals/regs for udpipinterfacepr400g------
// clk
wire axis_clk;
assign axis_clk = clk;
// rst
wire axis_reset;
assign axis_reset = ~rst;
// s_axis_aclk
assign s_axis_aclk = clk;

assign s_axis_aresetn = rst;

wire [G_SLOT_WIDTH - 1 : 0] axis_tx_tpriority;
wire [G_AXIS_DATA_WIDTH - 1 : 0] axis_tx_tdata;
wire axis_tx_tvalid;
wire [G_AXIS_DATA_WIDTH / 8 - 1 : 0] axis_tx_tkeep;
wire axis_tx_tlast;

// data
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
        s_axis_tkeep <= 128'hffffffffffffffffffffffffffffffff;
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

//-------------udpipinterfacepr400g_inst------------
udpstreamingapps400g#(
    .G_AXIS_DATA_WIDTH(G_AXIS_DATA_WIDTH)
)uudpstreamingapps400g_tb(
    // clk & rst
    .axis_clk(axis_clk),
    .axis_reset(axis_reset),
    // regs
    .aximm_gmac_reg_mac_address(48'h123456789abc),
    .aximm_gmac_reg_local_ip_address(32'hc0a80102),
    .aximm_gmac_reg_local_ip_netmask(32'hffffff00),
    .aximm_gmac_reg_gateway_ip_address(32'hc0a80101),
    .aximm_gmac_reg_multicast_ip_address(32'h0e000001),
    .aximm_gmac_reg_multicast_ip_mask(32'hffffff00),
    .aximm_gmac_reg_mac_enable(1'b1),
    .aximm_gmac_reg_tx_overflow_count(),
    .aximm_gmac_reg_tx_afull_count(),
    .aximm_gmac_reg_rx_overflow_count(),
    .aximm_gmac_reg_rx_almost_full_count(),
    // arp
    .ARPReadDataEnable(),
    .ARPReadData(64'h02468ace135790bd),
    .ARPReadAddress(),
    // axis data
    // Streaming data clocks 
    .axis_streaming_data_clk(axis_clk),
    .axis_streaming_data_rx_packet_length(),                           
    // Streaming data outputs to AXIS of the Yellow Blocks
    .axis_streaming_data_rx_tdata(),
    .axis_streaming_data_rx_tvalid(),
    .axis_streaming_data_rx_tready(1'b1),
    .axis_streaming_data_rx_tkeep(),
    .axis_streaming_data_rx_tlast(),
    .axis_streaming_data_rx_tuser(),
    // Data inputs from AXIS bus of the Yellow Blocks
    .axis_streaming_data_tx_destination_ip(32'hc0a80103),
    .axis_streaming_data_tx_destination_udp_port(16'h1234),
    .axis_streaming_data_tx_source_udp_port(16'h5678),
    .axis_streaming_data_tx_packet_length(PKT_LEN),                           
    .axis_streaming_data_tx_tdata(s_axis_tdata),
    .axis_streaming_data_tx_tvalid(s_axis_tvalid),
    .axis_streaming_data_tx_tuser(s_axis_tuser),
    .axis_streaming_data_tx_tkeep(s_axis_tkeep),
    .axis_streaming_data_tx_tlast(s_axis_tlast),
    .axis_streaming_data_tx_tready(s_axis_tready),
    .DataRateBackOff(1'b0), 
    // Ethernet MAC Streaming Interface                                
    // Outputs to AXIS bus MAC side 
    .axis_tx_tpriority(axis_tx_tpriority),
    .axis_tx_tdata(axis_tx_tdata),
    .axis_tx_tvalid(axis_tx_tvalid),
    .axis_tx_tready(1'b1),
    .axis_tx_tkeep(axis_tx_tkeep),
    .axis_tx_tlast(axis_tx_tlast),
    // Inputs from AXIS bus of the MAC side
    .axis_rx_tdata(0),
    .axis_rx_tvalid(0),
    .axis_rx_tuser(0),
    .axis_rx_tkeep(0),
    .axis_rx_tlast(0)
);

endmodule