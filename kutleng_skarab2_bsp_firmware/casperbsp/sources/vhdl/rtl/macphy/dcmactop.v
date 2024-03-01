module dcmactop#(
    parameter ETH           = 400,
    parameter C_USE_RS_FEC  = 0,
    parameter C_INST_ID     = 0,
    parameter C_N_COMMON    = 2
)(
    /* Ports for connecting CASPER module*/
    // Global System Enable
    input Enable,
    input Reset,
    // Ethernet reference clock for 156.25MHz
    // it should be OSFP for 400G 
    input gt_clk0_p,
    input gt_clk0_n,
    input gt_clk1_p,
    input gt_clk1_n,
    // RX     
    input [3:0] gt0_rx_p,
    input [3:0] gt0_rx_n,
    input [3:0] gt1_rx_p,
    input [3:0] gt1_rx_n,
    // TX
    output [3:0] gt0_tx_p,
    output [3:0] gt0_tx_n,
    output [3:0] gt1_tx_p,
    output [3:0] gt1_tx_n,
    // Statistics interface
    // These registers are required for casper, not from the cmac core(100g) or dcmac core(400g),
    // so we need to implement these registers in the casper module.
    output [31:0] gmac_reg_core_type,
    output [31:0] gmac_reg_phy_status_h,
    output [31:0] gmac_reg_phy_status_l,
    input  [31:0] gmac_reg_phy_control_h,
    input  [31:0] gmac_reg_phy_control_l,
    output [31:0] gmac_reg_tx_packet_rate,
    output [31:0] gmac_reg_tx_packet_count,
    output [31:0] gmac_reg_tx_valid_rate,
    output [31:0] gmac_reg_tx_valid_count,
    output [31:0] gmac_reg_rx_packet_rate,
    output [31:0] gmac_reg_rx_packet_count,
    output [31:0] gmac_reg_rx_valid_rate,
    output [31:0] gmac_reg_rx_valid_count,
    output [31:0] gmac_reg_rx_bad_packet_count,
    input gmac_reg_counters_reset,
    // Lbus and AXIS
    input lbus_reset,
    // Overflow signal
    output lbus_tx_ovfout,
    // Underflow signal
    output lbus_tx_unfout,
    // Incoming packet filters (seemingly should be brought onto lbus_tx_clk)
    input [47:0] fabric_mac,
    input [31:0] fabric_ip,
    input [15:0] fabric_port,
    // AXIS Bus
    // RX Bus
    input axis_rx_clkin,
    input [1023:0] axis_rx_tdata,
    input axis_rx_tvalid,
    output axis_rx_tready,
    input [127:0] axis_rx_tkeep,
    input axis_rx_tlast,
    input axis_rx_tuser,
    // TX Bus
    output axis_tx_clkout,
    output [1023:0] axis_tx_tdata,
    output axis_tx_tvalid,
    output [127:0] axis_tx_tkeep,
    output axis_tx_tlast,
    // User signal for errors and dropping of packets
    output axis_tx_tuser,
    input yellow_block_user_clk,
    output [1023:0] yellow_block_rx_data,
    output yellow_block_rx_valid,
    output yellow_block_rx_eof,
    output yellow_block_rx_overrun,

    /* Ports for connecting DCMAC module */
    // axi interface
    input s_axi_aclk,
    input s_axi_aresetn,
    input [31 : 0] s_axi_awaddr,
    input s_axi_awvalid,
    output s_axi_awready,
    input [31 : 0] s_axi_wdata,
    input s_axi_wvalid,
    output s_axi_wready,
    output [1 : 0] s_axi_bresp,
    output s_axi_bvalid,
    input s_axi_bready,
    input [31 : 0] s_axi_araddr,
    input s_axi_arvalid,
    output s_axi_arready,
    output [31 : 0] s_axi_rdata,
    output [1 : 0] s_axi_rresp,
    output s_axi_rvalid,
    input s_axi_rready,
    // gt_ctl
    input gt_rxcdrhold,
    input [5:0] gt_txprecursor,
    input [5:0] gt_txpostcursor,
    input [6:0] gt_txmaincursor,
    input [2:0] gt_loopback,
    input [7:0] gt_line_rate,
    input gt_reset_all_in,
    // tx_datapath
    input [7:0] gt_reset_tx_datapath_in,
    // rx_datapath
    input [7:0] gt_reset_rx_datapath_in, 
    // reset_dyn
    input rx_core_reset,
    input [5:0] rx_serdes_reset,
    input tx_core_reset,
    input [5:0] tx_serdes_reset,
    // reset_done_dyn
    output [7:0] gt_tx_reset_done_out,
    output [7:0] gt_rx_reset_done_out
);

/*--------------------------------------------------------------------------------------*/
// TODO: implement static registers in this 400G core.
/*--------------------------------------------------------------------------------------*/
assign gmac_reg_core_type           = 32'h5a5a;
assign gmac_reg_phy_status_h        = 32'h0;
assign gmac_reg_phy_status_l        = 32'h0;
assign gmac_reg_tx_packet_rate      = 32'h0;
assign gmac_reg_tx_packet_count     = 32'h0;
assign gmac_reg_tx_valid_rate       = 32'h0;
assign gmac_reg_tx_valid_count      = 32'h0;
assign gmac_reg_rx_packet_rate      = 32'h0;
assign gmac_reg_rx_packet_count     = 32'h0;
assign gmac_reg_rx_valid_rate       = 32'h0;
assign gmac_reg_rx_valid_count      = 32'h0;
assign gmac_reg_rx_bad_packet_count = 32'h0;

/*--------------------------------------------------------------------------------------*/
// clocks for DCMAC core
/*--------------------------------------------------------------------------------------*/
wire clk_wiz_reset;
wire clk_wiz_in;
wire clk_wiz_locked;
wire core_clk;
wire axis_clk;
wire ts_clk;
assign clk_wiz_reset = 1'b0;

dcmac_0_clk_wiz_0 i_dcmac_0_clk_wiz_0 (
  .reset      (clk_wiz_reset),
  .clk_in1	  (clk_wiz_in),     // 156.25MHz
  .locked     (clk_wiz_locked),
  .clk_out1	  (core_clk),       // 782MHz
  .clk_out2   (axis_clk),       // 390.625MHz
  .clk_out3   (ts_clk)          // 350MHz
);

/*
core_clk core_clk_inst(
  .reset      (clk_wiz_reset),
  .clk_in1	  (clk_wiz_in),     // 156.25MHz
  .locked     (),
  .clk_out1   (core_clk) // 782MHz
);
*/
/*--------------------------------------------------------------------------------------*/
// axis tx clock, which is 390.625MHz 
/*--------------------------------------------------------------------------------------*/
assign axis_tx_clkout               = axis_clk;


/*--------------------------------------------------------------------------------------*/
// LBUS is not used in 400G core. 
// TODO: I may remove this port sometime.
/*--------------------------------------------------------------------------------------*/
assign lbus_tx_ovfout               = 1'b0;
assign lbus_tx_unfout               = 1'b0;
/*--------------------------------------------------------------------------------------*/
// Let's ignore RX(from DCMAC core), and just focus on TX for now.
// RX from DCMAC core is connected to TX here.
// TODO: implement logic for the yellow block interface.
/*--------------------------------------------------------------------------------------*/
assign axis_tx_tuser                = 1'b0;
assign yellow_block_rx_data         = 1024'h0;
assign yellow_block_rx_valid        = 1'b0;
assign yellow_block_rx_eof          = 1'b0;
assign yellow_block_rx_overrun      = 1'b0;

