`timescale 1ns/1ns

(* DowngradeIPIdentifiedWarnings="yes" *)
module dcmac_udp_demo (
    input  wire [3:0] gt_rxn_in0,
    input  wire [3:0] gt_rxp_in0,
    output wire [3:0] gt_txn_out0,
    output wire [3:0] gt_txp_out0,
    input  wire [3:0] gt_rxn_in1,
    input  wire [3:0] gt_rxp_in1,
    output wire [3:0] gt_txn_out1,
    output wire [3:0] gt_txp_out1,
    input  wire       gt_ref_clk0_p,
    input  wire       gt_ref_clk0_n,
    input  wire       gt_ref_clk1_p,
    input  wire       gt_ref_clk1_n,
    // ddr
    output wire [5:0]ch0_lpddr4_trip1_ca_a,
    output wire [5:0]ch0_lpddr4_trip1_ca_b,
    output wire ch0_lpddr4_trip1_ck_c_a,
    output wire ch0_lpddr4_trip1_ck_c_b,
    output wire ch0_lpddr4_trip1_ck_t_a,
    output wire ch0_lpddr4_trip1_ck_t_b,
    output wire ch0_lpddr4_trip1_cke_a,
    output wire ch0_lpddr4_trip1_cke_b,
    output wire ch0_lpddr4_trip1_cs_a,
    output wire ch0_lpddr4_trip1_cs_b,
    inout [1:0]ch0_lpddr4_trip1_dmi_a,
    inout [1:0]ch0_lpddr4_trip1_dmi_b,
    inout [15:0]ch0_lpddr4_trip1_dq_a,
    inout [15:0]ch0_lpddr4_trip1_dq_b,
    inout [1:0]ch0_lpddr4_trip1_dqs_c_a,
    inout [1:0]ch0_lpddr4_trip1_dqs_c_b,
    inout [1:0]ch0_lpddr4_trip1_dqs_t_a,
    inout [1:0]ch0_lpddr4_trip1_dqs_t_b,
    output wire ch0_lpddr4_trip1_reset_n,
    output wire [5:0]ch0_lpddr4_trip2_ca_a,
    output wire [5:0]ch0_lpddr4_trip2_ca_b,
    output wire ch0_lpddr4_trip2_ck_c_a,
    output wire ch0_lpddr4_trip2_ck_c_b,
    output wire ch0_lpddr4_trip2_ck_t_a,
    output wire ch0_lpddr4_trip2_ck_t_b,
    output wire ch0_lpddr4_trip2_cke_a,
    output wire ch0_lpddr4_trip2_cke_b,
    output wire ch0_lpddr4_trip2_cs_a,
    output wire ch0_lpddr4_trip2_cs_b,
    inout [1:0]ch0_lpddr4_trip2_dmi_a,
    inout [1:0]ch0_lpddr4_trip2_dmi_b,
    inout [15:0]ch0_lpddr4_trip2_dq_a,
    inout [15:0]ch0_lpddr4_trip2_dq_b,
    inout [1:0]ch0_lpddr4_trip2_dqs_c_a,
    inout [1:0]ch0_lpddr4_trip2_dqs_c_b,
    inout [1:0]ch0_lpddr4_trip2_dqs_t_a,
    inout [1:0]ch0_lpddr4_trip2_dqs_t_b,
    output wire ch0_lpddr4_trip2_reset_n,
    output wire [5:0]ch1_lpddr4_trip1_ca_a,
    output wire [5:0]ch1_lpddr4_trip1_ca_b,
    output wire ch1_lpddr4_trip1_ck_c_a,
    output wire ch1_lpddr4_trip1_ck_c_b,
    output wire ch1_lpddr4_trip1_ck_t_a,
    output wire ch1_lpddr4_trip1_ck_t_b,
    output wire ch1_lpddr4_trip1_cke_a,
    output wire ch1_lpddr4_trip1_cke_b,
    output wire ch1_lpddr4_trip1_cs_a,
    output wire ch1_lpddr4_trip1_cs_b,
    inout [1:0]ch1_lpddr4_trip1_dmi_a,
    inout [1:0]ch1_lpddr4_trip1_dmi_b,
    inout [15:0]ch1_lpddr4_trip1_dq_a,
    inout [15:0]ch1_lpddr4_trip1_dq_b,
    inout [1:0]ch1_lpddr4_trip1_dqs_c_a,
    inout [1:0]ch1_lpddr4_trip1_dqs_c_b,
    inout [1:0]ch1_lpddr4_trip1_dqs_t_a,
    inout [1:0]ch1_lpddr4_trip1_dqs_t_b,
    output wire ch1_lpddr4_trip1_reset_n,
    output wire [5:0]ch1_lpddr4_trip2_ca_a,
    output wire [5:0]ch1_lpddr4_trip2_ca_b,
    output wire ch1_lpddr4_trip2_ck_c_a,
    output wire ch1_lpddr4_trip2_ck_c_b,
    output wire ch1_lpddr4_trip2_ck_t_a,
    output wire ch1_lpddr4_trip2_ck_t_b,
    output wire ch1_lpddr4_trip2_cke_a,
    output wire ch1_lpddr4_trip2_cke_b,
    output wire ch1_lpddr4_trip2_cs_a,
    output wire ch1_lpddr4_trip2_cs_b,
    inout [1:0]ch1_lpddr4_trip2_dmi_a,
    inout [1:0]ch1_lpddr4_trip2_dmi_b,
    inout [15:0]ch1_lpddr4_trip2_dq_a,
    inout [15:0]ch1_lpddr4_trip2_dq_b,
    inout [1:0]ch1_lpddr4_trip2_dqs_c_a,
    inout [1:0]ch1_lpddr4_trip2_dqs_c_b,
    inout [1:0]ch1_lpddr4_trip2_dqs_t_a,
    inout [1:0]ch1_lpddr4_trip2_dqs_t_b,
    output wire ch1_lpddr4_trip2_reset_n,
    input wire lpddr4_clk1_clk_n,
    input wire lpddr4_clk1_clk_p,
    input wire lpddr4_clk2_clk_n,
    input wire lpddr4_clk2_clk_p
);

wire             gt_reset_all_in;
wire [31:0]      gt_gpo;
wire             gt_reset_done;
wire [7 :0]      gt_line_rate;
wire [2 : 0]     gt_loopback;
wire [5 : 0]     gt_txprecursor;
wire [5 : 0]     gt_txpostcursor;
wire [6 : 0]     gt_txmaincursor;
wire             gt_rxcdrhold;
wire [31 : 0]    s_axi_awaddr;
wire             s_axi_awvalid;
wire             s_axi_awready;
wire [31 : 0]    s_axi_wdata;
wire             s_axi_wvalid;
wire             s_axi_wready;
wire [1 : 0]     s_axi_bresp;
wire             s_axi_bvalid;
wire             s_axi_bready;
wire [31 : 0]    s_axi_araddr;
wire             s_axi_arvalid;
wire             s_axi_arready;
wire [31 : 0]    s_axi_rdata;
wire [1 : 0]     s_axi_rresp;
wire             s_axi_rvalid;
wire             s_axi_rready;    
wire             pl0_ref_clk_0;
wire             pl0_resetn_0;    
wire [31:0]      APB_M2_prdata;
wire [0:0]       APB_M2_pready;
wire [0:0]       APB_M2_pslver;
wire [31:0]      APB_M3_prdata;
wire [0:0]       APB_M3_pready;
wire [0:0]       APB_M3_pslver;
wire [31:0]      APB_M4_prdata;
wire [0:0]       APB_M4_pready;
wire [0:0]       APB_M4_pslver;
wire [31:0]      APB_M2_paddr;
wire             APB_M2_penable;
wire [0:0]       APB_M2_psel;
wire [31:0]      APB_M2_pwdata;
wire             APB_M2_pwrite;
wire [31:0]      APB_M3_paddr;
wire             APB_M3_penable;
wire [0:0]       APB_M3_psel;
wire [31:0]      APB_M3_pwdata;
wire             APB_M3_pwrite;
wire [31:0]      APB_M4_paddr;
wire             APB_M4_penable;
wire [0:0]       APB_M4_psel;
wire [31:0]      APB_M4_pwdata;
wire             APB_M4_pwrite;
wire [23:0] gt_reset_tx_datapath_in;
wire [23:0] gt_reset_rx_datapath_in;
wire [5:0]  tx_serdes_reset;
wire [5:0]  rx_serdes_reset;
wire        tx_core_reset;
wire        rx_core_reset;
wire [23:0] gt_tx_reset_done_out;
wire [23:0] gt_rx_reset_done_out;

// axi for dcmac 
wire s_axi_aclk_dcmac;              // input
wire s_axi_aresetn_dcmac;           // input
wire [31:0] s_axi_awaddr_dcmac;     // input 
wire s_axi_awvalid_dcmac;           // input
wire s_axi_awready_dcmac;           // output
wire [31:0] s_axi_wdata_dcmac;      // input
wire s_axi_wvalid_dcmac;            // input
wire s_axi_wready_dcmac;            // output
wire [1:0] s_axi_bresp_dcmac;       // output
wire s_axi_bvalid_dcmac;            // output     
wire s_axi_bready_dcmac;            // input
wire [31:0] s_axi_araddr_dcmac;     // input
wire s_axi_arvalid_dcmac;           // input
wire s_axi_arready_dcmac;           // output
wire [31:0] s_axi_rdata_dcmac;      // output
wire [1:0] s_axi_rresp_dcmac;       // output
wire s_axi_rvalid_dcmac;            // output
wire s_axi_rready_dcmac;            // input

// axi for regs
wire s_axi_aclk_reg;              // input
wire s_axi_aresetn_reg;           // input
wire [31:0] s_axi_awaddr_reg;     // input 
wire s_axi_awvalid_reg;           // input
wire s_axi_awready_reg;           // output
wire [31:0] s_axi_wdata_reg;      // input
wire s_axi_wvalid_reg;            // input
wire s_axi_wready_reg;            // output
wire [1:0] s_axi_bresp_reg;       // output
wire s_axi_bvalid_reg;            // output     
wire s_axi_bready_reg;            // input
wire [31:0] s_axi_araddr_reg;     // input
wire s_axi_arvalid_reg;           // input
wire s_axi_arready_reg;           // output
wire [31:0] s_axi_rdata_reg;      // output
wire [1:0] s_axi_rresp_reg;       // output
wire s_axi_rvalid_reg;            // output
wire s_axi_rready_reg;            // input
//----------------------------------------------------------------------------------------------------
// added cips for control
dcmac_0_cips_wrapper i_dcmac_0_cips_wrapper(
    .APB_M2_0_paddr     (APB_M3_paddr),
    .APB_M2_0_penable   (APB_M3_penable),
    .APB_M2_0_prdata    (APB_M3_prdata),
    .APB_M2_0_pready    (APB_M3_pready),
    .APB_M2_0_psel      (APB_M3_psel),
    .APB_M2_0_pslverr   (APB_M3_pslverr),
    .APB_M2_0_pwdata    (APB_M3_pwdata),
    .APB_M2_0_pwrite    (APB_M3_pwrite),
    .APB_M3_0_paddr     (APB_M4_paddr),
    .APB_M3_0_penable   (APB_M4_penable),
    .APB_M3_0_prdata    (APB_M4_prdata),
    .APB_M3_0_pready    (APB_M4_pready),
    .APB_M3_0_psel      (APB_M4_psel),
    .APB_M3_0_pslverr   (APB_M4_pslverr),
    .APB_M3_0_pwdata    (APB_M4_pwdata),
    .APB_M3_0_pwrite    (APB_M4_pwrite),
    .APB_M_0_paddr      (APB_M2_paddr),
    .APB_M_0_penable    (APB_M2_penable),
    .APB_M_0_prdata     (APB_M2_prdata),
    .APB_M_0_pready     (APB_M2_pready),
    .APB_M_0_psel       (APB_M2_psel),
    .APB_M_0_pslverr    (APB_M2_pslverr),
    .APB_M_0_pwdata     (APB_M2_pwdata),
    .APB_M_0_pwrite     (APB_M2_pwrite),
    .M00_AXI_0_araddr   (s_axi_araddr),   
    .M00_AXI_0_arprot   (),               
    .M00_AXI_0_arready  (s_axi_arready),  
    .M00_AXI_0_arvalid  (s_axi_arvalid),  
    .M00_AXI_0_awaddr   (s_axi_awaddr),   
    .M00_AXI_0_awprot   (),               
    .M00_AXI_0_awready  (s_axi_awready),  
    .M00_AXI_0_awvalid  (s_axi_awvalid),  
    .M00_AXI_0_bready   (s_axi_bready),   
    .M00_AXI_0_bresp    (s_axi_bresp),    
    .M00_AXI_0_bvalid   (s_axi_bvalid),   
    .M00_AXI_0_rdata    (s_axi_rdata),    
    .M00_AXI_0_rready   (s_axi_rready),   
    .M00_AXI_0_rresp    (s_axi_rresp),    
    .M00_AXI_0_rvalid   (s_axi_rvalid),   
    .M00_AXI_0_wdata    (s_axi_wdata),    
    .M00_AXI_0_wready   (s_axi_wready),   
    .M00_AXI_0_wstrb    (),               
    .M00_AXI_0_wvalid   (s_axi_wvalid),   
    .pl0_ref_clk_0      (pl0_ref_clk_0),
    .gt_reset_all_in    (gt_reset_all_in),
    .gt_line_rate       (gt_line_rate),
    .gt_loopback        (gt_loopback),
    .gt_txprecursor     (gt_txprecursor),
    .gt_txpostcursor    (gt_txpostcursor),
    .gt_txmaincursor    (gt_txmaincursor),
    .gt_rxcdrhold       (gt_rxcdrhold),
    .gt_reset_tx_datapath_in (gt_reset_tx_datapath_in),
    .gt_reset_rx_datapath_in (gt_reset_rx_datapath_in),
    .gt_tx_reset_done  (gt_tx_reset_done_out),
    .gt_rx_reset_done  (gt_rx_reset_done_out),
    .tx_serdes_reset (tx_serdes_reset),
    .rx_serdes_reset (rx_serdes_reset),
    .tx_core_reset   (tx_core_reset),
    .rx_core_reset   (rx_core_reset),
	
    .M00_AXI_1_araddr     (s_axi_araddr_dcmac),	
    .M00_AXI_1_arprot     (		),	
    .M00_AXI_1_arready    (s_axi_arready_dcmac),
    .M00_AXI_1_arvalid    (s_axi_arvalid_dcmac),	
    .M00_AXI_1_awaddr     (s_axi_awaddr_dcmac),	
    .M00_AXI_1_awprot     (		),	
    .M00_AXI_1_awready    (s_axi_awready_dcmac),
    .M00_AXI_1_awvalid    (s_axi_awvalid_dcmac),	
    .M00_AXI_1_bready     (s_axi_bready_dcmac),	
    .M00_AXI_1_bresp      (s_axi_bresp_dcmac),
    .M00_AXI_1_bvalid     (s_axi_bvalid_dcmac),
    .M00_AXI_1_rdata      (s_axi_rdata_dcmac),
    .M00_AXI_1_rready     (s_axi_rready_dcmac),	
    .M00_AXI_1_rresp      (s_axi_rresp_dcmac),
    .M00_AXI_1_rvalid     (s_axi_rvalid_dcmac),
    .M00_AXI_1_wdata      (s_axi_wdata_dcmac),	
    .M00_AXI_1_wready     (s_axi_wready_dcmac),
    .M00_AXI_1_wstrb      (		),	
    .M00_AXI_1_wvalid     (s_axi_wvalid_dcmac),		
	
    .M00_AXI_2_araddr     (s_axi_araddr_reg),	
    .M00_AXI_2_arprot     (		),	
    .M00_AXI_2_arready    (s_axi_arready_reg),
    .M00_AXI_2_arvalid    (s_axi_arvalid_reg),	
    .M00_AXI_2_awaddr     (s_axi_awaddr_reg),	
    .M00_AXI_2_awprot     (		),	
    .M00_AXI_2_awready    (s_axi_awready_reg),
    .M00_AXI_2_awvalid    (s_axi_awvalid_reg),	
    .M00_AXI_2_bready     (s_axi_bready_reg),	
    .M00_AXI_2_bresp      (s_axi_bresp_reg),
    .M00_AXI_2_bvalid     (s_axi_bvalid_reg),
    .M00_AXI_2_rdata      (s_axi_rdata_reg),
    .M00_AXI_2_rready     (s_axi_rready_reg),	
    .M00_AXI_2_rresp      (s_axi_rresp_reg),
    .M00_AXI_2_rvalid     (s_axi_rvalid_reg),
    .M00_AXI_2_wdata      (s_axi_wdata_reg),	
    .M00_AXI_2_wready     (s_axi_wready_reg),
    .M00_AXI_2_wstrb      (		),	
    .M00_AXI_2_wvalid     (s_axi_wvalid_reg),		
	
    .M00_AXI_3_araddr     (		),	
    .M00_AXI_3_arprot     (		),	
    .M00_AXI_3_arready    (1'b0	),
    .M00_AXI_3_arvalid    (		),	
    .M00_AXI_3_awaddr     (		),	
    .M00_AXI_3_awprot     (		),	
    .M00_AXI_3_awready    (1'b0	),
    .M00_AXI_3_awvalid    (		),	
    .M00_AXI_3_bready     (		),	
    .M00_AXI_3_bresp      (2'b00),
    .M00_AXI_3_bvalid     (1'b0	),
    .M00_AXI_3_rdata      (32'd0),
    .M00_AXI_3_rready     (		),	
    .M00_AXI_3_rresp      (2'b00),
    .M00_AXI_3_rvalid     (1'b0	),
    .M00_AXI_3_wdata      (		),	
    .M00_AXI_3_wready     (1'b0	),
    .M00_AXI_3_wstrb      (		),	
    .M00_AXI_3_wvalid     (		),		
    .M00_AXI_4_araddr     (		),	
    .M00_AXI_4_arprot     (		),	
    .M00_AXI_4_arready    (1'b0	),
    .M00_AXI_4_arvalid    (		),	
    .M00_AXI_4_awaddr     (		),	
    .M00_AXI_4_awprot     (		),	
    .M00_AXI_4_awready    (1'b0	),
    .M00_AXI_4_awvalid    (		),	
    .M00_AXI_4_bready     (		),	
    .M00_AXI_4_bresp      (2'b00),
    .M00_AXI_4_bvalid     (1'b0	),
    .M00_AXI_4_rdata      (32'd0),
    .M00_AXI_4_rready     (		),	
    .M00_AXI_4_rresp      (2'b00),
    .M00_AXI_4_rvalid     (1'b0	),
    .M00_AXI_4_wdata      (		),	
    .M00_AXI_4_wready     (1'b0	),
    .M00_AXI_4_wstrb      (		),	
    .M00_AXI_4_wvalid     (		),		
	
	
    .M00_AXI_5_araddr     (		),	
    .M00_AXI_5_arprot     (		),	
    .M00_AXI_5_arready    (1'b0	),
    .M00_AXI_5_arvalid    (		),	
    .M00_AXI_5_awaddr     (		),	
    .M00_AXI_5_awprot     (		),	
    .M00_AXI_5_awready    (1'b0	),
    .M00_AXI_5_awvalid    (		),	
    .M00_AXI_5_bready     (		),	
    .M00_AXI_5_bresp      (2'b00),
    .M00_AXI_5_bvalid     (1'b0	),
    .M00_AXI_5_rdata      (32'd0),
    .M00_AXI_5_rready     (		),	
    .M00_AXI_5_rresp      (2'b00),
    .M00_AXI_5_rvalid     (1'b0	),
    .M00_AXI_5_wdata      (		),	
    .M00_AXI_5_wready     (1'b0	),
    .M00_AXI_5_wstrb      (		),	
    .M00_AXI_5_wvalid     (		),		
    .M00_AXI_6_araddr     (		),	
    .M00_AXI_6_arprot     (		),	
    .M00_AXI_6_arready    (1'b0	),
    .M00_AXI_6_arvalid    (		),	
    .M00_AXI_6_awaddr     (		),	
    .M00_AXI_6_awprot     (		),	
    .M00_AXI_6_awready    (1'b0	),
    .M00_AXI_6_awvalid    (		),	
    .M00_AXI_6_bready     (		),	
    .M00_AXI_6_bresp      (2'b00),
    .M00_AXI_6_bvalid     (1'b0	),
    .M00_AXI_6_rdata      (32'd0),
    .M00_AXI_6_rready     (		),	
    .M00_AXI_6_rresp      (2'b00),
    .M00_AXI_6_rvalid     (1'b0	),
    .M00_AXI_6_wdata      (		),	
    .M00_AXI_6_wready     (1'b0	),
    .M00_AXI_6_wstrb      (		),	
    .M00_AXI_6_wvalid     (		),		
	
    .pl0_resetn_0       (pl0_resetn_0),
    // ddr
    .ch0_lpddr4_trip1_ca_a(ch0_lpddr4_trip1_ca_a),
    .ch0_lpddr4_trip1_ca_b(ch0_lpddr4_trip1_ca_b),
    .ch0_lpddr4_trip1_ck_c_a(ch0_lpddr4_trip1_ck_c_a),
    .ch0_lpddr4_trip1_ck_c_b(ch0_lpddr4_trip1_ck_c_b),
    .ch0_lpddr4_trip1_ck_t_a(ch0_lpddr4_trip1_ck_t_a),
    .ch0_lpddr4_trip1_ck_t_b(ch0_lpddr4_trip1_ck_t_b),
    .ch0_lpddr4_trip1_cke_a(ch0_lpddr4_trip1_cke_a),
    .ch0_lpddr4_trip1_cke_b(ch0_lpddr4_trip1_cke_b),
    .ch0_lpddr4_trip1_cs_a(ch0_lpddr4_trip1_cs_a),
    .ch0_lpddr4_trip1_cs_b(ch0_lpddr4_trip1_cs_b),
    .ch0_lpddr4_trip1_dmi_a(ch0_lpddr4_trip1_dmi_a),
    .ch0_lpddr4_trip1_dmi_b(ch0_lpddr4_trip1_dmi_b),
    .ch0_lpddr4_trip1_dq_a(ch0_lpddr4_trip1_dq_a),
    .ch0_lpddr4_trip1_dq_b(ch0_lpddr4_trip1_dq_b),
    .ch0_lpddr4_trip1_dqs_c_a(ch0_lpddr4_trip1_dqs_c_a),
    .ch0_lpddr4_trip1_dqs_c_b(ch0_lpddr4_trip1_dqs_c_b),
    .ch0_lpddr4_trip1_dqs_t_a(ch0_lpddr4_trip1_dqs_t_a),
    .ch0_lpddr4_trip1_dqs_t_b(ch0_lpddr4_trip1_dqs_t_b),
    .ch0_lpddr4_trip1_reset_n(ch0_lpddr4_trip1_reset_n),
    .ch0_lpddr4_trip2_ca_a(ch0_lpddr4_trip2_ca_a),
    .ch0_lpddr4_trip2_ca_b(ch0_lpddr4_trip2_ca_b),
    .ch0_lpddr4_trip2_ck_c_a(ch0_lpddr4_trip2_ck_c_a),
    .ch0_lpddr4_trip2_ck_c_b(ch0_lpddr4_trip2_ck_c_b),
    .ch0_lpddr4_trip2_ck_t_a(ch0_lpddr4_trip2_ck_t_a),
    .ch0_lpddr4_trip2_ck_t_b(ch0_lpddr4_trip2_ck_t_b),
    .ch0_lpddr4_trip2_cke_a(ch0_lpddr4_trip2_cke_a),
    .ch0_lpddr4_trip2_cke_b(ch0_lpddr4_trip2_cke_b),
    .ch0_lpddr4_trip2_cs_a(ch0_lpddr4_trip2_cs_a),
    .ch0_lpddr4_trip2_cs_b(ch0_lpddr4_trip2_cs_b),
    .ch0_lpddr4_trip2_dmi_a(ch0_lpddr4_trip2_dmi_a),
    .ch0_lpddr4_trip2_dmi_b(ch0_lpddr4_trip2_dmi_b),
    .ch0_lpddr4_trip2_dq_a(ch0_lpddr4_trip2_dq_a),
    .ch0_lpddr4_trip2_dq_b(ch0_lpddr4_trip2_dq_b),
    .ch0_lpddr4_trip2_dqs_c_a(ch0_lpddr4_trip2_dqs_c_a),
    .ch0_lpddr4_trip2_dqs_c_b(ch0_lpddr4_trip2_dqs_c_b),
    .ch0_lpddr4_trip2_dqs_t_a(ch0_lpddr4_trip2_dqs_t_a),
    .ch0_lpddr4_trip2_dqs_t_b(ch0_lpddr4_trip2_dqs_t_b),
    .ch0_lpddr4_trip2_reset_n(ch0_lpddr4_trip2_reset_n),
    .ch1_lpddr4_trip1_ca_a(ch1_lpddr4_trip1_ca_a),
    .ch1_lpddr4_trip1_ca_b(ch1_lpddr4_trip1_ca_b),
    .ch1_lpddr4_trip1_ck_c_a(ch1_lpddr4_trip1_ck_c_a),
    .ch1_lpddr4_trip1_ck_c_b(ch1_lpddr4_trip1_ck_c_b),
    .ch1_lpddr4_trip1_ck_t_a(ch1_lpddr4_trip1_ck_t_a),
    .ch1_lpddr4_trip1_ck_t_b(ch1_lpddr4_trip1_ck_t_b),
    .ch1_lpddr4_trip1_cke_a(ch1_lpddr4_trip1_cke_a),
    .ch1_lpddr4_trip1_cke_b(ch1_lpddr4_trip1_cke_b),
    .ch1_lpddr4_trip1_cs_a(ch1_lpddr4_trip1_cs_a),
    .ch1_lpddr4_trip1_cs_b(ch1_lpddr4_trip1_cs_b),
    .ch1_lpddr4_trip1_dmi_a(ch1_lpddr4_trip1_dmi_a),
    .ch1_lpddr4_trip1_dmi_b(ch1_lpddr4_trip1_dmi_b),
    .ch1_lpddr4_trip1_dq_a(ch1_lpddr4_trip1_dq_a),
    .ch1_lpddr4_trip1_dq_b(ch1_lpddr4_trip1_dq_b),
    .ch1_lpddr4_trip1_dqs_c_a(ch1_lpddr4_trip1_dqs_c_a),
    .ch1_lpddr4_trip1_dqs_c_b(ch1_lpddr4_trip1_dqs_c_b),
    .ch1_lpddr4_trip1_dqs_t_a(ch1_lpddr4_trip1_dqs_t_a),
    .ch1_lpddr4_trip1_dqs_t_b(ch1_lpddr4_trip1_dqs_t_b),
    .ch1_lpddr4_trip1_reset_n(ch1_lpddr4_trip1_reset_n),
    .ch1_lpddr4_trip2_ca_a(ch1_lpddr4_trip2_ca_a),
    .ch1_lpddr4_trip2_ca_b(ch1_lpddr4_trip2_ca_b),
    .ch1_lpddr4_trip2_ck_c_a(ch1_lpddr4_trip2_ck_c_a),
    .ch1_lpddr4_trip2_ck_c_b(ch1_lpddr4_trip2_ck_c_b),
    .ch1_lpddr4_trip2_ck_t_a(ch1_lpddr4_trip2_ck_t_a),
    .ch1_lpddr4_trip2_ck_t_b(ch1_lpddr4_trip2_ck_t_b),
    .ch1_lpddr4_trip2_cke_a(ch1_lpddr4_trip2_cke_a),
    .ch1_lpddr4_trip2_cke_b(ch1_lpddr4_trip2_cke_b),
    .ch1_lpddr4_trip2_cs_a(ch1_lpddr4_trip2_cs_a),
    .ch1_lpddr4_trip2_cs_b(ch1_lpddr4_trip2_cs_b),
    .ch1_lpddr4_trip2_dmi_a(ch1_lpddr4_trip2_dmi_a),
    .ch1_lpddr4_trip2_dmi_b(ch1_lpddr4_trip2_dmi_b),
    .ch1_lpddr4_trip2_dq_a(ch1_lpddr4_trip2_dq_a),
    .ch1_lpddr4_trip2_dq_b(ch1_lpddr4_trip2_dq_b),
    .ch1_lpddr4_trip2_dqs_c_a(ch1_lpddr4_trip2_dqs_c_a),
    .ch1_lpddr4_trip2_dqs_c_b(ch1_lpddr4_trip2_dqs_c_b),
    .ch1_lpddr4_trip2_dqs_t_a(ch1_lpddr4_trip2_dqs_t_a),
    .ch1_lpddr4_trip2_dqs_t_b(ch1_lpddr4_trip2_dqs_t_b),
    .ch1_lpddr4_trip2_reset_n(ch1_lpddr4_trip2_reset_n),
    .lpddr4_clk1_clk_n(lpddr4_clk1_clk_n),
    .lpddr4_clk1_clk_p(lpddr4_clk1_clk_p),
    .lpddr4_clk2_clk_n(lpddr4_clk2_clk_n),
    .lpddr4_clk2_clk_p(lpddr4_clk2_clk_p)
);

//----------------------------------------------------------------------------------------------------
// add axis data creater module here
wire [1023:0] axis_streaming_data_tx_tdata;     // input
wire axis_streaming_data_tx_tvalid;             // input
wire axis_streaming_data_tx_tuser;              // input
wire [127:0] axis_streaming_data_tx_tkeep;      // input
wire axis_streaming_data_tx_tlast;              // input
wire axis_streaming_data_tx_tready;              // output
wire axis_streaming_arst;
wire axis_streaming_data_clk;

wire axis_data_gen_enable;
wire [15:0] pkt_length;
wire [15:0] period;

assign axis_streaming_data_clk = pl0_ref_clk_0;
assign axis_streaming_arst = ~pl0_resetn_0;

axis_data_gen #(
    .G_AXIS_DATA_WIDTH (1024)
) axis_data_gen_inst(
    .axis_streaming_data_clk(axis_streaming_data_clk),
    .axis_streaming_arst(axis_streaming_arst),
    .axis_data_gen_enable(axis_data_gen_enable),
    .pkt_length(pkt_length),
    .period(period),
    .axis_streaming_data_tx_tdata(axis_streaming_data_tx_tdata),
    .axis_streaming_data_tx_tvalid(axis_streaming_data_tx_tvalid),
    .axis_streaming_data_tx_tuser(axis_streaming_data_tx_tuser),
    .axis_streaming_data_tx_tkeep(axis_streaming_data_tx_tkeep),
    .axis_streaming_data_tx_tlast(axis_streaming_data_tx_tlast),
    .axis_streaming_data_tx_tready(axis_streaming_data_tx_tready)
);
//----------------------------------------------------------------------------------------------------
// add axi regs here
// connect to .M00_AXI_2
wire [31:0] axis_streaming_data_tx_destination_ip;              // input
wire [15:0] axis_streaming_data_tx_destination_udp_port;        // input
wire [15:0] axis_streaming_data_tx_source_udp_port;             // input
wire [15:0] axis_streaming_data_tx_packet_length;               // input
wire [31:0] gmac_reg_phy_control_h;                             // input
wire [31:0] gmac_reg_phy_control_l;                             // input        
wire [31:0] gmac_reg_mac_address_h;                             // input
wire [31:0] gmac_reg_mac_address_l;                             // input
wire [31:0] gmac_reg_local_ip_address;                          // input
wire [31:0] gmac_reg_local_ip_netmask;                          // input
wire [31:0] gmac_reg_gateway_ip_address;                        // input    
wire [31:0] gmac_reg_multicast_ip_address;                      // input
wire [31:0] gmac_reg_multicast_ip_mask;                         // input
wire [31:0] gmac_reg_udp_port;                                  // input
wire [31:0] gmac_reg_core_ctrl;                                 // input
wire [31:0] gmac_reg_core_type;                                 // output
wire [31:0] gmac_reg_phy_status_h;                              // output
wire [31:0] gmac_reg_phy_status_l;                              // output     
wire [31:0] gmac_reg_tx_packet_rate;                            // output
wire [31:0] gmac_reg_tx_packet_count;                           // output
wire [31:0] gmac_reg_tx_valid_rate;                             // output
wire [31:0] gmac_reg_tx_valid_count;                            // output
wire [31:0] gmac_reg_tx_overflow_count;                         // output
wire [31:0] gmac_reg_tx_almost_full_count;                      // output
wire [31:0] gmac_reg_rx_packet_rate;                            // output
wire [31:0] gmac_reg_rx_packet_count;                           // output
wire [31:0] gmac_reg_rx_valid_rate;                             // output
wire [31:0] gmac_reg_rx_valid_count;                            // output
wire [31:0] gmac_reg_rx_overflow_count;                         // output
wire [31:0] gmac_reg_rx_almost_full_count;                      // output       
wire [31:0] gmac_reg_rx_bad_packet_count;                       // output
wire [31:0] gmac_reg_arp_size;                                  // output
wire [31:0] gmac_reg_word_size;                                 // output
wire [31:0] gmac_reg_buffer_max_size;                           // output
wire [31:0] gmac_reg_count_reset;                               // input
wire [31:0] gmac_arp_cache_write_enable;                        // input
wire [31:0] gmac_arp_cache_read_enable;                         // input
wire [31:0] gmac_arp_cache_write_data;                          // input
wire [31:0] gmac_arp_cache_write_address;                       // input
wire [31:0] gmac_arp_cache_read_address;                        // input    
wire [31:0] gmac_arp_cache_read_data;                           // output

axi_regs #(

) axi_regs_inst(
    .s_axi_araddr     (s_axi_araddr_reg),	
    .s_axi_arprot     (		),	
    .s_axi_arready    (s_axi_arready_reg),
    .s_axi_arvalid    (s_axi_arvalid_reg),	
    .s_axi_awaddr     (s_axi_awaddr_reg),	
    .s_axi_awprot     (		),	
    .s_axi_awready    (s_axi_awready_reg),
    .s_axi_awvalid    (s_axi_awvalid_reg),	
    .s_axi_bready     (s_axi_bready_reg),	
    .s_axi_bresp      (s_axi_bresp_reg),
    .s_axi_bvalid     (s_axi_bvalid_reg),
    .s_axi_rdata      (s_axi_rdata_reg),
    .s_axi_rready     (s_axi_rready_reg),	
    .s_axi_rresp      (s_axi_rresp_reg),
    .s_axi_rvalid     (s_axi_rvalid_reg),
    .s_axi_wdata      (s_axi_wdata_reg),	
    .s_axi_wready     (s_axi_wready_reg),
    .s_axi_wstrb      (		),	
    .s_axi_wvalid     (s_axi_wvalid_reg),	
    // -- ip & port info
    .axis_streaming_data_tx_destination_ip( axis_streaming_data_tx_destination_ip),
    .axis_streaming_data_tx_destination_udp_port( axis_streaming_data_tx_destination_udp_port),
    .axis_streaming_data_tx_source_udp_port( axis_streaming_data_tx_source_udp_port),
    .axis_streaming_data_tx_packet_length( axis_streaming_data_tx_packet_length),   
    // -- Software controlled register IO
    .gmac_reg_phy_control_h(gmac_reg_phy_control_h),
    .gmac_reg_phy_control_l(gmac_reg_phy_control_l),
    .gmac_reg_mac_address_h(gmac_reg_mac_address_h),
    .gmac_reg_mac_address_l(gmac_reg_mac_address_l),
    .gmac_reg_local_ip_address(gmac_reg_local_ip_address),
    .gmac_reg_local_ip_netmask(gmac_reg_local_ip_netmask),
    .gmac_reg_gateway_ip_address(gmac_reg_gateway_ip_address),
    .gmac_reg_multicast_ip_address(gmac_reg_multicast_ip_address),
    .gmac_reg_multicast_ip_mask(gmac_reg_multicast_ip_mask),
    .gmac_reg_udp_port(gmac_reg_udp_port),
    .gmac_reg_core_ctrl(gmac_reg_core_ctrl),
    .gmac_reg_core_type(gmac_reg_core_type),
    .gmac_reg_phy_status_h(gmac_reg_phy_status_h),
    .gmac_reg_phy_status_l(gmac_reg_phy_status_l),
    .gmac_reg_tx_packet_rate(gmac_reg_tx_packet_rate),
    .gmac_reg_tx_packet_count(gmac_reg_tx_packet_count),
    .gmac_reg_tx_valid_rate(gmac_reg_tx_valid_rate),
    .gmac_reg_tx_valid_count(gmac_reg_tx_valid_count),
    .gmac_reg_tx_overflow_count(gmac_reg_tx_overflow_count),
    .gmac_reg_tx_almost_full_count(gmac_reg_tx_almost_full_count),
    .gmac_reg_rx_packet_rate(gmac_reg_rx_packet_rate),
    .gmac_reg_rx_packet_count(gmac_reg_rx_packet_count),
    .gmac_reg_rx_valid_rate(gmac_reg_rx_valid_rate),
    .gmac_reg_rx_valid_count(gmac_reg_rx_valid_count),
    .gmac_reg_rx_overflow_count(gmac_reg_rx_overflow_count),
    .gmac_reg_rx_almost_full_count(gmac_reg_rx_almost_full_count),
    .gmac_reg_rx_bad_packet_count(gmac_reg_rx_bad_packet_count),
    .gmac_reg_arp_size(gmac_reg_arp_size),
    .gmac_reg_word_size(gmac_reg_word_size),
    .gmac_reg_buffer_max_size(gmac_reg_buffer_max_size),
    .gmac_reg_count_reset(gmac_reg_count_reset),
    .gmac_arp_cache_write_enable(gmac_arp_cache_write_enable),
    .gmac_arp_cache_read_enable(gmac_arp_cache_read_enable),
    .gmac_arp_cache_write_data(gmac_arp_cache_write_data),
    .gmac_arp_cache_write_address(gmac_arp_cache_write_address),
    .gmac_arp_cache_read_address(gmac_arp_cache_read_address),
    .gmac_arp_cache_read_data(gmac_arp_cache_read_data),
    .axis_data_gen_enable(axis_data_gen_enable),
    .pkt_length(pkt_length),
    .period(period)
);




wire aximm_clk;
wire axis_reset;


assign aximm_clk = pl0_ref_clk_0;
assign axis_reset = ~pl0_resetn_0;
assign s_axi_aclk_dcmac = pl0_ref_clk_0;
assign s_axi_aresetn_dcmac = pl0_resetn_0;

// added casper400gethernetblock_no_cpu module here
casper400gethernetblock_no_cpu #(
    .G_AXIS_DATA_WIDTH (1024)
) casper400gethernetblock_no_cpu_inst(
    .aximm_clk(aximm_clk),
    .icap_clk(1'b0),         // we don't care about icap
    .axis_reset(axis_reset),
    .gt_clk0_p(gt_ref_clk0_p),
    .gt_clk0_n(gt_ref_clk0_n),
    .gt_clk1_p(gt_ref_clk1_p),
    .gt_clk1_n(gt_ref_clk1_n),
    .gt0_rx_p(gt_rxp_in0),
    .gt0_rx_n(gt_rxn_in0),
    .gt1_rx_p(gt_rxp_in1),
    .gt1_rx_n(gt_rxn_in1),
    .gt0_tx_p(gt_txp_out0),
    .gt0_tx_n(gt_txn_out0),
    .gt1_tx_p(gt_txp_out1),
    .gt1_tx_n(gt_txn_out1),
    .qsfp_modsell_ls(), //output
    .qsfp_resetl_ls(), //output
    .qsfp_modprsl_ls(1'b0), 
    .qsfp_intl_ls(1'b0),
    .qsfp_lpmode_ls(), 
    .axis_streaming_data_clk(axis_streaming_data_clk),
    .axis_streaming_data_rx_packet_length(),        

    .yellow_block_rx_data(),
    .yellow_block_rx_valid(),
    .yellow_block_rx_eof(),
    .yellow_block_rx_overrun(),

    // DCMAC core config/rst interfaces
    // axi interface for DCMAC core configuration
    // connect to M_AXI1
    .s_axi_aclk(s_axi_aclk_dcmac),    
    .s_axi_aresetn(s_axi_aresetn_dcmac),
    .s_axi_awaddr(s_axi_awaddr_dcmac),
    .s_axi_awvalid(s_axi_awvalid_dcmac),
    .s_axi_awready(s_axi_awready_dcmac),
    .s_axi_wdata(s_axi_wdata_dcmac),
    .s_axi_wvalid(s_axi_wvalid_dcmac),
    .s_axi_wready(s_axi_wready_dcmac),
    .s_axi_bresp(s_axi_bresp_dcmac), 
    .s_axi_bvalid(s_axi_bvalid_dcmac),
    .s_axi_bready(s_axi_bready_dcmac),
    .s_axi_araddr(s_axi_araddr_dcmac),
    .s_axi_arvalid(s_axi_arvalid_dcmac),
    .s_axi_arready(s_axi_arready_dcmac),
    .s_axi_rdata(s_axi_rdata_dcmac),
    .s_axi_rresp(s_axi_rresp_dcmac),
    .s_axi_rvalid(s_axi_rvalid_dcmac),
    .s_axi_rready(s_axi_rready_dcmac),
    //-- GT control signals
    .gt_rxcdrhold(gt_rxcdrhold),
    .gt_txprecursor(gt_txprecursor),
    .gt_txpostcursor(gt_txpostcursor),
    .gt_txmaincursor(gt_txmaincursor),
    .gt_loopback(gt_loopback),
    .gt_line_rate(gt_line_rate),
    .gt_reset_all_in(gt_reset_all_in),
    // -- TX & RX datapath
    .gt_reset_tx_datapath_in(gt_reset_tx_datapath_in),
    .gt_reset_rx_datapath_in(gt_reset_rx_datapath_in),
    // -- reset_dyn
    .rx_core_reset(rx_core_reset),
    .rx_serdes_reset(rx_serdes_reset),
    .tx_core_reset(tx_core_reset),
    .tx_serdes_reset(tx_serdes_reset),
    //-- reset_done_dyn
    .gt_tx_reset_done_out(gt_tx_reset_done_out),
    .gt_rx_reset_done_out(gt_rx_reset_done_out),

    //--Data inputs from AXIS bus of the Yellow Blocks
    .axis_streaming_data_tx_tdata(axis_streaming_data_tx_tdata),
    .axis_streaming_data_tx_tvalid(axis_streaming_data_tx_tvalid),
    .axis_streaming_data_tx_tuser(axis_streaming_data_tx_tuser),
    .axis_streaming_data_tx_tkeep(axis_streaming_data_tx_tkeep),
    .axis_streaming_data_tx_tlast(axis_streaming_data_tx_tlast),
    .axis_streaming_data_tx_tready(axis_streaming_data_tx_tready),

    .axis_streaming_data_tx_destination_ip( axis_streaming_data_tx_destination_ip),
    .axis_streaming_data_tx_destination_udp_port( axis_streaming_data_tx_destination_udp_port),
    .axis_streaming_data_tx_source_udp_port( axis_streaming_data_tx_source_udp_port),
    .axis_streaming_data_tx_packet_length( axis_streaming_data_tx_packet_length),   
    // -- Software controlled register IO
    .gmac_reg_phy_control_h(gmac_reg_phy_control_h),
    .gmac_reg_phy_control_l(gmac_reg_phy_control_l),
    .gmac_reg_mac_address_h(gmac_reg_mac_address_h),
    .gmac_reg_mac_address_l(gmac_reg_mac_address_l),
    .gmac_reg_local_ip_address(gmac_reg_local_ip_address),
    .gmac_reg_local_ip_netmask(gmac_reg_local_ip_netmask),
    .gmac_reg_gateway_ip_address(gmac_reg_gateway_ip_address),
    .gmac_reg_multicast_ip_address(gmac_reg_multicast_ip_address),
    .gmac_reg_multicast_ip_mask(gmac_reg_multicast_ip_mask),
    .gmac_reg_udp_port(gmac_reg_udp_port),
    .gmac_reg_core_ctrl(gmac_reg_core_ctrl),
    .gmac_reg_core_type(gmac_reg_core_type),
    .gmac_reg_phy_status_h(gmac_reg_phy_status_h),
    .gmac_reg_phy_status_l(gmac_reg_phy_status_l),
    .gmac_reg_tx_packet_rate(gmac_reg_tx_packet_rate),
    .gmac_reg_tx_packet_count(gmac_reg_tx_packet_count),
    .gmac_reg_tx_valid_rate(gmac_reg_tx_valid_rate),
    .gmac_reg_tx_valid_count(gmac_reg_tx_valid_count),
    .gmac_reg_tx_overflow_count(gmac_reg_tx_overflow_count),
    .gmac_reg_tx_almost_full_count(gmac_reg_tx_almost_full_count),
    .gmac_reg_rx_packet_rate(gmac_reg_rx_packet_rate),
    .gmac_reg_rx_packet_count(gmac_reg_rx_packet_count),
    .gmac_reg_rx_valid_rate(gmac_reg_rx_valid_rate),
    .gmac_reg_rx_valid_count(gmac_reg_rx_valid_count),
    .gmac_reg_rx_overflow_count(gmac_reg_rx_overflow_count),
    .gmac_reg_rx_almost_full_count(gmac_reg_rx_almost_full_count),
    .gmac_reg_rx_bad_packet_count(gmac_reg_rx_bad_packet_count),
    .gmac_reg_arp_size(gmac_reg_arp_size),
    .gmac_reg_word_size(gmac_reg_word_size),
    .gmac_reg_buffer_max_size(gmac_reg_buffer_max_size),
    .gmac_reg_count_reset(gmac_reg_count_reset),
    .gmac_arp_cache_write_enable(gmac_arp_cache_write_enable),
    .gmac_arp_cache_read_enable(gmac_arp_cache_read_enable),
    .gmac_arp_cache_write_data(gmac_arp_cache_write_data),
    .gmac_arp_cache_write_address(gmac_arp_cache_write_address),
    .gmac_arp_cache_read_address(gmac_arp_cache_read_address),
    .gmac_arp_cache_read_data(gmac_arp_cache_read_data)
);
endmodule