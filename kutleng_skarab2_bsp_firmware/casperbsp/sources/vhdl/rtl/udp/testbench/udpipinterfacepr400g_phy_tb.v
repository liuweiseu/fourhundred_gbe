`timescale 1ns/1ns

module udpipinterfacepr400g_phy_tb;

parameter PERIOD = 8;
parameter PERIOD_AXIS = 2;
parameter G_AXIS_DATA_WIDTH = 1024;
parameter PKT_LEN = 8192;
parameter BYTES_PER_BUS = 128;
parameter CYC = 128;

reg clk, rst, axis_clk;
reg mac_enable;
reg enable;
//-----------------reset & clk init-----------------
initial 
begin
    clk = 0;
    axis_clk = 0;
    rst = 1;
    mac_enable = 0;
    enable = 0;
    #10 rst = 0;
    #20 mac_enable = 1;
    #30 enable = 1;
end
//-----------------clock generation-----------------
// 100MHz clock
always #(PERIOD/2)
begin
    clk = ~clk;
end

always #(PERIOD_AXIS/2)
begin
    axis_clk =~axis_clk;
end

wire [1023:0] axis_streaming_data_tx_tdata;
wire axis_streaming_data_tx_tvalid;
wire axis_streaming_data_tx_tuser;
wire [127:0] axis_streaming_data_tx_tkeep;
wire axis_streaming_data_tx_tlast;
wire axis_streaming_data_tx_tready;

axis_data_gen #(
    .G_AXIS_DATA_WIDTH(G_AXIS_DATA_WIDTH)
) axis_data_gen_inst(
    .axis_streaming_data_clk(clk),
    .axis_streaming_rst(rst),
    .axis_data_gen_enable(enable),
    .pkt_length(PKT_LEN/BYTES_PER_BUS),
    .period(CYC),
    .axis_streaming_data_tx_tdata(axis_streaming_data_tx_tdata),
    .axis_streaming_data_tx_tvalid(axis_streaming_data_tx_tvalid),
    .axis_streaming_data_tx_tuser(axis_streaming_data_tx_tuser),
    .axis_streaming_data_tx_tkeep(axis_streaming_data_tx_tkeep),
    .axis_streaming_data_tx_tlast(axis_streaming_data_tx_tlast),
    .axis_streaming_data_tx_tready(axis_streaming_data_tx_tready)
);

wire [1023:0]axis_tdata;
wire axis_tvalid;
wire [127:0] axis_tkeep;
wire axis_tlast;
wire axis_tuser;
udpipinterfacepr400g #(
    .G_AXIS_DATA_WIDTH(G_AXIS_DATA_WIDTH)
) udpipinterfacepr400g_inst(
    .axis_clk(axis_clk),
    .aximm_clk(clk),
    .icap_clk(1'b0),
    .axis_reset(rst),
    .aximm_gmac_reg_phy_control_h(32'b0),   // input
    .aximm_gmac_reg_phy_control_l(32'b0),   // input
    .aximm_gmac_reg_mac_address(48'hffffffffffff),   // input
    .aximm_gmac_reg_local_ip_address(32'hc0a80302),  // input
    .aximm_gmac_reg_local_ip_netmask(32'hffffff00),  // input
    .aximm_gmac_reg_gateway_ip_address(32'hc0a80301), // input
    .aximm_gmac_reg_multicast_ip_address(32'h0), // input
    .aximm_gmac_reg_multicast_ip_mask(32'h0), // input
    .aximm_gmac_reg_udp_port(16'h1234), // input
    .aximm_gmac_reg_udp_port_mask(16'hffff),  // input
    .aximm_gmac_reg_mac_enable(mac_enable),   // input
    .aximm_gmac_reg_mac_promiscous_mode(1'b0),  // input
    .aximm_gmac_reg_counters_reset(1'b0),
    .aximm_gmac_reg_core_type(),
    .aximm_gmac_reg_phy_status_h(),
    .aximm_gmac_reg_phy_status_l(),
    .aximm_gmac_reg_tx_packet_rate(),
    .aximm_gmac_reg_tx_packet_count(),
    .aximm_gmac_reg_tx_valid_rate(),
    .aximm_gmac_reg_tx_valid_count(),
    .aximm_gmac_reg_tx_overflow_count(),
    .aximm_gmac_reg_tx_afull_count(),
    .aximm_gmac_reg_rx_packet_rate(),
    .aximm_gmac_reg_rx_packet_count(),
    .aximm_gmac_reg_rx_valid_rate(),
    .aximm_gmac_reg_rx_valid_count(),
    .aximm_gmac_reg_rx_overflow_count(),
    .aximm_gmac_reg_rx_almost_full_count(),
    .aximm_gmac_reg_rx_bad_packet_count(),

    .aximm_gmac_reg_arp_size(),
    .aximm_gmac_reg_tx_word_size(),
    .aximm_gmac_reg_rx_word_size(),
    .aximm_gmac_reg_tx_buffer_max_size(),
    .aximm_gmac_reg_rx_buffer_max_size(),
 
    .aximm_gmac_arp_cache_write_enable(1'b0), // input
    .aximm_gmac_arp_cache_read_enable(1'b0),    // input
    .aximm_gmac_arp_cache_write_data(0),
    .aximm_gmac_arp_cache_read_data(),
    .aximm_gmac_arp_cache_write_address(0),
    .aximm_gmac_arp_cache_read_address(0),

    .aximm_gmac_tx_data_write_enable(0),
    .aximm_gmac_tx_data_read_enable(0),
    .aximm_gmac_tx_data_write_data(8'b0),

    .aximm_gmac_tx_data_write_byte_enable(0),
    .aximm_gmac_tx_data_read_data(),

    .aximm_gmac_tx_data_read_byte_enable(),
    .aximm_gmac_tx_data_write_address(0),
    .aximm_gmac_tx_data_read_address(0),
    .aximm_gmac_tx_ringbuffer_slot_id (0),
    .aximm_gmac_tx_ringbuffer_slot_set (0),
    .aximm_gmac_tx_ringbuffer_slot_status (),
    .aximm_gmac_tx_ringbuffer_number_slots_filled(),

    .aximm_gmac_rx_data_read_enable(0),
    .aximm_gmac_rx_data_read_data (),
		
    .aximm_gmac_rx_data_read_byte_enable(),
    .aximm_gmac_rx_data_read_address(0),
    .aximm_gmac_rx_ringbuffer_slot_id (0),
    .aximm_gmac_rx_ringbuffer_slot_clear(0),
    .aximm_gmac_rx_ringbuffer_slot_status (),
    .aximm_gmac_rx_ringbuffer_number_slots_filled(),

    .axis_streaming_data_clk(clk),
    .axis_streaming_data_rx_packet_length (),

    .axis_streaming_data_rx_tdata(),
    .axis_streaming_data_rx_tvalid(),
    .axis_streaming_data_rx_tready(0),
    .axis_streaming_data_rx_tkeep(),
    .axis_streaming_data_rx_tlast(),
    .axis_streaming_data_rx_tuser(),

    .axis_streaming_data_tx_destination_ip(32'hc0a8030a),
    .axis_streaming_data_tx_destination_udp_port(16'h5678),
    .axis_streaming_data_tx_source_udp_port(16'habcd),
    .axis_streaming_data_tx_packet_length(PKT_LEN),
    .axis_streaming_data_tx_tdata(axis_streaming_data_tx_tdata),
    .axis_streaming_data_tx_tvalid(axis_streaming_data_tx_tvalid),
    .axis_streaming_data_tx_tuser(axis_streaming_data_tx_tuser),
    .axis_streaming_data_tx_tkeep(axis_streaming_data_tx_tkeep),
    .axis_streaming_data_tx_tlast(axis_streaming_data_tx_tlast),
    .axis_streaming_data_tx_tready(axis_streaming_data_tx_tready),

    .gmac_reg_core_type(0),
    .gmac_reg_phy_status_h(0),
    .gmac_reg_phy_status_l(0),
    .gmac_reg_phy_control_h(),
    .gmac_reg_phy_control_l(),
    .gmac_reg_tx_packet_rate(0),
    .gmac_reg_tx_packet_count(0),
    .gmac_reg_tx_valid_rate(0),
    .gmac_reg_tx_valid_count (0),
    .gmac_reg_rx_packet_rate(0),
    .gmac_reg_rx_packet_count(0),
    .gmac_reg_rx_valid_rate (0),
    .gmac_reg_rx_valid_count(0),
    .gmac_reg_rx_bad_packet_count (0),
    .gmac_reg_counters_reset(),
    .gmac_reg_mac_enable(),
    .DataRateBackOff (0),

    .axis_tx_tdata (axis_tdata),
    .axis_tx_tvalid (axis_tvalid),
    .axis_tx_tready(axis_tready),
    .axis_tx_tkeep(axis_tkeep),
    .axis_tx_tlast(axis_tlast),
    .axis_tx_tuser(axis_tuser),

    .axis_rx_tdata(0),
    .axis_rx_tvalid(0),
    .axis_rx_tuser(0),
    .axis_rx_tkeep (0),
    .axis_rx_tlast(0)
);

wire [1023:0] axis_tdata_fifo;
wire axis_tvalid_fifo;
wire [127:0] axis_tkeep_fifo;
wire axis_tlast_fifo;
wire axis_tuser_fifo;
wire axis_tready_fifo;

axispacketbufferfifo400g fifo_inst
(
    .s_aclk(clk),
    .s_aresetn(~rst),
    .s_axis_tvalid(axis_tvalid),
    .s_axis_tready(axis_tready),
    .s_axis_tdata(axis_tdata),
    .s_axis_tkeep(axis_tkeep),
    .s_axis_tlast(axis_tlast),
    .s_axis_tuser(axis_tuser),
    .m_axis_tvalid(axis_tvalid_fifo),
    .m_axis_tready(axis_tready_fifo),
    .m_axis_tdata(axis_tdata_fifo),
    .m_axis_tkeep(axis_tkeep_fifo),
    .m_axis_tlast(axis_tlast_fifo),
    .m_axis_tuser(axis_tuser_fifo),
    .axis_prog_full()
);

wire [1023:0] dcmac_tx_dat;
wire [7:0] dcmac_tx_ena;
wire [7:0] dcmac_tx_sop;
wire [7:0] dcmac_tx_eop;
wire [7:0] dcmac_tx_err;
wire [31:0] dcmac_tx_mty;
wire [7:0] dcmac_tx_vld;

reg casper_tx_tvalid_d1;
always @(posedge clk)
begin
  if(rst)
    casper_tx_tvalid_d1 <= 1'b0;
  else
    casper_tx_tvalid_d1 <= axis_tvalid_fifo; 
end

assign dcmac_tx_vld [0] = casper_tx_tvalid_d1;
assign dcmac_tx_vld[7:1] = 0;

lbustxaxisrx400g fhg_axis_adapter(
  .lbus_txclk(clk),
  .lbus_txreset(rst),
  // axis tx 
  .axis_rx_tdata(axis_tdata_fifo),
  .axis_rx_tvalid(axis_tvalid_fifo),
  .axis_rx_tready(axis_tready_fifo),
  .axis_rx_tkeep(axis_tkeep_fifo),
  .axis_rx_tlast(axis_tlast_fifo),
  .axis_rx_tuser(axis_tuser_fifo),
  // lbus ready
  .lbus_tx_rdyout(1'b1),
  // segment 0
  .lbus_txdataout0(dcmac_tx_dat[127:0]),
  .lbus_txenaout0(dcmac_tx_ena[0]),
  .lbus_txsopout0(dcmac_tx_sop[0]),
  .lbus_txeopout0(dcmac_tx_eop[0]),
  .lbus_txerrout0(dcmac_tx_err[0]),
  .lbus_txmtyout0(dcmac_tx_mty[3:0]),
  // segment 1
  .lbus_txdataout1(dcmac_tx_dat[255:128]),
  .lbus_txenaout1(dcmac_tx_ena[1]),
  .lbus_txsopout1(dcmac_tx_sop[1]),
  .lbus_txeopout1(dcmac_tx_eop[1]),
  .lbus_txerrout1(dcmac_tx_err[1]),
  .lbus_txmtyout1(dcmac_tx_mty[7:4]),
  // segment 2
  .lbus_txdataout2(dcmac_tx_dat[383:256]),
  .lbus_txenaout2(dcmac_tx_ena[2]),
  .lbus_txsopout2(dcmac_tx_sop[2]),
  .lbus_txeopout2(dcmac_tx_eop[2]),
  .lbus_txerrout2(dcmac_tx_err[2]),
  .lbus_txmtyout2(dcmac_tx_mty[11:8]),
  // segment 3
  .lbus_txdataout3(dcmac_tx_dat[511:384]),
  .lbus_txenaout3(dcmac_tx_ena[3]),
  .lbus_txsopout3(dcmac_tx_sop[3]),
  .lbus_txeopout3(dcmac_tx_eop[3]),
  .lbus_txerrout3(dcmac_tx_err[3]),
  .lbus_txmtyout3(dcmac_tx_mty[15:12]),
  // segment 4
  .lbus_txdataout4(dcmac_tx_dat[639:512]),
  .lbus_txenaout4(dcmac_tx_ena[4]),
  .lbus_txsopout4(dcmac_tx_sop[4]),
  .lbus_txeopout4(dcmac_tx_eop[4]),
  .lbus_txerrout4(dcmac_tx_err[4]),
  .lbus_txmtyout4(dcmac_tx_mty[19:16]),
  // segment 5
  .lbus_txdataout5(dcmac_tx_dat[767:640]),
  .lbus_txenaout5(dcmac_tx_ena[5]),
  .lbus_txsopout5(dcmac_tx_sop[5]),
  .lbus_txeopout5(dcmac_tx_eop[5]),
  .lbus_txerrout5(dcmac_tx_err[5]),
  .lbus_txmtyout5(dcmac_tx_mty[23:20]),
  // setment 6
  .lbus_txdataout6(dcmac_tx_dat[895:768]),
  .lbus_txenaout6(dcmac_tx_ena[6]),
  .lbus_txsopout6(dcmac_tx_sop[6]),
  .lbus_txeopout6(dcmac_tx_eop[6]),
  .lbus_txerrout6(dcmac_tx_err[6]),
  .lbus_txmtyout6(dcmac_tx_mty[27:24]),
  // segment 7
  .lbus_txdataout7(dcmac_tx_dat[1023:896]),
  .lbus_txenaout7(dcmac_tx_ena[7]),
  .lbus_txsopout7(dcmac_tx_sop[7]),
  .lbus_txeopout7(dcmac_tx_eop[7]),
  .lbus_txerrout7(dcmac_tx_err[7]),
  .lbus_txmtyout7(dcmac_tx_mty[31:28])
);

endmodule