/*--------------------------------------------------------------------------------------*/
// 400G axis adapter 
// This adapter changed the standard axis itnerface(used by casper) 
// to the dcmac axis interface(lbus?).
/*--------------------------------------------------------------------------------------*/
// casper tx in
wire [1023:0] casper_tx_tdata;
wire casper_tx_tvalid;
wire [127:0]  casper_tx_tkeep;
wire casper_tx_tlast;
wire casper_tx_tuser;
wire casper_tx_tready;
// the connection is a bit wired here, because rx ports are connected to tx ports.
assign casper_tx_tdata = axis_rx_tdata;
assign casper_tx_tvalid = axis_rx_tvalid;
assign casper_tx_tkeep = axis_rx_tkeep;
assign casper_tx_tlast = axis_rx_tlast;
assign casper_tx_tuser = axis_rx_tuser;
assign axis_rx_tready = casper_tx_tready;
// casper rx out
wire [1023:0] casper_rx_tdata;
wire casper_rx_tvalid;
wire [127:0]  casper_rx_tkeep;
wire casper_rx_tlast;
wire casper_rx_tuser;
wire casper_rx_tready;
// the connection is a bit wired here, because tx ports are connected to rx ports.
assign axis_tx_tdata = casper_rx_tdata;
assign axis_tx_tvalid = casper_rx_tvalid;
assign axis_tx_tkeep = casper_rx_tkeep;
assign axis_tx_tlast = casper_rx_tlast;
assign axis_tx_tuser = casper_rx_tuser;
assign casper_rx_tready = 1'b1;
// dcmac tx in
wire [5:0] dcmac_tx_id;
wire [11:0] dcmac_tx_ena;
wire [11:0] dcmac_tx_sop;
wire [11:0] dcmac_tx_eop;
wire [11:0] dcmac_tx_err;
wire [47:0] dcmac_tx_mty;
wire [1535:0] dcmac_tx_dat;
wire [335:0] dcmac_tx_preamble;
wire [5:0] dcmac_tx_vld;
wire dcmac_tx_tuser_skip_response;
wire [5:0] dcmac_tx_tready;
wire [5:0] dcmac_tx_af;
wire dcmac_tx_ch_status_id;
// dcmac rx out
wire [2:0] dcmac_rx_id;
wire [11:0] dcmac_rx_ena;
wire [11:0] dcmac_rx_sop;
wire [11:0] dcmac_rx_eop;
wire [11:0] dcmac_rx_err;
wire [47:0] dcmac_rx_mty;
wire [1535:0] dcmac_rx_dat;
wire [335:0] dcmac_rx_preamble;
wire [5:0] dcmac_rx_vld;
// 400g adapter instance
/*
fhg_axis_adapter fhg_adapter_inst(
    .clk(axis_clk),
    .rst(Reset),
    // casper tx in
    .casper_tx_tdata(casper_tx_tdata),        // 1024 bits
    .casper_tx_tvalid(casper_tx_tvalid),   
    .casper_tx_tkeep(casper_tx_tkeep),        // 128 bits
    .casper_tx_tlast(casper_tx_tlast),
    .casper_tx_tuser(casper_tx_tuser),
    .casper_tx_tready(casper_tx_tready),      // output
    // casper rx out
    .casper_rx_tdata(casper_rx_tdata),        // 1024 bits
    .casper_rx_tvalid(casper_rx_tvalid),
    .casper_rx_tkeep(casper_rx_tkeep),        // 128 bits
    .casper_rx_tlast(casper_rx_tlast),   
    .casper_rx_tuser(casper_rx_tuser),
    .casper_rx_tready(casper_rx_tready),      // input
    // dcmac tx out
    .dcmac_tx_id(dcmac_tx_id),                // 3 bits
    .dcmac_tx_ena(dcmac_tx_ena),              // 12 bits
    .dcmac_tx_sop(dcmac_tx_sop),              // 12 bits
    .dcmac_tx_eop(dcmac_tx_eop),              // 12 bits
    .dcmac_tx_err(dcmac_tx_err),              // 12 bits
    .dcmac_tx_mty(dcmac_tx_mty),              // 48 bits
    .dcmac_tx_dat(dcmac_tx_dat),              // 1536 bits
    .dcmac_tx_preamble(dcmac_tx_preamble),    // 336 bits
    .dcmac_tx_vld(dcmac_tx_vld),              // 6 bits
    .dcmac_tx_tuser_skip_response(dcmac_tx_tuser_skip_response),
    .dcmac_tx_tready(dcmac_tx_tready),        // input 6 bits
    .dcmac_tx_af(dcmac_tx_af),                // input 6 bits
    .dcmac_tx_ch_status_id(dcmac_tx_ch_status_id), // input
    // dcmac rx in
    .dcmac_rx_id(dcmac_rx_id),                // 3 bits
    .dcmac_rx_ena(dcmac_rx_ena),              // 12 bits
    .dcmac_rx_sop(dcmac_rx_sop),              // 12 bits
    .dcmac_rx_eop(dcmac_rx_eop),              // 12 bits
    .dcmac_rx_err(dcmac_rx_err),              // 12 bits
    .dcmac_rx_mty(dcmac_rx_mty),              // 48 bits
    .dcmac_rx_dat(dcmac_rx_dat),              // 1536 bits
    .dcmac_rx_preamble(dcmac_rx_preamble),    // 336 bits
    .dcmac_rx_vld(dcmac_rx_vld)               // 6 bits
);
*/

wire lbus_tx_rdyout;
// when all of the segments are ready, then the lbus_tx_rdyout is high.
assign lbus_tx_rdyoyt = dcmac_tx_tready[0] & 
                        dcmac_tx_tready[1] & 
                        dcmac_tx_tready[2] & 
                        dcmac_tx_tready[3] & 
                        dcmac_tx_tready[4] & 
                        dcmac_tx_tready[5];
// we don't need to use the tx_id, so we can assign it to 0.
assign dcmac_tx_id = 6'b000000;
// lets set dcmac_rx_preamble[55:0] to 0x555...., other bits are 0.
assign dcmac_tx_preamble = 336'h55555555555555;

