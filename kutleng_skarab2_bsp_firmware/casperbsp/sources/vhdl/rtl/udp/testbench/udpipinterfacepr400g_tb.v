`timescale 1ns/1ns

module udpipinterfacepr400g_tb;

parameter PERIOD = 2;
parameter G_AXIS_DATA_WIDTH = 1024;
parameter PKT_LEN = 8192;
parameter BYTES_PER_BUS = 128;
parameter CYC = 128;

reg clk, rst;
reg mac_enable;
reg enable;
//-----------------reset & clk init-----------------
initial 
begin
    clk = 0;
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
    .axis_clk(clk),
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
    .axis_tx_tready(1'b1),
    .axis_tx_tkeep(axis_tkeep),
    .axis_tx_tlast(axis_tlast),
    .axis_tx_tuser(axis_tuser),

    .axis_rx_tdata(0),
    .axis_rx_tvalid(0),
    .axis_rx_tuser(0),
    .axis_rx_tkeep (0),
    .axis_rx_tlast(0)
);

endmodule