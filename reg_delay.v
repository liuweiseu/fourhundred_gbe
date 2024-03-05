module reg_delay #(
    parameter D = 2
    )(
    input clk,
    input rst,
    input [31:0] axis_streaming_data_tx_destination_ip,
    input [15:0] axis_streaming_data_tx_destination_udp_port,
    input [15:0] axis_streaming_data_tx_source_udp_port,
    input [15:0] axis_streaming_data_tx_packet_length,
    input [31:0] gmac_reg_phy_control_h,
    input [31:0] gmac_reg_phy_control_l,
    input [31:0] gmac_reg_mac_address_h,
    input [31:0] gmac_reg_mac_address_l,
    input [31:0] gmac_reg_local_ip_address,
    input [31:0] gmac_reg_local_ip_netmask,
    input [31:0] gmac_reg_gateway_ip_address,
    input [31:0] gmac_reg_multicast_ip_address,
    input [31:0] gmac_reg_multicast_ip_mask,
    input [31:0] gmac_reg_udp_port,
    input [31:0] gmac_reg_core_ctrl,
    input [31:0] gmac_reg_count_reset,
    input [31:0] gmac_arp_cache_write_enable,
    input [31:0] gmac_arp_cache_read_enable,
    input [31:0] gmac_arp_cache_write_data,
    input [31:0] gmac_arp_cache_write_address,
    input [31:0] gmac_arp_cache_read_address,
    input [31:0] gmac_reg_core_type_d,
    input [31:0] gmac_reg_phy_status_h_d,
    input [31:0] gmac_reg_phy_status_l_d,
    input [31:0] gmac_reg_tx_packet_rate_d,
    input [31:0] gmac_reg_tx_packet_count_d,
    input [31:0] gmac_reg_tx_valid_rate_d,
    input [31:0] gmac_reg_tx_valid_count_d,
    input [31:0] gmac_reg_tx_overflow_count_d,
    input [31:0] gmac_reg_tx_almost_full_count_d,
    input [31:0] gmac_reg_rx_packet_rate_d,
    input [31:0] gmac_reg_rx_packet_count_d,
    input [31:0] gmac_reg_rx_valid_rate_d,
    input [31:0] gmac_reg_rx_valid_count_d,
    input [31:0] gmac_reg_rx_overflow_count_d,
    input [31:0] gmac_reg_rx_almost_full_count_d,
    input [31:0] gmac_reg_rx_bad_packet_count_d,
    input [31:0] gmac_reg_arp_size_d,
    input [31:0] gmac_reg_word_size_d,
    input [31:0] gmac_reg_buffer_max_size_d,
    input [31:0] gmac_arp_cache_read_data_d,

    output [31:0] axis_streaming_data_tx_destination_ip_d,
    output [15:0] axis_streaming_data_tx_destination_udp_port_d,
    output [15:0] axis_streaming_data_tx_source_udp_port_d,
    output [15:0] axis_streaming_data_tx_packet_length_d,
    output [31:0] gmac_reg_phy_control_h_d,
    output [31:0] gmac_reg_phy_control_l_d,
    output [31:0] gmac_reg_mac_address_h_d,
    output [31:0] gmac_reg_mac_address_l_d,
    output [31:0] gmac_reg_local_ip_address_d,
    output [31:0] gmac_reg_local_ip_netmask_d,
    output [31:0] gmac_reg_gateway_ip_address_d,
    output [31:0] gmac_reg_multicast_ip_address_d,
    output [31:0] gmac_reg_multicast_ip_mask_d,
    output [31:0] gmac_reg_udp_port_d,
    output [31:0] gmac_reg_core_ctrl_d,
    output [31:0] gmac_reg_count_reset_d,
    output [31:0] gmac_arp_cache_write_enable_d,
    output [31:0] gmac_arp_cache_read_enable_d,
    output [31:0] gmac_arp_cache_write_data_d,
    output [31:0] gmac_arp_cache_write_address_d,
    output [31:0] gmac_arp_cache_read_address_d,
    output [31:0] gmac_reg_core_type,
    output [31:0] gmac_reg_phy_status_h,
    output [31:0] gmac_reg_phy_status_l,
    output [31:0] gmac_reg_tx_packet_rate,
    output [31:0] gmac_reg_tx_packet_count,
    output [31:0] gmac_reg_tx_valid_rate,
    output [31:0] gmac_reg_tx_valid_count,
    output [31:0] gmac_reg_tx_overflow_count,
    output [31:0] gmac_reg_tx_almost_full_count,
    output [31:0] gmac_reg_rx_packet_rate,
    output [31:0] gmac_reg_rx_packet_count,
    output [31:0] gmac_reg_rx_valid_rate,
    output [31:0] gmac_reg_rx_valid_count,
    output [31:0] gmac_reg_rx_overflow_count,
    output [31:0] gmac_reg_rx_almost_full_count,
    output [31:0] gmac_reg_rx_bad_packet_count,
    output [31:0] gmac_reg_arp_size,
    output [31:0] gmac_reg_word_size,
    output [31:0] gmac_reg_buffer_max_size,
    output [31:0] gmac_arp_cache_read_data,

    // am settings
    input [15:0] ctl_port_ctl_rx_custom_vl_length_minus1,
    input [15:0] ctl_port_ctl_tx_custom_vl_length_minus1,
    input [63:0] ctl_port_ctl_tx_vl_marker_id0,
    input [63:0] ctl_port_ctl_tx_vl_marker_id1,
    input [63:0] ctl_port_ctl_tx_vl_marker_id2,
    input [63:0] ctl_port_ctl_tx_vl_marker_id3,
    input [63:0] ctl_port_ctl_tx_vl_marker_id4,
    input [63:0] ctl_port_ctl_tx_vl_marker_id5,
    input [63:0] ctl_port_ctl_tx_vl_marker_id6,
    input [63:0] ctl_port_ctl_tx_vl_marker_id7,
    input [63:0] ctl_port_ctl_tx_vl_marker_id8,
    input [63:0] ctl_port_ctl_tx_vl_marker_id9,
    input [63:0] ctl_port_ctl_tx_vl_marker_id10,
    input [63:0] ctl_port_ctl_tx_vl_marker_id11,
    input [63:0] ctl_port_ctl_tx_vl_marker_id12,
    input [63:0] ctl_port_ctl_tx_vl_marker_id13,
    input [63:0] ctl_port_ctl_tx_vl_marker_id14,
    input [63:0] ctl_port_ctl_tx_vl_marker_id15,
    input [63:0] ctl_port_ctl_tx_vl_marker_id16,
    input [63:0] ctl_port_ctl_tx_vl_marker_id17,
    input [63:0] ctl_port_ctl_tx_vl_marker_id18,
    input [63:0] ctl_port_ctl_tx_vl_marker_id19,
    output [15:0] ctl_port_ctl_rx_custom_vl_length_minus1_d,
    output [15:0] ctl_port_ctl_tx_custom_vl_length_minus1_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id0_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id1_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id2_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id3_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id4_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id5_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id6_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id7_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id8_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id9_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id10_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id11_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id12_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id13_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id14_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id15_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id16_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id17_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id18_d,
    output [63:0] ctl_port_ctl_tx_vl_marker_id19_d
);