lbustxaxisrx400g fhg_axis_adapter(
  .lbus_txclk(axis_clk),
  .lbus_txreset(Reset),
  // axis tx 
  .axis_rx_tdata(casper_tx_tdata),
  .axis_rx_tvalid(casper_tx_tvalid),
  .axis_rx_tready(casper_tx_tready),
  .axis_rx_tkeep(casper_tx_tkeep),
  .axis_rx_tlast(casper_tx_tlast),
  .axis_rx_tuser(casper_tx_tuser),
  // lbus ready
  .lbus_tx_rdyout(lbus_tx_rdyoyt),
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

reg casper_tx_tvalid_d1;
always @(posedge axis_clk)
begin
  if(Reset)
    casper_tx_tvalid_d1 <= 1'b0;
  else
    casper_tx_tvalid_d1 <= casper_tx_tvalid; 
end

// segment 8-11 are not used
assign dcmac_tx_dat[1535:1024] = 512'h0;
assign dcmac_tx_ena[11:8] = 4'h0;
assign dcmac_tx_sop[11:8] = 4'h0;
assign dcmac_tx_eop[11:8] = 4'h0;
assign dcmac_tx_err[11:8] = 4'h0;
assign dcmac_tx_mty[47:32] = 16'h0;
assign dcmac_tx_vld [0] = casper_tx_tvalid_d1;
assign dcmac_tx_vld[5:1] = 5'h0;
assign dcmac_tx_vld[5:1] = 5'h0;

/*--------------------------------------------------------------------------------------*/
// DCMAC core signales 
/*--------------------------------------------------------------------------------------*/
// Wires with static values for DCMAC core
// TODO: check if these values are correct
wire [15:0] default_vl_length_100GE     = 16'd255;
wire [15:0] default_vl_length_200GE_or_400GE = 16'd256;
wire [63:0] ctl_tx_vl_marker_id0_100ge  = 64'hc16821003e97de00;
wire [63:0] ctl_tx_vl_marker_id1_100ge  = 64'h9d718e00628e7100;
wire [63:0] ctl_tx_vl_marker_id2_100ge  = 64'h594be800a6b41700;
wire [63:0] ctl_tx_vl_marker_id3_100ge  = 64'h4d957b00b26a8400;
wire [63:0] ctl_tx_vl_marker_id4_100ge  = 64'hf50709000af8f600;
wire [63:0] ctl_tx_vl_marker_id5_100ge  = 64'hdd14c20022eb3d00;
wire [63:0] ctl_tx_vl_marker_id6_100ge  = 64'h9a4a260065b5d900;
wire [63:0] ctl_tx_vl_marker_id7_100ge  = 64'h7b45660084ba9900;
wire [63:0] ctl_tx_vl_marker_id8_100ge  = 64'ha02476005fdb8900;
wire [63:0] ctl_tx_vl_marker_id9_100ge  = 64'h68c9fb0097360400;
wire [63:0] ctl_tx_vl_marker_id10_100ge = 64'hfd6c990002936600;
wire [63:0] ctl_tx_vl_marker_id11_100ge = 64'hb9915500466eaa00;
wire [63:0] ctl_tx_vl_marker_id12_100ge = 64'h5cb9b200a3464d00;
wire [63:0] ctl_tx_vl_marker_id13_100ge = 64'h1af8bd00e5074200;
wire [63:0] ctl_tx_vl_marker_id14_100ge = 64'h83c7ca007c383500;
wire [63:0] ctl_tx_vl_marker_id15_100ge = 64'h3536cd00cac93200;
wire [63:0] ctl_tx_vl_marker_id16_100ge = 64'hc4314c003bceb300;
wire [63:0] ctl_tx_vl_marker_id17_100ge = 64'hadd6b70052294800;
wire [63:0] ctl_tx_vl_marker_id18_100ge = 64'h5f662a00a099d500;
wire [63:0] ctl_tx_vl_marker_id19_100ge = 64'hc0f0e5003f0f1a00;
// DCMAC core control wires
wire  [31:0]   sw_reg_gt_line_rate;
assign sw_reg_gt_line_rate = {gt_line_rate,gt_line_rate,gt_line_rate,gt_line_rate};
// tx datapath wires
wire gt_reset_rx_datapath_in_0;
wire gt_reset_rx_datapath_in_1;
wire gt_reset_rx_datapath_in_2;
wire gt_reset_rx_datapath_in_3;
wire gt_reset_rx_datapath_in_4;
wire gt_reset_rx_datapath_in_5;
wire gt_reset_rx_datapath_in_6;
wire gt_reset_rx_datapath_in_7;
assign gt_reset_rx_datapath_in_0 = gt_reset_rx_datapath_in[0];
assign gt_reset_rx_datapath_in_1 = gt_reset_rx_datapath_in[1];
assign gt_reset_rx_datapath_in_2 = gt_reset_rx_datapath_in[2];
assign gt_reset_rx_datapath_in_3 = gt_reset_rx_datapath_in[3];
assign gt_reset_rx_datapath_in_4 = gt_reset_rx_datapath_in[4];
assign gt_reset_rx_datapath_in_5 = gt_reset_rx_datapath_in[5];
assign gt_reset_rx_datapath_in_6 = gt_reset_rx_datapath_in[6];
assign gt_reset_rx_datapath_in_7 = gt_reset_rx_datapath_in[7];
// rx datapath wires
wire gt_reset_tx_datapath_in_0;
wire gt_reset_tx_datapath_in_1;
wire gt_reset_tx_datapath_in_2;
wire gt_reset_tx_datapath_in_3;
wire gt_reset_tx_datapath_in_4;
wire gt_reset_tx_datapath_in_5;
wire gt_reset_tx_datapath_in_6;
wire gt_reset_tx_datapath_in_7;
assign gt_reset_tx_datapath_in_0 = gt_reset_tx_datapath_in[0];
assign gt_reset_tx_datapath_in_1 = gt_reset_tx_datapath_in[1];
assign gt_reset_tx_datapath_in_2 = gt_reset_tx_datapath_in[2];
assign gt_reset_tx_datapath_in_3 = gt_reset_tx_datapath_in[3];
assign gt_reset_tx_datapath_in_4 = gt_reset_tx_datapath_in[4];
assign gt_reset_tx_datapath_in_5 = gt_reset_tx_datapath_in[5];
assign gt_reset_tx_datapath_in_6 = gt_reset_tx_datapath_in[6];
assign gt_reset_tx_datapath_in_7 = gt_reset_tx_datapath_in[7];
// gt powergood wire
wire gtpowergood_0;
wire gtpowergood_1;
wire gtpowergood;
assign gtpowergood = gtpowergood_0;
// pm tick core
wire [5:0] pm_tick_core;
assign pm_tick_core = 6'd0;
// clks
wire gt0_tx_usrclk_0, gt0_tx_usrclk2_0;
wire gt0_rx_usrclk_0, gt0_rx_usrclk2_0;
wire [5:0] rx_alt_serdes_clk;
wire [5:0] tx_alt_serdes_clk;
wire [5:0] tx_serdes_clk;
wire [5:0] rx_serdes_clk;
assign rx_alt_serdes_clk = {1'b0,1'b0,gt0_rx_usrclk2_0,gt0_rx_usrclk2_0,gt0_rx_usrclk2_0,gt0_rx_usrclk2_0};
assign tx_alt_serdes_clk = {1'b0,1'b0,gt0_tx_usrclk2_0,gt0_tx_usrclk2_0,gt0_tx_usrclk2_0,gt0_tx_usrclk2_0};
assign rx_serdes_clk     = {1'b0,1'b0,gt0_rx_usrclk_0,gt0_rx_usrclk_0,gt0_rx_usrclk_0,gt0_rx_usrclk_0}; 
assign tx_serdes_clk     = {1'b0,1'b0,gt0_tx_usrclk_0,gt0_tx_usrclk_0,gt0_tx_usrclk_0,gt0_tx_usrclk_0};
wire tx_core_clk;
wire rx_core_clk;
assign tx_core_clk = core_clk;
assign rx_core_clk = core_clk;
wire clk_tx_axi;
wire clk_rx_axi;
assign clk_tx_axi = axis_clk;
assign clk_rx_axi = axis_clk;
wire [5:0] rx_flexif_clk;
wire [5:0] tx_flexif_clk;
assign rx_flexif_clk = {6{axis_clk}};
assign tx_flexif_clk = {6{axis_clk}};
wire rx_macif_clk;
wire tx_macif_clk;
assign rx_macif_clk = axis_clk;
assign tx_macif_clk = axis_clk;

//TODO: what to do with the tx_axis_ch_status_id and tx_axis_tuser_skip_response?
wire [5:0] tx_axis_ch_status_id;
wire tx_axis_tuser_skip_response;
//TODO: what to do with the following signals?
wire [55:0] tx_tsmac_tdm_stats_data;
wire [5:0] tx_tsmac_tdm_stats_id;
wire tx_tsmac_tdm_stats_valid;
wire [78:0] rx_tsmac_tdm_stats_data;
wire [5:0] rx_tsmac_tdm_stats_id;
wire rx_tsmac_tdm_stats_valid;
// ports not important
wire [5:0] dcmac_tx_serdes_is_am;
wire [5:0] dcmac_tx_serdes_is_am_prefifo;

// dcmac wrapper
dcmac_0_exdes_support_wrapper i_dcmac_0_exdes_support_wrapper
  (
  .CLK_IN_D_0_clk_n(gt_clk0_n),       // input-[0:0]-gt -- ok
  .CLK_IN_D_0_clk_p(gt_clk0_p),       // input-[0:0]-gt -- ok
  .CLK_IN_D_1_clk_n(gt_clk1_n),       // input-[0:0]-gt -- ok
  .CLK_IN_D_1_clk_p(gt_clk1_p),       // input-[0:0]-gt -- ok
  .GT_Serial_grx_n(gt0_rx_n),         // input-[3:0]-gt -- ok
  .GT_Serial_grx_p(gt0_rx_p),         // input-[3:0]-gt -- ok
  .GT_Serial_gtx_n(gt0_tx_n),         // output-[3:0]-gt -- ok
  .GT_Serial_gtx_p(gt0_tx_p),         // output-[3:0]-gt -- ok
  .GT_Serial_1_grx_n(gt1_rx_n),       // input-[3:0]-gt -- ok
  .GT_Serial_1_grx_p(gt1_rx_p),       // input-[3:0]-gt -- ok
  .GT_Serial_1_gtx_n(gt1_tx_n),       // output-[3:0]-gt -- ok
  .GT_Serial_1_gtx_p(gt1_tx_p),       // output-[3:0]-gt -- ok
  .IBUFDS_ODIV2(clk_wiz_in),          // output-[0:0]-gt-156.25MHz,  -- ok
                                      // which is connected to clk_wiz, generating core_clk(782MHz), axis_clk(390.625MHz) and ts_clk(350MHz)
  .gt_rxcdrhold(gt_rxcdrhold),        // input-[0:0]-gt--port: gt_ctl(0xA413_0000)-[31:31] -- ok
  .gt_txprecursor(gt_txprecursor),    // input-[5:0]-gt--port: gt_ctl(0xA413_0000)-[17:12] -- ok
  .gt_txpostcursor(gt_txpostcursor),  // input-[5:0]-gt--port: gt_ctl(0xA413_0000)-[23:18] -- ok
  .gt_txmaincursor(gt_txmaincursor),  // input-[6:0]-gt--port: gt_ctl(0xA413_0000)-[30:24] -- ok
  .ch0_loopback_0(gt_loopback),       // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9]  -- ok
  .ch0_loopback_1(gt_loopback),       // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9]  -- ok
  .ch0_rxrate_0(sw_reg_gt_line_rate[7:0]),   // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1] -- ok
  .ch0_rxrate_1(sw_reg_gt_line_rate[7:0]),   // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1] -- ok
  .ch0_txrate_0(sw_reg_gt_line_rate[7:0]),   // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1] -- ok
  .ch0_txrate_1(sw_reg_gt_line_rate[7:0]),   // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1] -- ok
  .ch0_tx_usr_clk2_0(gt0_tx_usrclk2_0),      // output-[0:0]-gt--connected to tx_alt_serdes_clk -- ok
  .ch0_tx_usr_clk_0(gt0_tx_usrclk_0),        // output-[0:0]-gt--connected to tx_serdes_clk -- ok
  .ch0_rx_usr_clk2_0(gt0_rx_usrclk2_0),      // output-[0:0]-gt--connected to rx_alt_serdes_clk -- ok
  .ch0_rx_usr_clk_0(gt0_rx_usrclk_0),        // output-[0:0]-gt--connected to rx_serdes_clk -- ok
  .ch1_loopback_0(gt_loopback),              // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9] -- ok
  .ch1_loopback_1(gt_loopback),              // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9] -- ok
  .ch1_rxrate_0(sw_reg_gt_line_rate[15:8]),  // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch1_rxrate_1(sw_reg_gt_line_rate[15:8]),  // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch1_txrate_0(sw_reg_gt_line_rate[15:8]),  // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch1_txrate_1(sw_reg_gt_line_rate[15:8]),  // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch2_loopback_0(gt_loopback),              // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9] -- ok
  .ch2_loopback_1(gt_loopback),              // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9] -- ok
  .ch2_rxrate_0(sw_reg_gt_line_rate[23:16]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch2_rxrate_1(sw_reg_gt_line_rate[23:16]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch2_txrate_0(sw_reg_gt_line_rate[23:16]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch2_txrate_1(sw_reg_gt_line_rate[23:16]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch3_loopback_0(gt_loopback),              // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9] -- ok
  .ch3_loopback_1(gt_loopback),              // input-[2:0]-gt--port: gt_ctl(0xA413_0000)-[11:9] -- ok
  .ch3_rxrate_0(sw_reg_gt_line_rate[31:24]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch3_rxrate_1(sw_reg_gt_line_rate[31:24]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch3_txrate_0(sw_reg_gt_line_rate[31:24]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .ch3_txrate_1(sw_reg_gt_line_rate[31:24]), // input-[7:0]-gt--port: gt_ctl(0xA413_0000)-[8:1]  -- ok
  .gtpowergood_0(gtpowergood_0),             // output-[0:0]-gt--connected to gtpowergood -- ok
  .gtpowergood_1(gtpowergood_1),             // output-[0:0]-gt--dont't care -- ok
  .ctl_port_ctl_rx_custom_vl_length_minus1(default_vl_length_200GE_or_400GE), // input-fixed-256-[15:0]-dcmac -- ok
  .ctl_port_ctl_tx_custom_vl_length_minus1(default_vl_length_200GE_or_400GE), // input-fixed-256-[15:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id0(ctl_tx_vl_marker_id0_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id1(ctl_tx_vl_marker_id1_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id2(ctl_tx_vl_marker_id2_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id3(ctl_tx_vl_marker_id3_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id4(ctl_tx_vl_marker_id4_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id5(ctl_tx_vl_marker_id5_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id6(ctl_tx_vl_marker_id6_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id7(ctl_tx_vl_marker_id7_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id8(ctl_tx_vl_marker_id8_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id9(ctl_tx_vl_marker_id9_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id10(ctl_tx_vl_marker_id10_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id11(ctl_tx_vl_marker_id11_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id12(ctl_tx_vl_marker_id12_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id13(ctl_tx_vl_marker_id13_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id14(ctl_tx_vl_marker_id14_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id15(ctl_tx_vl_marker_id15_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id16(ctl_tx_vl_marker_id16_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id17(ctl_tx_vl_marker_id17_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id18(ctl_tx_vl_marker_id18_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_port_ctl_vl_marker_id19(ctl_tx_vl_marker_id19_100ge), // input-fixed-[63:0]-dcmac -- ok
  .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override(1'b0),      // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override_value(8'd0),// input-fixed-0-[7:0]-dcmac -- ok
  .ctl_txrx_port0_ctl_tx_send_idle_in(1'b0),                 // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port0_ctl_tx_send_lfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port0_ctl_tx_send_rfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override(1'b0),      // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override_value(8'd0),// input-fixed-0-[7:0]-dcmac -- ok
  .ctl_txrx_port1_ctl_tx_send_idle_in(1'b0),                 // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port1_ctl_tx_send_lfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port1_ctl_tx_send_rfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override(1'b0),      // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override_value(8'd0),// input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port2_ctl_tx_send_idle_in(1'b0),                 // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port2_ctl_tx_send_lfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port2_ctl_tx_send_rfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override(1'b0),      // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override_value(8'd0),// input-fixed-0-[7:0]-dcmac -- ok
  .ctl_txrx_port3_ctl_tx_send_idle_in(1'b0),                 // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port3_ctl_tx_send_lfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port3_ctl_tx_send_rfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override(1'b0),      // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override_value(8'd0),// input-fixed-0-[7:0]-dcmac -- ok
  .ctl_txrx_port4_ctl_tx_send_idle_in(1'b0),                 // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port4_ctl_tx_send_lfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port4_ctl_tx_send_rfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override(1'b0),      // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override_value(8'd0),// input-fixed-0-[7:0]-dcmac -- ok
  .ctl_txrx_port5_ctl_tx_send_idle_in(1'b0),                 // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port5_ctl_tx_send_lfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .ctl_txrx_port5_ctl_tx_send_rfi_in(1'b0),                  // input-fixed-0-[0:0]-dcmac -- ok
  .gt_reset_all_in(gt_reset_all_in),                         // input-[0:0]-dcmac--port: gt_ctl(0xA413_0000)-[0:0] -- ok
  .gpo(gt_gpo),                                              // output-[31:0]-gt--don't care
  .gt_reset_tx_datapath_in_0(gt_reset_tx_datapath_in_0),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[0:0] -- ok
  .gt_reset_rx_datapath_in_0(gt_reset_rx_datapath_in_0),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[0:0] -- ok
  .gt_tx_reset_done_out_0(gt_tx_reset_done_out[0]),          // output-[0:0]-dcmac--connected to dcmac_0_syncer_reset, which generates rstn_tx_axi
                                                             //                   --port: reset_done_dyn(0xA414_0000)-gpio0[0:0]  -- ok                   
  .gt_rx_reset_done_out_0(gt_rx_reset_done_out[0]),          // output-[0:0]-dcmac--connected to dcmac_0_syncer_reset, which generates rstn_rx_axi
                                                             //                   --port: reset_done_dyn(0xA414_0000)-gpio1[0:0]  -- ok
  .gt_reset_tx_datapath_in_1(gt_reset_tx_datapath_in_1),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[1:1] -- ok
  .gt_reset_rx_datapath_in_1(gt_reset_rx_datapath_in_1),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[1:1] -- ok
  .gt_tx_reset_done_out_1(gt_tx_reset_done_out[1]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio0[1:1] -- ok
  .gt_rx_reset_done_out_1(gt_rx_reset_done_out[1]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio1[1:1] -- ok
  .gt_reset_tx_datapath_in_2(gt_reset_tx_datapath_in_2),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[2:2] -- ok
  .gt_reset_rx_datapath_in_2(gt_reset_rx_datapath_in_2),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[2:2] -- ok
  .gt_tx_reset_done_out_2(gt_tx_reset_done_out[2]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio0[2:2] -- ok
  .gt_rx_reset_done_out_2(gt_rx_reset_done_out[2]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio1[2:2] -- ok
  .gt_reset_tx_datapath_in_3(gt_reset_tx_datapath_in_3),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[3:3] -- ok
  .gt_reset_rx_datapath_in_3(gt_reset_rx_datapath_in_3),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[3:3] -- ok
  .gt_tx_reset_done_out_3(gt_tx_reset_done_out[3]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio0[3:3] -- ok
  .gt_rx_reset_done_out_3(gt_rx_reset_done_out[3]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio1[3:3] -- ok
  .gt_reset_tx_datapath_in_4(gt_reset_tx_datapath_in_4),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[4:4] -- ok
  .gt_reset_rx_datapath_in_4(gt_reset_rx_datapath_in_4),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[4:4] -- ok
  .gt_tx_reset_done_out_4(gt_tx_reset_done_out[4]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio0[4:4] -- ok
  .gt_rx_reset_done_out_4(gt_rx_reset_done_out[4]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio1[4:4] -- ok
  .gt_reset_tx_datapath_in_5(gt_reset_tx_datapath_in_5),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[5:5] -- ok
  .gt_reset_rx_datapath_in_5(gt_reset_rx_datapath_in_5),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[5:5] -- ok
  .gt_tx_reset_done_out_5(gt_tx_reset_done_out[5]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio0[5:5] -- ok
  .gt_rx_reset_done_out_5(gt_rx_reset_done_out[5]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio1[5:5] -- ok
  .gt_reset_tx_datapath_in_6(gt_reset_tx_datapath_in_6),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[6:6] -- ok
  .gt_reset_rx_datapath_in_6(gt_reset_rx_datapath_in_6),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[6:6] -- ok
  .gt_tx_reset_done_out_6(gt_tx_reset_done_out[6]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio0[6:6] -- ok
  .gt_rx_reset_done_out_6(gt_rx_reset_done_out[6]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio1[6:6] -- ok
  .gt_reset_tx_datapath_in_7(gt_reset_tx_datapath_in_7),     // input-[0:0]-dcmac--port: tx_datapath(0xA414_0000)-[7:7] -- ok
  .gt_reset_rx_datapath_in_7(gt_reset_rx_datapath_in_7),     // input-[0:0]-dcmac--port: rx_datapath(0xA415_0000)-[7:7] -- ok
  .gt_tx_reset_done_out_7(gt_tx_reset_done_out[7]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio0[7:7] -- ok
  .gt_rx_reset_done_out_7(gt_rx_reset_done_out[7]),          // output-[0:0]-dcmac--port: reset_done_dyn(0xA414_0000)-gpio1[7:7] -- ok
  .gtpowergood_in(gtpowergood),                              // input-[0:0]-dcmac--connected from gtpowergood_in_0 -- ok
  .ctl_rsvd_in(120'd0),                                      // input-fixed-0-[119:0]-dcmac -- ok
  .rsvd_in_rx_mac(8'd0),                                     // input-fixed-0-[7:0]-dcmac -- ok
  .rsvd_in_rx_phy(8'd0),                                     // input-fixed-0-[7:0]-dcmac -- ok
  .rx_all_channel_mac_pm_tick(1'b0),                         // input-fixed-0-[0:0]-dcmac -- ok
  .rx_alt_serdes_clk(rx_alt_serdes_clk),                     // input-[5:0]-dcmac--connected from gt0_rx_usrclk2_0 -- ok
  .rx_axi_clk(clk_rx_axi),                                   // axi-stream-rx--connected from axis_clk, which is 390.625MHz -- ok
  .rx_axis_tdata0(dcmac_rx_dat[127:0]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata1(dcmac_rx_dat[255:128]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata2(dcmac_rx_dat[383:256]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata3(dcmac_rx_dat[511:384]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata4(dcmac_rx_dat[639:512]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata5(dcmac_rx_dat[767:640]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata6(dcmac_rx_dat[895:768]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata7(dcmac_rx_dat[1023:896]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata8(dcmac_rx_dat[1151:1024]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata9(dcmac_rx_dat[1279:1152]),                       // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata10(dcmac_rx_dat[1407:1280]),                     // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tdata11(dcmac_rx_dat[1535:1408]),                     // axi-stream-rx-output-[127:0]-dcmac -- ok
  .rx_axis_tid(dcmac_rx_id),                              // axi-stream-rx-output-[5:0]-dcmac -- ok
  .rx_axis_tuser_ena0(dcmac_rx_ena[0]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena1(dcmac_rx_ena[1]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena2(dcmac_rx_ena[2]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena3(dcmac_rx_ena[3]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena4(dcmac_rx_ena[4]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena5(dcmac_rx_ena[5]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena6(dcmac_rx_ena[6]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena7(dcmac_rx_ena[7]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena8(dcmac_rx_ena[8]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena9(dcmac_rx_ena[9]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena10(dcmac_rx_ena[10]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_ena11(dcmac_rx_ena[11]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop0(dcmac_rx_eop[0]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop1(dcmac_rx_eop[1]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop2(dcmac_rx_eop[2]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop3(dcmac_rx_eop[3]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop4(dcmac_rx_eop[4]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop5(dcmac_rx_eop[5]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop6(dcmac_rx_eop[6]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop7(dcmac_rx_eop[7]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop8(dcmac_rx_eop[8]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop9(dcmac_rx_eop[9]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop10(dcmac_rx_eop[10]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_eop11(dcmac_rx_eop[11]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err0(dcmac_rx_err[0]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err1(dcmac_rx_err[1]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err2(dcmac_rx_err[2]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err3(dcmac_rx_err[3]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err4(dcmac_rx_err[4]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err5(dcmac_rx_err[5]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err6(dcmac_rx_err[6]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err7(dcmac_rx_err[7]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err8(dcmac_rx_err[8]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err9(dcmac_rx_err[9]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err10(dcmac_rx_err[10]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_err11(dcmac_rx_err[11]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_mty0(dcmac_rx_mty[3:0]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty1(dcmac_rx_mty[7:4]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty2(dcmac_rx_mty[11:8]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty3(dcmac_rx_mty[15:12]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty4(dcmac_rx_mty[19:16]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty5(dcmac_rx_mty[23:20]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty6(dcmac_rx_mty[27:24]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty7(dcmac_rx_mty[31:28]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty8(dcmac_rx_mty[35:32]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty9(dcmac_rx_mty[39:36]),                   // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty10(dcmac_rx_mty[43:40]),                 // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_mty11(dcmac_rx_mty[47:44]),                 // axi-stream-rx-output-[3:0]-dcmac -- ok
  .rx_axis_tuser_sop0(dcmac_rx_sop[0]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop1(dcmac_rx_sop[1]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop2(dcmac_rx_sop[2]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop3(dcmac_rx_sop[3]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop4(dcmac_rx_sop[4]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop5(dcmac_rx_sop[5]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop6(dcmac_rx_sop[6]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop7(dcmac_rx_sop[7]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop8(dcmac_rx_sop[8]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop9(dcmac_rx_sop[9]),                   // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop10(dcmac_rx_sop[10]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tuser_sop11(dcmac_rx_sop[11]),                 // axi-stream-rx-output-dcmac -- ok
  .rx_axis_tvalid_0(dcmac_rx_vld[0]),                     // axi-stream-rx-output-dcmac -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_axis_tvalid_1(dcmac_rx_vld[1]),                     // axi-stream-rx-output-dcmac -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_axis_tvalid_2(dcmac_rx_vld[2]),                     // axi-stream-rx-output-dcmac -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_axis_tvalid_3(dcmac_rx_vld[3]),                     // axi-stream-rx-output-dcmac -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_axis_tvalid_4(dcmac_rx_vld[4]),                     // axi-stream-rx-output-dcmac -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_axis_tvalid_5(dcmac_rx_vld[5]),                     // axi-stream-rx-output-dcmac -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_channel_flush(6'd0),                          // input-fixed-0-[5:0]-dcmac -- ok
  .rx_core_clk(rx_core_clk),                        // input-[0:0]-dcmac--connected to core_clk, which is 782MHz -- ok
  .rx_core_reset(rx_core_reset),                    // input-[0:0]-dcmac--port: reset_dyn(0xA417_0000)-[1:1] -- ok
  .rx_flexif_clk(rx_flexif_clk),                    // input-[5:0]-dcmac--connected to axi_clk, which is 390.625MHz -- ok
  .rx_lane_aligner_fill(),                          // output-[6:0]-dcmac -- ok
  .rx_lane_aligner_fill_start(),                    // output-[0:0]-dcmac -- ok
  .rx_lane_aligner_fill_valid(),                    // output-[0:0]-dcmac -- ok
  .rx_macif_clk(rx_macif_clk),                      // input-[0:0]-dcmac--connected to axi_clk, which is 390.625MHz -- ok
  .rx_pcs_tdm_stats_data(),                         // output-[43:0]-dcmac -- ok
  .rx_pcs_tdm_stats_start(),                        // output-[0:0]-dcmac -- ok
  .rx_pcs_tdm_stats_valid(),                        // output-[0:0]-dcmac -- ok
  .rx_port_pm_rdy(),                                // output[5:0]-dcmac -- ok
  .rx_preambleout_0(dcmac_rx_preamble[55:0]),       // output-[55:0]-dcmac--connected to gearbox_rx module -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_preambleout_1(dcmac_rx_preamble[111:56]),       // output-[55:0]-dcmac--connected to gearbox_rx module -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_preambleout_2(dcmac_rx_preamble[167:112]),       // output-[55:0]-dcmac--connected to gearbox_rx module -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_preambleout_3(dcmac_rx_preamble[223:168]),       // output-[55:0]-dcmac--connected to gearbox_rx module -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_preambleout_4(dcmac_rx_preamble[279:224]),       // output-[55:0]-dcmac--connected to gearbox_rx module -- wired, not used -- packed into rx_axis_tvalid -- ok
  .rx_preambleout_5(dcmac_rx_preamble[335:280]),       // output-[55:0]-dcmac--connected to gearbox_rx module -- wired, not used -- packed into rx_axis_tvalid -- ok
  
  .rx_serdes_albuf_restart_0(),                     // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_restart_1(),                     // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_restart_2(),                     // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_restart_3(),                     // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_restart_4(),                     // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_restart_5(),                     // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_0(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_1(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_2(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_3(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_4(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_5(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_6(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_7(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_8(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_9(),                        // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_10(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_11(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_12(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_13(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_14(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_15(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_16(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_17(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_18(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_19(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_20(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_21(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_22(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_albuf_slip_23(),                       // output-[0:0]-dcmac -- ok
  .rx_serdes_clk(rx_serdes_clk),                    // input-[5:0]-dcmac--connected from rx_usrclk_0 -- ok
  .rx_serdes_fifo_flagin_0(1'b0),                   // input-[0:0]-fixed-0-dcmac -- ok    
  .rx_serdes_fifo_flagin_1(1'b0),                   // input-[0:0]-fixed-0-dcmac -- ok
  .rx_serdes_fifo_flagin_2(1'b0),                   // input-[0:0]-fixed-0-dcmac -- ok
  .rx_serdes_fifo_flagin_3(1'b0),                   // input-[0:0]-fixed-0-dcmac -- ok
  .rx_serdes_fifo_flagin_4(1'b0),                   // input-[0:0]-fixed-0-dcmac -- ok
  .rx_serdes_fifo_flagin_5(1'b0),                   // input-[0:0]-fixed-0-dcmac -- ok
  .rx_serdes_fifo_flagout_0(),                      // output-[0:0]-dcmac -- ok
  .rx_serdes_fifo_flagout_1(),                      // output-[0:0]-dcmac -- ok
  .rx_serdes_fifo_flagout_2(),                      // output-[0:0]-dcmac -- ok
  .rx_serdes_fifo_flagout_3(),                      // output-[0:0]-dcmac -- ok
  .rx_serdes_fifo_flagout_4(),                      // output-[0:0]-dcmac -- ok
  .rx_serdes_fifo_flagout_5(),                      // output-[0:0]-dcmac -- ok
  .rx_serdes_reset(rx_serdes_reset),                // input-[5:0]-dcmac--port: reset_dyn(0xA417_0000)-[13:8] -- ok
  .rx_tsmac_tdm_stats_data(rx_tsmac_tdm_stats_data),   // output-[78:0]-dcmac--connected to rx_stats_cnt module -- wired, not used
  .rx_tsmac_tdm_stats_id(rx_tsmac_tdm_stats_id),       // output-[5:0]-dcmac--connected to rx_stats_cnt module -- wired, not used
  .rx_tsmac_tdm_stats_valid(rx_tsmac_tdm_stats_valid), // output-[0:0]-dcmac--connected to rx_stats_cnt module  -- wired, not used

  //// GT APB3 ports // axi-interface-dcmac
  .apb3clk_quad(s_axi_aclk),      // -- ok                           
  .s_axi_araddr(s_axi_araddr),    // -- ok
  .s_axi_arready(s_axi_arready),  // -- ok
  .s_axi_arvalid(s_axi_arvalid),  // -- ok
  .s_axi_awaddr(s_axi_awaddr),    // -- ok
  .s_axi_awready(s_axi_awready),  // -- ok
  .s_axi_awvalid(s_axi_awvalid),  // -- ok
  .s_axi_bready(s_axi_bready),    // -- ok
  .s_axi_bresp(s_axi_bresp),      // -- ok
  .s_axi_bvalid(s_axi_bvalid),    // -- ok
  .s_axi_rdata(s_axi_rdata),      // -- ok
  .s_axi_rready(s_axi_rready),    // -- ok
  .s_axi_rresp(s_axi_rresp),      // -- ok
  .s_axi_rvalid(s_axi_rvalid),    // -- ok
  .s_axi_wdata(s_axi_wdata),      // -- ok
  .s_axi_wready(s_axi_wready),    // -- ok
  .s_axi_wvalid(s_axi_wvalid),    // -- ok
  .s_axi_aclk(s_axi_aclk),        // -- ok
  .s_axi_aresetn(s_axi_aresetn),  // -- ok
  .ts_clk({6{ts_clk}}),                                           // input-[5:0]-dcmac--connected from ts_clk, which is 350MHz -- ok
  .tx_all_channel_mac_pm_rdy(),                                   // output-[0:0]-dcmac -- ok
  .tx_all_channel_mac_pm_tick(1'b0),                              // input-fixed-0-[0:0]-dcmac -- ok
  .tx_alt_serdes_clk(tx_alt_serdes_clk),                          // input-[5:0]-dcmac--connected from tx_usrclk2_0 -- ok
  .tx_axi_clk(clk_tx_axi),                                        // axi-stream-tx--connected from axis_clk, which is 390.625MHz -- ok
  .tx_axis_ch_status_id(tx_axis_ch_status_id),                    // axi-stream-tx-output-[5:0]-dcmac-connected to axis_pkt_gen_ts -- wired, not used
  .tx_axis_ch_status_skip_req(tx_axis_ch_status_skip_req),        // axi-stream-tx-output-dcmac-don't care -- ok 
  .tx_axis_ch_status_vld(tx_axis_ch_status_vld),                  // axi-stream-tx-output-dcmac-don't care -- ok
  .tx_axis_id_req(tx_axis_id_req),                                // axi-stream-tx-output-[5:0]-dcmac-don't care -- ok
  .tx_axis_id_req_vld(tx_axis_id_req_vld),                        // axi-stream-tx-output-dcmac-don't care -- ok 
  .tx_axis_taf_0(dcmac_tx_af[0]),                            // axi-stream-tx-output-dcmac -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_taf_1(dcmac_tx_af[1]),                            // axi-stream-tx-output-dcmac -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_taf_2(dcmac_tx_af[2]),                            // axi-stream-tx-output-dcmac -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_taf_3(dcmac_tx_af[3]),                            // axi-stream-tx-output-dcmac -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_taf_4(dcmac_tx_af[4]),                            // axi-stream-tx-output-dcmac -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_taf_5(dcmac_tx_af[5]),                            // axi-stream-tx-output-dcmac -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_tdata0(dcmac_tx_dat[127:0]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata1(dcmac_tx_dat[255:128]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata2(dcmac_tx_dat[383:256]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata3(dcmac_tx_dat[511:384]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata4(dcmac_tx_dat[639:512]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata5(dcmac_tx_dat[767:640]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata6(dcmac_tx_dat[895:768]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata7(dcmac_tx_dat[1023:896]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata8(dcmac_tx_dat[1151:1024]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata9(dcmac_tx_dat[1279:1152]),                            // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata10(dcmac_tx_dat[1407:1280]),                          // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tdata11(dcmac_tx_dat[1535:1408]),                          // axi-stream-tx-input-[127:0]-dcmac -- ok
  .tx_axis_tid(dcmac_tx_id),                                   // axi-stream-tx-input-[5:0]-dcmac -- ok
  .tx_axis_tready_0(dcmac_tx_tready[0]),                     // axi-stream-tx-output-dcmac-connected to gearbox_tx module -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_tready_1(dcmac_tx_tready[1]),                     // axi-stream-tx-output-dcmac-connected to gearbox_tx module -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_tready_2(dcmac_tx_tready[2]),                     // axi-stream-tx-output-dcmac-connected to gearbox_tx module -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_tready_3(dcmac_tx_tready[3]),                     // axi-stream-tx-output-dcmac-connected to gearbox_tx module -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_tready_4(dcmac_tx_tready[4]),                     // axi-stream-tx-output-dcmac-connected to gearbox_tx module -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_tready_5(dcmac_tx_tready[5]),                     // axi-stream-tx-output-dcmac-connected to gearbox_tx module -- wired, not used -- packed into tx_o_axis_tready -- ok
  .tx_axis_tuser_ena0(dcmac_tx_ena[0]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena1(dcmac_tx_ena[1]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena2(dcmac_tx_ena[2]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena3(dcmac_tx_ena[3]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena4(dcmac_tx_ena[4]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena5(dcmac_tx_ena[5]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena6(dcmac_tx_ena[6]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena7(dcmac_tx_ena[7]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena8(dcmac_tx_ena[8]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena9(dcmac_tx_ena[9]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena10(dcmac_tx_ena[10]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_ena11(dcmac_tx_ena[11]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop0(dcmac_tx_eop[0]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop1(dcmac_tx_eop[1]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop2(dcmac_tx_eop[2]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop3(dcmac_tx_eop[3]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop4(dcmac_tx_eop[4]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop5(dcmac_tx_eop[5]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop6(dcmac_tx_eop[6]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop7(dcmac_tx_eop[7]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop8(dcmac_tx_eop[8]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop9(dcmac_tx_eop[9]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop10(dcmac_tx_eop[10]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_eop11(dcmac_tx_eop[11]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err0(dcmac_tx_err[0]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err1(dcmac_tx_err[1]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err2(dcmac_tx_err[2]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err3(dcmac_tx_err[3]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err4(dcmac_tx_err[4]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err5(dcmac_tx_err[5]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err6(dcmac_tx_err[6]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err7(dcmac_tx_err[7]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err8(dcmac_tx_err[8]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err9(dcmac_tx_err[9]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err10(dcmac_tx_err[10]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_err11(dcmac_tx_err[11]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_mty0(dcmac_tx_mty[3:0]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty1(dcmac_tx_mty[7:4]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty2(dcmac_tx_mty[11:8]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty3(dcmac_tx_mty[15:12]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty4(dcmac_tx_mty[19:16]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty5(dcmac_tx_mty[23:20]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty6(dcmac_tx_mty[27:24]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty7(dcmac_tx_mty[31:28]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty8(dcmac_tx_mty[35:32]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty9(dcmac_tx_mty[39:36]),                        // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty10(dcmac_tx_mty[43:40]),                      // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_mty11(dcmac_tx_mty[47:44]),                      // axi-stream-tx-input-[3:0]-dcmac -- ok
  .tx_axis_tuser_skip_response(tx_axis_tuser_skip_response),        // axi-stream-tx-input-dcmac-connected from axis_pkt_gen_ts -- wired, not used
  .tx_axis_tuser_sop0(dcmac_tx_sop[0]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop1(dcmac_tx_sop[1]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop2(dcmac_tx_sop[2]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop3(dcmac_tx_sop[3]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop4(dcmac_tx_sop[4]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop5(dcmac_tx_sop[5]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop6(dcmac_tx_sop[6]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop7(dcmac_tx_sop[7]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop8(dcmac_tx_sop[8]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop9(dcmac_tx_sop[9]),                        // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop10(dcmac_tx_sop[10]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tuser_sop11(dcmac_tx_sop[11]),                      // axi-stream-tx-input-dcmac -- ok
  .tx_axis_tvalid_0(dcmac_tx_vld[0]),                          // axi-stream-tx-input-dcmac-connected from gearbox_tx module -- wired, not used -- packed into tx_axis_tvalid -- ok
  .tx_axis_tvalid_1(dcmac_tx_vld[1]),                          // axi-stream-tx-input-dcmac-connected from gearbox_tx module -- wired, not used -- packed into tx_axis_tvalid -- ok
  .tx_axis_tvalid_2(dcmac_tx_vld[2]),                          // axi-stream-tx-input-dcmac-connected from gearbox_tx module -- wired, not used -- packed into tx_axis_tvalid -- ok
  .tx_axis_tvalid_3(dcmac_tx_vld[3]),                          // axi-stream-tx-input-dcmac-connected from gearbox_tx module -- wired, not used -- packed into tx_axis_tvalid -- ok
  .tx_axis_tvalid_4(dcmac_tx_vld[4]),                          // axi-stream-tx-input-dcmac-connected from gearbox_tx module -- wired, not used -- packed into tx_axis_tvalid -- ok
  .tx_axis_tvalid_5(dcmac_tx_vld[5]),                          // axi-stream-tx-input-dcmac-connected from gearbox_tx module -- wired, not used -- packed into tx_axis_tvalid -- ok
  .tx_channel_flush(6'd0),                                        // input-fixed-0-[5:0]-dcmac -- ok
  .tx_core_clk(tx_core_clk),                                      // input-[0:0]-dcmac--connected from core_clk, which is 782MHz -- ok
  .tx_core_reset(tx_core_reset),                                  // input-[0:0]-dcmac--port: reset_dyn(0xA417_0000)-[0:0] -- ok
  .tx_flexif_clk(tx_flexif_clk),                                  // input-[5:0]-dcmac--connected from axis_clk, which is 390.625MHz -- ok
  .tx_macif_clk(tx_macif_clk),                                    // input-[0:0]-dcmac--connected from axis_clk, which is 390.625MHz -- ok
  .tx_pcs_tdm_stats_data(),                                       // output-[21:0]-dcmac -- ok
  .tx_pcs_tdm_stats_start(),                                      // output-[0:0]-dcmac -- ok
  .tx_pcs_tdm_stats_valid(),                                      // output-[0:0]-dcmac -- ok
  .tx_port_pm_rdy(),                                              // output-[5:0]-dcmac -- ok
  .tx_port_pm_tick(pm_tick_core),                                 // input-[5:0]-fixed-0-dcmac -- ok
  .rx_port_pm_tick(pm_tick_core),                                 // input-[5:0]-fixed-0-dcmac -- ok
  .tx_preamblein_0(dcmac_tx_preamble[55:0]),                      // input-[55:0]-dcmac--connected from gear_tx module -- now it's from packed interface -- ok
  .tx_preamblein_1(dcmac_tx_preamble[111:56]),                      // input-[55:0]-dcmac--connected from gear_tx module -- now it's from packed interface -- ok
  .tx_preamblein_2(dcmac_tx_preamble[167:112]),                      // input-[55:0]-dcmac--connected from gear_tx module -- now it's from packed interface -- ok
  .tx_preamblein_3(dcmac_tx_preamble[223:168]),                      // input-[55:0]-dcmac--connected from gear_tx module -- now it's from packed interface -- ok
  .tx_preamblein_4(dcmac_tx_preamble[279:224]),                      // input-[55:0]-dcmac--connected from gear_tx module -- now it's from packed interface -- ok
  .tx_preamblein_5(dcmac_tx_preamble[335:280]),                      // input-[55:0]-dcmac--connected from gear_tx module -- now it's from packed interface -- ok
  .tx_serdes_clk(tx_serdes_clk),                                  // input-[5:0]-dcmac--connected from gt0_tx_usrclk_0 -- ok
  .tx_serdes_is_am_0(dcmac_tx_serdes_is_am[0]),                         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_1(dcmac_tx_serdes_is_am[1]),                         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_2(dcmac_tx_serdes_is_am[2]),                         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_3(dcmac_tx_serdes_is_am[3]),                         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_4(dcmac_tx_serdes_is_am[4]),                         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_5(dcmac_tx_serdes_is_am[5]),                         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_prefifo_0(dcmac_tx_serdes_is_am_prefifo[0]),         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_prefifo_1(dcmac_tx_serdes_is_am_prefifo[1]),         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_prefifo_2(dcmac_tx_serdes_is_am_prefifo[2]),         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_prefifo_3(dcmac_tx_serdes_is_am_prefifo[3]),         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_prefifo_4(dcmac_tx_serdes_is_am_prefifo[4]),         // output-[0:0]-dcmac--don't care
  .tx_serdes_is_am_prefifo_5(dcmac_tx_serdes_is_am_prefifo[5]),         // output-[0:0]-dcmac--don't care
  .tx_tsmac_tdm_stats_data(tx_tsmac_tdm_stats_data),              // output-[55:0]-dcmac--connected to tx_stats_cnt module -- wired, not used
  .tx_tsmac_tdm_stats_id(tx_tsmac_tdm_stats_id),                  // output-[5:0]-dcmac--connected to tx_stats_cnt module -- wired, not used
  .tx_tsmac_tdm_stats_valid(tx_tsmac_tdm_stats_valid),            // output-[0:0]-dcmac--connected to tx_stats_cnt module -- wired, not used
  .tx_serdes_reset(tx_serdes_reset)                               // input-[5:0]-dcmac--port: reset_dyn(0xA417_0000)-[7:2] -- ok
  );

endmodule