// input
//1
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_axis_streaming_data_tx_destination_ip (
    .clk(clk),
    .rst(rst),
    .din(axis_streaming_data_tx_destination_ip),
    .dout(axis_streaming_data_tx_destination_ip_d)
);

//2
delay #(
    .D(D),
    .BITWIDTH(16)
) delay_axis_streaming_data_tx_destination_udp_port (
    .clk(clk),
    .rst(rst),
    .din(axis_streaming_data_tx_destination_udp_port),
    .dout(axis_streaming_data_tx_destination_udp_port_d)
);

//3
delay #(
    .D(D),
    .BITWIDTH(16)
) delay_axis_streaming_data_tx_source_udp_port (
    .clk(clk),
    .rst(rst),
    .din(axis_streaming_data_tx_source_udp_port),
    .dout(axis_streaming_data_tx_source_udp_port_d)
);

//4
delay #(
    .D(D),
    .BITWIDTH(16)
) delay_axis_streaming_data_tx_packet_length (
    .clk(clk),
    .rst(rst),
    .din(axis_streaming_data_tx_packet_length),
    .dout(axis_streaming_data_tx_packet_length_d)
);

//5
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_phy_control_h (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_phy_control_h),
    .dout(gmac_reg_phy_control_h_d)
);

//6
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_phy_control_l (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_phy_control_l),
    .dout(gmac_reg_phy_control_l_d)
);

//7
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_mac_address_h (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_mac_address_h),
    .dout(gmac_reg_mac_address_h_d)
);

//8
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_mac_address_l (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_mac_address_l),
    .dout(gmac_reg_mac_address_l_d)
);

//9
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_local_ip_address (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_local_ip_address),
    .dout(gmac_reg_local_ip_address_d)
);

//10
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_local_ip_netmask (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_local_ip_netmask),
    .dout(gmac_reg_local_ip_netmask_d)
);

//11
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_gateway_ip_address (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_gateway_ip_address),
    .dout(gmac_reg_gateway_ip_address_d)
);

//12
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_multicast_ip_address (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_multicast_ip_address),
    .dout(gmac_reg_multicast_ip_address_d)
);

//13
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_multicast_ip_mask (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_multicast_ip_mask),
    .dout(gmac_reg_multicast_ip_mask_d)
);

//14
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_udp_port (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_udp_port),
    .dout(gmac_reg_udp_port_d)
);

//15
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_core_ctrl (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_core_ctrl),
    .dout(gmac_reg_core_ctrl_d)
);

//16
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_count_reset (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_count_reset),
    .dout(gmac_reg_count_reset_d)
);

//17
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_arp_cache_write_enable (
    .clk(clk),
    .rst(rst),
    .din(gmac_arp_cache_write_enable),
    .dout(gmac_arp_cache_write_enable_d)
);

//18
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_arp_cache_read_enable (
    .clk(clk),
    .rst(rst),
    .din(gmac_arp_cache_read_enable),
    .dout(gmac_arp_cache_read_enable_d)
);

//19
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_arp_cache_write_data (
    .clk(clk),
    .rst(rst),
    .din(gmac_arp_cache_write_data),
    .dout(gmac_arp_cache_write_data_d)
);

//20
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_arp_cache_write_address (
    .clk(clk),
    .rst(rst),
    .din(gmac_arp_cache_write_address),
    .dout(gmac_arp_cache_write_address_d)
);

//21
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_arp_cache_read_address (
    .clk(clk),
    .rst(rst),
    .din(gmac_arp_cache_read_address),
    .dout(gmac_arp_cache_read_address_d)
);

// output
//22
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_core_type (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_core_type_d),
    .dout(gmac_reg_core_type)
);

//23
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_ (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_phy_status_h_d),
    .dout(gmac_reg_phy_status_h)
);

//24    
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_phy_status_l (
    .clk(clk),
    .rst(rst),
    .din( gmac_reg_phy_status_l_d),
    .dout( gmac_reg_phy_status_l)
);

//25
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_tx_packet_rate (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_tx_packet_rate_d),
    .dout(gmac_reg_tx_packet_rate)
);

//26
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_tx_packet_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_tx_packet_count_d),
    .dout(gmac_reg_tx_packet_count)
);

//27
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_tx_valid_rate (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_tx_valid_rate_d),
    .dout(gmac_reg_tx_valid_rate)
);

//28
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_tx_valid_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_tx_valid_count_d),
    .dout(gmac_reg_tx_valid_count)
);

//29
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_tx_overflow_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_tx_overflow_count_d),
    .dout(gmac_reg_tx_overflow_count)
);


//30
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_tx_almost_full_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_tx_almost_full_count_d),
    .dout(gmac_reg_tx_almost_full_count)
);

//31
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_rx_packet_rate (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_rx_packet_rate_d),
    .dout(gmac_reg_rx_packet_rate)
);

//32
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_rx_packet_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_rx_packet_count_d),
    .dout(gmac_reg_rx_packet_count)
);

//33
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_rx_valid_rate (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_rx_valid_rate_d),
    .dout(gmac_reg_rx_valid_rate)
);

//34
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_rx_valid_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_rx_valid_count_d),
    .dout(gmac_reg_rx_valid_count)
);

//35
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_rx_overflow_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_rx_overflow_count_d),
    .dout(gmac_reg_rx_overflow_count)
);

//36      
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_rx_almost_full_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_rx_almost_full_count_d),
    .dout(gmac_reg_rx_almost_full_count)
);

//37
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_rx_bad_packet_count (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_rx_bad_packet_count_d),
    .dout(gmac_reg_rx_bad_packet_count)
);

//38
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_arp_size (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_arp_size_d),
    .dout(gmac_reg_arp_size)
);

//39
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_word_size (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_word_size_d),
    .dout(gmac_reg_word_size)
);

//40
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_reg_buffer_max_size (
    .clk(clk),
    .rst(rst),
    .din(gmac_reg_buffer_max_size_d),
    .dout(gmac_reg_buffer_max_size)
);

//41
delay #(
    .D(D),
    .BITWIDTH(32)
) delay_gmac_arp_cache_read_data (
    .clk(clk),
    .rst(rst),
    .din(gmac_arp_cache_read_data_d),
    .dout(gmac_arp_cache_read_data)
);

// am settings
//rx
delay #(
    .D(D),
    .BITWIDTH(16)
) delay_ctl_port_ctl_rx_custom_vl_length_minus1(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_rx_custom_vl_length_minus1),
    .dout(ctl_port_ctl_rx_custom_vl_length_minus1_d)
);

//tx
delay #(
    .D(D),
    .BITWIDTH(16)
) delay_ctl_port_ctl_tx_custom_vl_length_minus1(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_custom_vl_length_minus1),
    .dout(ctl_port_ctl_tx_custom_vl_length_minus1_d)
);


//0
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id0(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id0),
    .dout(ctl_port_ctl_tx_vl_marker_id0_d)
);

//1
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id1(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id1),
    .dout(ctl_port_ctl_tx_vl_marker_id1_d)
);


//2
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id2(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id2),
    .dout(ctl_port_ctl_tx_vl_marker_id2_d)
);

//3
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id3(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id3),
    .dout(ctl_port_ctl_tx_vl_marker_id3_d)
);

//4
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id4(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id4),
    .dout(ctl_port_ctl_tx_vl_marker_id4_d)
);

//5
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id5(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id5),
    .dout(ctl_port_ctl_tx_vl_marker_id5_d)
);

//6
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id6(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id6),
    .dout(ctl_port_ctl_tx_vl_marker_id6_d)
);

//7
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id7(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id7),
    .dout(ctl_port_ctl_tx_vl_marker_id7_d)
);

//8
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id8(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id8),
    .dout(ctl_port_ctl_tx_vl_marker_id8_d)
);

//9
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id9(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id9),
    .dout(ctl_port_ctl_tx_vl_marker_id9_d)
);

//10
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id10(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id10),
    .dout(ctl_port_ctl_tx_vl_marker_id10_d)
);

//11
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id11(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id11),
    .dout(ctl_port_ctl_tx_vl_marker_id11_d)
);

//12
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id12(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id12),
    .dout(ctl_port_ctl_tx_vl_marker_id12_d)
);

//13
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id13(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id13),
    .dout(ctl_port_ctl_tx_vl_marker_id13_d)
);

//14
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id14(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id14),
    .dout(ctl_port_ctl_tx_vl_marker_id14_d)
);

//15
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id15(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id15),
    .dout(ctl_port_ctl_tx_vl_marker_id15_d)
);

//16
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id16(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id16),
    .dout(ctl_port_ctl_tx_vl_marker_id16_d)
);

//17
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id17(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id17),
    .dout(ctl_port_ctl_tx_vl_marker_id17_d)
);

//18
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id18(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id18),
    .dout(ctl_port_ctl_tx_vl_marker_id18_d)
);

//19
delay #(
    .D(D),
    .BITWIDTH(64)
) delay_ctl_port_ctl_tx_vl_marker_id19(
    .clk(clk),
    .rst(rst),
    .din(ctl_port_ctl_tx_vl_marker_id19),
    .dout(ctl_port_ctl_tx_vl_marker_id19_d)
);

endmodule