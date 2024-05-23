--------------------------------------------------------------------------------
-- Company          : Kutleng Dynamic Electronics Systems (Pty) Ltd            -
-- Engineer         : Benjamin Hector Hlophe,                                  -
--                                                                             -
-- Design Name      : CASPER BSP                                               -
-- Module Name      : casper400gethernetblock_no_cpu - rtl                     -
-- Project Name     : CASPER                                                   -
-- Target Devices   : N/A                                                      -
-- Tool Versions    : N/A                                                      -
-- Description      : This module instantiates two QSFP28+ ports with CMACs.   -
--                    The udpipinterfacepr module is instantiated to connect   -
--                    UDP functionality on QSFP28+[1].                         -
--                    To test bandwidth the testcomms module is instantiated on-
--                    QSFP28+[2].                                              -
-- Dependencies     : mac100gphy,microblaze_axi_us_plus_wrapper,clockgen100mhz,-
--                    testcomms,udpipinterfacepr,pciexdma_refbd_wrapper.       -
--                    partialblinker,ledflasher,ICAP3E                         -
-- Revision History : V1.0 - Initial design                                    -
--                    V1.1 - Modify the module for 400g ethernet               -    
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity casper400gethernetblock_no_cpu is
    generic(
        -- Boolean to include or not include ICAP for partial reconfiguration
        G_INCLUDE_ICAP               : boolean              := false;
        -- Use RS FEC in MAC IP
        G_USE_RS_FEC                 : boolean              := false;
        -- Number GTME4_COMMON primitives to be instanced
        -- For the 400g design, it's requried to use 2GTM per quad across 2 quads.
        -- Search "full density or half density mode" in this document:
        -- https://docs.xilinx.com/r/en-US/am017-versal-gtm-transceivers/Transceiver-and-Tool-Overview
        G_N_COMMON                   : natural range 1 to 2 := 2;
        -- Streaming data size (must be 1024)
        G_AXIS_DATA_WIDTH            : natural              := 1024;
        -- Number of UDP Streaming Data Server Modules 
        G_NUM_STREAMING_DATA_SERVERS : natural range 1 to 4 := 1;
        -- Number of slots in circular buffers (2^?)
        G_SLOT_WIDTH                 : natural              := 2;
        -- Instance ID
        G_MAC_INSTANCE               : integer              := 0
    );
    port(
        -- Aximm clock is the AXI Lite MM clock for the gmac register interface
        -- Usually 125MHz 
        aximm_clk                                   : in  STD_LOGIC;
        -- ICAP is the 125MHz ICAP clock used for PR
        icap_clk                                    : in  STD_LOGIC;
        -- Axis reset is the global synchronous reset to the highest clock
        axis_reset                                  : in  STD_LOGIC;
        -- Ethernet reference clock for 156.25MHz
        -- We need 2 quads for the 400G Ethernet by default.
        gt_clk0_p                                   : in  STD_LOGIC;
        gt_clk0_n                                   : in  STD_LOGIC;
        gt_clk1_p                                   : in  STD_LOGIC;
        gt_clk1_n                                   : in  STD_LOGIC; 
        --RX     
        gt0_rx_p                                    : in  STD_LOGIC_VECTOR(3 downto 0);
        gt0_rx_n                                    : in  STD_LOGIC_VECTOR(3 downto 0); 
        gt1_rx_p                                    : in  STD_LOGIC_VECTOR(3 downto 0);
        gt1_rx_n                                    : in  STD_LOGIC_VECTOR(3 downto 0);
        -- TX
        gt0_tx_p                                    : out STD_LOGIC_VECTOR(3 downto 0);
        gt0_tx_n                                    : out STD_LOGIC_VECTOR(3 downto 0);
        gt1_tx_p                                    : out STD_LOGIC_VECTOR(3 downto 0);
        gt1_tx_n                                    : out STD_LOGIC_VECTOR(3 downto 0);
        -- Settings
        qsfp_modsell_ls                             : out STD_LOGIC;
        qsfp_resetl_ls                              : out STD_LOGIC;
        qsfp_modprsl_ls                             : in  STD_LOGIC;
        qsfp_intl_ls                                : in  STD_LOGIC;
        qsfp_lpmode_ls                              : out STD_LOGIC;
        -- axis clk -- 390.625MHz
        axis_clk_out                                : out STD_LOGIC;
        ------------------------------------------------------------------------
        -- Yellow Block Data Interface                                        --
        -- These can be many AXIS interfaces denoted by axis_data{n}_tx/rx    --
        -- where {n} = G_NUM_STREAMING_DATA_SERVERS.                          --
        -- Each of them run on their own clock.                               --
        -- Aggregate data rate for all modules combined must be less than 100G--                                --
        -- Each module in a PR configuration makes a PR boundary.             --
        ------------------------------------------------------------------------
        -- Streaming data clocks 
        axis_streaming_data_clk                     : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
        axis_streaming_data_rx_packet_length        : out STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);         
        
        -- -- Streaming data outputs to AXIS of the Yellow Blocks
        -- axis_streaming_data_rx_tdata                : out STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        -- axis_streaming_data_rx_tvalid               : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
        -- axis_streaming_data_rx_tready               : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
        -- axis_streaming_data_rx_tkeep                : out STD_LOGIC_VECTOR(((G_AXIS_DATA_WIDTH / 8) * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        -- axis_streaming_data_rx_tlast                : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
        -- axis_streaming_data_rx_tuser                : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);

        yellow_block_rx_data            : out  STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
        yellow_block_rx_valid           : out  STD_LOGIC;
        yellow_block_rx_eof             : out  STD_LOGIC;
        yellow_block_rx_overrun         : out  STD_LOGIC;

         -- GTM transceiver config
         axi4_lite_aclk               : in STD_LOGIC;
         axi4_lite_araddr             : in STD_LOGIC_VECTOR(31 downto 0);
         axi4_lite_aresetn            : in STD_LOGIC;
         axi4_lite_arready            : out STD_LOGIC;
         axi4_lite_arvalid            : in STD_LOGIC;
         axi4_lite_awaddr             : in STD_LOGIC_VECTOR(31 downto 0);
         axi4_lite_awready            : out STD_LOGIC;
         axi4_lite_awvalid            : in STD_LOGIC;
         axi4_lite_bready             : in STD_LOGIC;
         axi4_lite_bresp              : out STD_LOGIC_VECTOR(1 downto 0);
         axi4_lite_bvalid             : out STD_LOGIC;
         axi4_lite_rdata              : out STD_LOGIC_VECTOR(31 downto 0);
         axi4_lite_rready             : in STD_LOGIC;
         axi4_lite_rresp              : out STD_LOGIC_VECTOR(1 downto 0);
         axi4_lite_rvalid             : out STD_LOGIC; 
         axi4_lite_wdata              : in STD_LOGIC_VECTOR(31 downto 0);
         axi4_lite_wready             : out STD_LOGIC;
         axi4_lite_wvalid             : in STD_LOGIC; 
        -- DCMAC core config/rst interfaces
        -- axi interface for DCMAC core configuration
        s_axi_aclk                   : in  STD_LOGIC;    
        s_axi_aresetn                : in  STD_LOGIC;
        s_axi_awaddr                 : in  STD_LOGIC_VECTOR(31 downto 0);
        s_axi_awvalid                : in  STD_LOGIC;
        s_axi_awready                : out STD_LOGIC;
        s_axi_wdata                  : in  STD_LOGIC_VECTOR(31 downto 0);
        s_axi_wvalid                 : in  STD_LOGIC;
        s_axi_wready                 : out STD_LOGIC;
        s_axi_bresp                  : out STD_LOGIC_VECTOR(1 downto 0);
        s_axi_bvalid                 : out STD_LOGIC;
        s_axi_bready                 : in  STD_LOGIC;
        s_axi_araddr                 : in  STD_LOGIC_VECTOR(31 downto 0);
        s_axi_arvalid                : in  STD_LOGIC;
        s_axi_arready                : out STD_LOGIC;
        s_axi_rdata                  : out STD_LOGIC_VECTOR(31 downto 0);
        s_axi_rresp                  : out STD_LOGIC_VECTOR(1 downto 0);
        s_axi_rvalid                 : out STD_LOGIC;
        s_axi_rready                 : in  STD_LOGIC;
        -- GT control signals
        gt_rxcdrhold                 : in  STD_LOGIC;
        gt_txprecursor               : in  STD_LOGIC_VECTOR(5 downto 0);
        gt_txpostcursor              : in  STD_LOGIC_VECTOR(5 downto 0);
        gt_txmaincursor              : in  STD_LOGIC_VECTOR(6 downto 0);
        gt_loopback                  : in  STD_LOGIC_VECTOR(2 downto 0);
        gt_line_rate                 : in  STD_LOGIC_VECTOR(7 downto 0);
        gt_reset_all_in              : in  STD_LOGIC;
        -- TX & RX datapath
        gt_reset_tx_datapath_in      : in  STD_LOGIC_VECTOR(7 downto 0);
        gt_reset_rx_datapath_in      : in  STD_LOGIC_VECTOR(7 downto 0);
        -- reset_dyn
        rx_core_reset                : in  STD_LOGIC;
        rx_serdes_reset              : in  STD_LOGIC_VECTOR(5 downto 0);
        tx_core_reset                : in  STD_LOGIC;
        tx_serdes_reset              : in  STD_LOGIC_VECTOR(5 downto 0);
        -- reset_done_dyn
        gt_tx_reset_done_out         : out STD_LOGIC_VECTOR(7 downto 0);
        gt_rx_reset_done_out         : out STD_LOGIC_VECTOR(7 downto 0);

        --Data inputs from AXIS bus of the Yellow Blocks
        axis_streaming_data_tx_destination_ip       : in  STD_LOGIC_VECTOR((32 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        axis_streaming_data_tx_destination_udp_port : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        axis_streaming_data_tx_source_udp_port      : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        axis_streaming_data_tx_packet_length        : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);         
        
        axis_streaming_data_tx_tdata                : in  STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        axis_streaming_data_tx_tvalid               : in  STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        axis_streaming_data_tx_tuser                : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
        axis_streaming_data_tx_tkeep                : in  STD_LOGIC_VECTOR(((G_AXIS_DATA_WIDTH / 8) * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
        axis_streaming_data_tx_tlast                : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
        axis_streaming_data_tx_tready               : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);

        -- Software controlled register IO
        gmac_reg_phy_control_h                 : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_phy_control_l                 : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_mac_address_h                 : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_mac_address_l                 : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_local_ip_address              : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_local_ip_netmask              : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_gateway_ip_address            : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_multicast_ip_address          : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_multicast_ip_mask             : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_udp_port                      : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_core_ctrl                     : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_core_type                     : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_phy_status_h                  : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_phy_status_l                  : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_tx_packet_rate                : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_tx_packet_count               : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_tx_valid_rate                 : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_tx_valid_count                : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_tx_overflow_count             : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_tx_almost_full_count          : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_rx_packet_rate                : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_rx_packet_count               : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_rx_valid_rate                 : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_rx_valid_count                : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_rx_overflow_count             : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_rx_almost_full_count          : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_rx_bad_packet_count           : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_arp_size                      : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_word_size                     : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_buffer_max_size               : out STD_LOGIC_VECTOR(31 downto 0);
        gmac_reg_count_reset                   : in STD_LOGIC_VECTOR(31 downto 0);

        gmac_arp_cache_write_enable            : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_arp_cache_read_enable             : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_arp_cache_write_data              : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_arp_cache_write_address           : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_arp_cache_read_address            : in STD_LOGIC_VECTOR(31 downto 0);
        gmac_arp_cache_read_data               : out STD_LOGIC_VECTOR(31 downto 0);
        -- am settings
        ctl_port_ctl_rx_custom_vl_length_minus1 : in STD_LOGIC_VECTOR(15 downto 0);
        ctl_port_ctl_tx_custom_vl_length_minus1 : in STD_LOGIC_VECTOR(15 downto 0);
        ctl_port_ctl_tx_vl_marker_id0           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id1           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id2           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id3           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id4           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id5           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id6           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id7           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id8           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id9           : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id10          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id11          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id12          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id13          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id14          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id15          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id16          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id17          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id18          : in STD_LOGIC_VECTOR(63 downto 0);
        ctl_port_ctl_tx_vl_marker_id19          : in STD_LOGIC_VECTOR(63 downto 0);
        gt0_ch01_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
        gt0_ch01_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt0_ch01_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
        gt0_ch01_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt0_ch01_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt0_ch23_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
        gt0_ch23_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt0_ch23_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
        gt0_ch23_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt0_ch23_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch01_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
        gt1_ch01_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch01_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch01_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch01_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch23_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
        gt1_ch23_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch23_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch23_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
        gt1_ch23_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0)

    );
end entity casper400gethernetblock_no_cpu;

architecture rtl of casper400gethernetblock_no_cpu is
    constant C_PR_SERVER_PORT           : natural range 0 to ((2**16) - 1) := 20000;
    constant C_ARP_CACHE_ASIZE          : natural                          := 10;
    constant C_CPU_TX_DATA_BUFFER_ASIZE : natural                          := 11;
    constant C_CPU_RX_DATA_BUFFER_ASIZE : natural                          := 11;
    constant C_ARP_DATA_WIDTH           : natural                          := 32;

    component udpipinterfacepr400g is
        generic(
            G_INCLUDE_ICAP               : boolean                          := false;
            G_AXIS_DATA_WIDTH            : natural                          := 1024;
            G_SLOT_WIDTH                 : natural                          := 4;
            -- Number of UDP Streaming Data Server Modules 
            G_NUM_STREAMING_DATA_SERVERS : natural range 1 to 4             := 1;
            G_ARP_CACHE_ASIZE            : natural                          := 10;
            G_ARP_DATA_WIDTH             : natural                          := 32;
            G_CPU_TX_DATA_BUFFER_ASIZE   : natural                          := 11;
            G_CPU_RX_DATA_BUFFER_ASIZE   : natural                          := 11;
            G_PR_SERVER_PORT             : natural range 0 to ((2**16) - 1) := 5
        );
        port(
            -- Axis clock is the Ethernet module clock running at 322.625MHz
            axis_clk                                     : in  STD_LOGIC;
            -- Aximm clock is the AXI Lite MM clock for the gmac register interface
            -- Usually 50MHz 
            aximm_clk                                    : in  STD_LOGIC;
            -- ICAP is the 125MHz ICAP clock used for PR
            icap_clk                                     : in  STD_LOGIC;
            -- Axis reset is the global synchronous reset to the highest clock
            axis_reset                                   : in  STD_LOGIC;
            ------------------------------------------------------------------------
            -- AXILite slave Interface                                            --
            -- This interface is for register access as per CASPER Ethernet Core  --
            -- memory map, this core has mac & phy registers, arp cache and also  --
            -- cpu transmit and receive buffers                                   --
            ------------------------------------------------------------------------
            aximm_gmac_reg_phy_control_h                 : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_phy_control_l                 : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_mac_address                   : in  STD_LOGIC_VECTOR(47 downto 0);
            aximm_gmac_reg_local_ip_address              : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_local_ip_netmask              : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_gateway_ip_address            : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_multicast_ip_address          : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_multicast_ip_mask             : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_udp_port                      : in  STD_LOGIC_VECTOR(15 downto 0);
            aximm_gmac_reg_udp_port_mask                 : in  STD_LOGIC_VECTOR(15 downto 0);
            aximm_gmac_reg_mac_enable                    : in  STD_LOGIC;
            aximm_gmac_reg_mac_promiscous_mode           : in  STD_LOGIC;
            aximm_gmac_reg_counters_reset                : in  STD_LOGIC;
            aximm_gmac_reg_core_type                     : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_phy_status_h                  : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_phy_status_l                  : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_packet_rate                : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_packet_count               : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_valid_rate                 : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_valid_count                : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_overflow_count             : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_afull_count                : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_packet_rate                : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_packet_count               : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_valid_rate                 : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_valid_count                : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_overflow_count             : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_almost_full_count          : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_bad_packet_count           : out STD_LOGIC_VECTOR(31 downto 0);
            --
            aximm_gmac_reg_arp_size                      : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_word_size                  : out STD_LOGIC_VECTOR(15 downto 0);
            aximm_gmac_reg_rx_word_size                  : out STD_LOGIC_VECTOR(15 downto 0);
            aximm_gmac_reg_tx_buffer_max_size            : out STD_LOGIC_VECTOR(15 downto 0);
            aximm_gmac_reg_rx_buffer_max_size            : out STD_LOGIC_VECTOR(15 downto 0);
            ------------------------------------------------------------------------
            -- ARP Cache Write Interface according to EthernetCore Memory MAP     --
            ------------------------------------------------------------------------ 
            aximm_gmac_arp_cache_write_enable            : in  STD_LOGIC;
            aximm_gmac_arp_cache_read_enable             : in  STD_LOGIC;
            aximm_gmac_arp_cache_write_data              : in  STD_LOGIC_VECTOR(G_ARP_DATA_WIDTH - 1 downto 0);
            aximm_gmac_arp_cache_read_data               : out STD_LOGIC_VECTOR(G_ARP_DATA_WIDTH - 1 downto 0);
            aximm_gmac_arp_cache_write_address           : in  STD_LOGIC_VECTOR(G_ARP_CACHE_ASIZE - 1 downto 0);
            aximm_gmac_arp_cache_read_address            : in  STD_LOGIC_VECTOR(G_ARP_CACHE_ASIZE - 1 downto 0);
            ------------------------------------------------------------------------
            -- Transmit Ring Buffer Interface according to EthernetCore Memory MAP--
            ------------------------------------------------------------------------ 
            aximm_gmac_tx_data_write_enable              : in  STD_LOGIC;
            aximm_gmac_tx_data_read_enable               : in  STD_LOGIC;
            aximm_gmac_tx_data_write_data                : in  STD_LOGIC_VECTOR(7 downto 0);
            -- The Byte Enable is as follows
            -- Bit (0-1) Byte Enables
            -- Bit (2) Maps to TLAST (To terminate the data stream).
            aximm_gmac_tx_data_write_byte_enable         : in  STD_LOGIC_VECTOR(1 downto 0);
            aximm_gmac_tx_data_read_data                 : out STD_LOGIC_VECTOR(7 downto 0);
            -- The Byte Enable is as follows
            -- Bit (0-1) Byte Enables
            -- Bit (2) Maps to TLAST (To terminate the data stream).
            aximm_gmac_tx_data_read_byte_enable          : out STD_LOGIC_VECTOR(1 downto 0);
            aximm_gmac_tx_data_write_address             : in  STD_LOGIC_VECTOR(G_CPU_TX_DATA_BUFFER_ASIZE - 1 downto 0);
            aximm_gmac_tx_data_read_address              : in  STD_LOGIC_VECTOR(G_CPU_TX_DATA_BUFFER_ASIZE - 1 downto 0);
            aximm_gmac_tx_ringbuffer_slot_id             : in  STD_LOGIC_VECTOR(G_SLOT_WIDTH - 1 downto 0);
            aximm_gmac_tx_ringbuffer_slot_set            : in  STD_LOGIC;
            aximm_gmac_tx_ringbuffer_slot_status         : out STD_LOGIC;
            aximm_gmac_tx_ringbuffer_number_slots_filled : out STD_LOGIC_VECTOR(G_SLOT_WIDTH - 1 downto 0);
            ------------------------------------------------------------------------
            -- Receive Ring Buffer Interface according to EthernetCore Memory MAP --
            ------------------------------------------------------------------------ 
            aximm_gmac_rx_data_read_enable               : in  STD_LOGIC;
            aximm_gmac_rx_data_read_data                 : out STD_LOGIC_VECTOR(7 downto 0);
            -- The Byte Enable is as follows
            -- Bit (0-1) Byte Enables
            -- Bit (2) Maps to TLAST (To terminate the data stream).        
            aximm_gmac_rx_data_read_byte_enable          : out STD_LOGIC_VECTOR(1 downto 0);
            aximm_gmac_rx_data_read_address              : in  STD_LOGIC_VECTOR(G_CPU_RX_DATA_BUFFER_ASIZE - 1 downto 0);
            aximm_gmac_rx_ringbuffer_slot_id             : in  STD_LOGIC_VECTOR(G_SLOT_WIDTH - 1 downto 0);
            aximm_gmac_rx_ringbuffer_slot_clear          : in  STD_LOGIC;
            aximm_gmac_rx_ringbuffer_slot_status         : out STD_LOGIC;
            aximm_gmac_rx_ringbuffer_number_slots_filled : out STD_LOGIC_VECTOR(G_SLOT_WIDTH - 1 downto 0);
            ------------------------------------------------------------------------
            -- Yellow Block Data Interface                                        --
            -- These can be many AXIS interfaces denoted by axis_data{n}_tx/rx    --
            -- where {n} = G_NUM_STREAMING_DATA_SERVERS.                          --
            -- Each of them run on their own clock.                               --
            -- Aggregate data rate for all modules combined must be less than 100G--                                --
            -- Each module in a PR configuration makes a PR boundary.             --
            ------------------------------------------------------------------------
            -- Streaming data clocks 
            axis_streaming_data_clk                      : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_rx_packet_length        : out STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);         
            -- Streaming data outputs to AXIS of the Yellow Blocks
            axis_streaming_data_rx_tdata                 : out STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_rx_tvalid                : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_rx_tready                : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_rx_tkeep                 : out STD_LOGIC_VECTOR(((G_AXIS_DATA_WIDTH / 8) * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_rx_tlast                 : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_rx_tuser                 : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            --Data inputs from AXIS bus of the Yellow Blocks
            axis_streaming_data_tx_destination_ip        : in  STD_LOGIC_VECTOR((32 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_destination_udp_port  : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_source_udp_port       : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_packet_length         : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);                             
            axis_streaming_data_tx_tdata                 : in  STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tvalid                : in  STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tuser                 : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_tx_tkeep                 : in  STD_LOGIC_VECTOR(((G_AXIS_DATA_WIDTH / 8) * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tlast                 : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_tx_tready                : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            ------------------------------------------------------------------------
            -- Ethernet MAC/PHY Control and Statistics Interface                  --
            ------------------------------------------------------------------------
            gmac_reg_core_type                           : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_status_h                        : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_status_l                        : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_control_h                       : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_control_l                       : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_packet_rate                      : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_packet_count                     : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_valid_rate                       : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_valid_count                      : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_packet_rate                      : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_packet_count                     : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_valid_rate                       : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_valid_count                      : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_bad_packet_count                 : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_counters_reset                      : out STD_LOGIC;
            gmac_reg_mac_enable                          : out STD_LOGIC;
            ------------------------------------------------------------------------
            -- Ethernet MAC Streaming Interface                                   --
            ------------------------------------------------------------------------
            -- Outputs to AXIS bus MAC side 
            axis_tx_tdata                                : out STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_tx_tvalid                               : out STD_LOGIC;
            axis_tx_tready                               : in  STD_LOGIC;
            axis_tx_tkeep                                : out STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_tx_tlast                                : out STD_LOGIC;
            axis_tx_tuser                                : out STD_LOGIC;
            --Inputs from AXIS bus of the MAC side
            axis_rx_tdata                                : in  STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_rx_tvalid                               : in  STD_LOGIC;
            axis_rx_tuser                                : in  STD_LOGIC;
            axis_rx_tkeep                                : in  STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_rx_tlast                                : in  STD_LOGIC
        );
    end component udpipinterfacepr400g;

    component mac400gphy is
        generic(
            C_MAC_INSTANCE : natural range 0 to 3 := 0;
            C_USE_RS_FEC : boolean := false;
            C_N_COMMON : natural range 1 to 2 := 1
        );
        port(
            -- Ethernet reference clock for 156.25MHz
            -- We need 2 quads for the 400G Ethernet by default.
            gt_clk0_p                    : in  STD_LOGIC;
            gt_clk0_n                    : in  STD_LOGIC;
            gt_clk1_p                    : in  STD_LOGIC;
            gt_clk1_n                    : in  STD_LOGIC; 
            --RX     
            gt0_rx_p                     : in  STD_LOGIC_VECTOR(3 downto 0);
            gt0_rx_n                     : in  STD_LOGIC_VECTOR(3 downto 0); 
            gt1_rx_p                     : in  STD_LOGIC_VECTOR(3 downto 0);
            gt1_rx_n                     : in  STD_LOGIC_VECTOR(3 downto 0);
            -- TX
            gt0_tx_p                     : out STD_LOGIC_VECTOR(3 downto 0);
            gt0_tx_n                     : out STD_LOGIC_VECTOR(3 downto 0);
            gt1_tx_p                     : out STD_LOGIC_VECTOR(3 downto 0);
            gt1_tx_n                     : out STD_LOGIC_VECTOR(3 downto 0);
            ------------------------------------------------------------------------
            -- These signals/buses run at 390.625MHz clock domain                  -
            ------------------------------------------------------------------------
            -- Global System Enable
            Enable                       : in  STD_LOGIC;
            Reset                        : in  STD_LOGIC;
            DataRateBackOff              : out STD_LOGIC;
            -- incoming packet filters
            fabric_mac                   : in STD_LOGIC_VECTOR(47 downto 0);
            fabric_ip                    : in STD_LOGIC_VECTOR(31 downto 0);
            fabric_port                  : in STD_LOGIC_VECTOR(15 downto 0);
            -- Statistics interface
            gmac_reg_core_type           : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_status_h        : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_status_l        : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_control_h       : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_phy_control_l       : in  STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_packet_rate      : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_packet_count     : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_valid_rate       : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_tx_valid_count      : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_packet_rate      : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_packet_count     : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_valid_rate       : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_valid_count      : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_rx_bad_packet_count : out STD_LOGIC_VECTOR(31 downto 0);
            gmac_reg_counters_reset      : in  STD_LOGIC;
            -- Lbus and AXIS
            lbus_reset                   : in  STD_LOGIC;
            -- Overflow signal
            lbus_tx_ovfout               : out STD_LOGIC;
            -- Underflow signal
            lbus_tx_unfout               : out STD_LOGIC;
            -- AXIS Bus
            -- RX Bus
            axis_rx_clkin                : in  STD_LOGIC;
            axis_rx_tdata                : in  STD_LOGIC_VECTOR(1023 downto 0);
            axis_rx_tvalid               : in  STD_LOGIC;
            axis_rx_tready               : out STD_LOGIC;
            axis_rx_tkeep                : in  STD_LOGIC_VECTOR(127 downto 0);
            axis_rx_tlast                : in  STD_LOGIC;
            axis_rx_tuser                : in  STD_LOGIC;
            -- TX Bus
            axis_tx_clkout               : out STD_LOGIC;
            axis_tx_tdata                : out STD_LOGIC_VECTOR(1023 downto 0);
            axis_tx_tvalid               : out STD_LOGIC;
            axis_tx_tkeep                : out STD_LOGIC_VECTOR(127 downto 0);
            axis_tx_tlast                : out STD_LOGIC;
            -- User signal for errors and dropping of packets
            axis_tx_tuser                : out STD_LOGIC;
            yellow_block_user_clk        : in STD_LOGIC;
            yellow_block_rx_data         : out  STD_LOGIC_VECTOR(1023 downto 0);
            yellow_block_rx_valid        : out  STD_LOGIC;
            yellow_block_rx_eof          : out  STD_LOGIC;
            yellow_block_rx_overrun      : out STD_LOGIC;
             -- GTM transceiver config
             axi4_lite_aclk               : in STD_LOGIC;
             axi4_lite_araddr             : in STD_LOGIC_VECTOR(31 downto 0);
             axi4_lite_aresetn            : in STD_LOGIC;
             axi4_lite_arready            : out STD_LOGIC;
             axi4_lite_arvalid            : in STD_LOGIC;
             axi4_lite_awaddr             : in STD_LOGIC_VECTOR(31 downto 0);
             axi4_lite_awready            : out STD_LOGIC;
             axi4_lite_awvalid            : in STD_LOGIC;
             axi4_lite_bready             : in STD_LOGIC;
             axi4_lite_bresp              : out STD_LOGIC_VECTOR(1 downto 0);
             axi4_lite_bvalid             : out STD_LOGIC;
             axi4_lite_rdata              : out STD_LOGIC_VECTOR(31 downto 0);
             axi4_lite_rready             : in STD_LOGIC;
             axi4_lite_rresp              : out STD_LOGIC_VECTOR(1 downto 0);
             axi4_lite_rvalid             : out STD_LOGIC; 
             axi4_lite_wdata              : in STD_LOGIC_VECTOR(31 downto 0);
             axi4_lite_wready             : out STD_LOGIC;
             axi4_lite_wvalid             : in STD_LOGIC; 
            -- DCMAC core config/rst interfaces
            -- axi interface for DCMAC core configuration
            s_axi_aclk                   : in  STD_LOGIC;    
            s_axi_aresetn                : in  STD_LOGIC;
            s_axi_awaddr                 : in  STD_LOGIC_VECTOR(31 downto 0);
            s_axi_awvalid                : in  STD_LOGIC;
            s_axi_awready                : out STD_LOGIC;
            s_axi_wdata                  : in  STD_LOGIC_VECTOR(31 downto 0);
            s_axi_wvalid                 : in  STD_LOGIC;
            s_axi_wready                 : out STD_LOGIC;
            s_axi_bresp                  : out STD_LOGIC_VECTOR(1 downto 0);
            s_axi_bvalid                 : out STD_LOGIC;
            s_axi_bready                 : in  STD_LOGIC;
            s_axi_araddr                 : in  STD_LOGIC_VECTOR(31 downto 0);
            s_axi_arvalid                : in  STD_LOGIC;
            s_axi_arready                : out STD_LOGIC;
            s_axi_rdata                  : out STD_LOGIC_VECTOR(31 downto 0);
            s_axi_rresp                  : out STD_LOGIC_VECTOR(1 downto 0);
            s_axi_rvalid                 : out STD_LOGIC;
            s_axi_rready                 : in  STD_LOGIC;
            -- GT control signals
            gt_rxcdrhold                 : in  STD_LOGIC;
            gt_txprecursor               : in  STD_LOGIC_VECTOR(5 downto 0);
            gt_txpostcursor              : in  STD_LOGIC_VECTOR(5 downto 0);
            gt_txmaincursor              : in  STD_LOGIC_VECTOR(6 downto 0);
            gt_loopback                  : in  STD_LOGIC_VECTOR(2 downto 0);
            gt_line_rate                 : in  STD_LOGIC_VECTOR(7 downto 0);
            gt_reset_all_in              : in  STD_LOGIC;
            -- TX & RX datapath
            gt_reset_tx_datapath_in      : in  STD_LOGIC_VECTOR(7 downto 0);
            gt_reset_rx_datapath_in      : in  STD_LOGIC_VECTOR(7 downto 0);
            -- reset_dyn
            rx_core_reset                : in  STD_LOGIC;
            rx_serdes_reset              : in  STD_LOGIC_VECTOR(5 downto 0);
            tx_core_reset                : in  STD_LOGIC;
            tx_serdes_reset              : in  STD_LOGIC_VECTOR(5 downto 0);
            -- reset_done_dyn
            gt_tx_reset_done_out         : out STD_LOGIC_VECTOR(7 downto 0);
            gt_rx_reset_done_out         : out STD_LOGIC_VECTOR(7 downto 0);
            -- am settings
            ctl_port_ctl_rx_custom_vl_length_minus1 : in STD_LOGIC_VECTOR(15 downto 0);
            ctl_port_ctl_tx_custom_vl_length_minus1 : in STD_LOGIC_VECTOR(15 downto 0);
            ctl_port_ctl_tx_vl_marker_id0           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id1           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id2           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id3           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id4           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id5           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id6           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id7           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id8           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id9           : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id10          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id11          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id12          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id13          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id14          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id15          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id16          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id17          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id18          : in STD_LOGIC_VECTOR(63 downto 0);
            ctl_port_ctl_tx_vl_marker_id19          : in STD_LOGIC_VECTOR(63 downto 0);
            gt0_ch01_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
            gt0_ch01_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt0_ch01_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
            gt0_ch01_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt0_ch01_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt0_ch23_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
            gt0_ch23_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt0_ch23_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
            gt0_ch23_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt0_ch23_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch01_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
            gt1_ch01_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch01_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch01_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch01_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch23_txmaincursor                   : in  STD_LOGIC_VECTOR(6 downto 0);
            gt1_ch23_txpostcursor                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch23_txprecursor                    : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch23_txprecursor2                   : in  STD_LOGIC_VECTOR(5 downto 0);
            gt1_ch23_txprecursor3                   : in  STD_LOGIC_VECTOR(5 downto 0)
        );
    end component mac400gphy;

    signal Reset          : std_logic;
    signal lbus_tx_ovfout : std_logic;
    signal lbus_tx_unfout : std_logic;

    signal ClkQSFP : std_logic;

    signal axis_rx_tdata  : STD_LOGIC_VECTOR(1023 downto 0);
    signal axis_rx_tvalid : STD_LOGIC;
    signal axis_rx_tkeep  : STD_LOGIC_VECTOR(127 downto 0);
    signal axis_rx_tlast  : STD_LOGIC;
    signal axis_rx_tuser  : STD_LOGIC;

    signal axis_tx_tdata  : STD_LOGIC_VECTOR(1023 downto 0);
    signal axis_tx_tvalid : STD_LOGIC;
    signal axis_tx_tkeep  : STD_LOGIC_VECTOR(127 downto 0);
    signal axis_tx_tlast  : STD_LOGIC;
    signal axis_tx_tready : STD_LOGIC;
    signal axis_tx_tuser  : STD_LOGIC;


    signal udp_gmac_reg_core_type           : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_phy_status_h        : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_phy_status_l        : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_phy_control_h       : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_phy_control_l       : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_tx_packet_rate      : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_tx_packet_count     : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_tx_valid_rate       : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_tx_valid_count      : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_rx_packet_rate      : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_rx_packet_count     : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_rx_valid_rate       : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_rx_valid_count      : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_rx_bad_packet_count : STD_LOGIC_VECTOR(31 downto 0);
    signal udp_gmac_reg_counters_reset      : STD_LOGIC;
    signal udp_gmac_reg_mac_enable          : STD_LOGIC;
    
    signal fabric_mac : STD_LOGIC_VECTOR(47 downto 0);

begin
    Reset <=  axis_reset;

    ----------------------------------------------------------------------------
    --               Generic OSFP port configuration settings.                --
    ----------------------------------------------------------------------------
    --                             OSFP+ port 1                               --       
    -- This port is used for all Ethernet communications and is the main port.--       
    ----------------------------------------------------------------------------    
    -- Dont set module to low power mode
    qsfp_lpmode_ls  <= '0';
    -- Dont select the module
    qsfp_modsell_ls <= '1';
    -- Keep the module out of reset    
    qsfp_resetl_ls  <= (not Reset);
    -- Construct mac address
    fabric_mac <= gmac_reg_mac_address_h(15 downto 0) & gmac_reg_mac_address_l(31 downto 0);
    axis_clk_out    <= ClkQSFP;
    ----------------------------------------------------------------------------
    --          OSFP DCMAC0 400G MAC Instance (port 1)                        --
    -- The DCMAC resides in the static partition of the design.               --
    -- This is the main data port on the design.                              -- 
    ----------------------------------------------------------------------------
    DCMAC_i : mac400gphy
        generic map(
            C_MAC_INSTANCE => G_MAC_INSTANCE,
            C_USE_RS_FEC => G_USE_RS_FEC,
            C_N_COMMON  => G_N_COMMON
        )
        port map(
            Enable                       => udp_gmac_reg_mac_enable,
            Reset                        => Reset,
            fabric_mac                   => fabric_mac,
            fabric_ip                    => gmac_reg_local_ip_address,
            fabric_port                  => gmac_reg_udp_port(15 downto 0),
            gmac_reg_core_type           => udp_gmac_reg_core_type,
            gmac_reg_phy_status_h        => udp_gmac_reg_phy_status_h,
            gmac_reg_phy_status_l        => udp_gmac_reg_phy_status_l,
            gmac_reg_phy_control_h       => udp_gmac_reg_phy_control_h,
            gmac_reg_phy_control_l       => udp_gmac_reg_phy_control_l,
            gmac_reg_tx_packet_rate      => udp_gmac_reg_tx_packet_rate,
            gmac_reg_tx_packet_count     => udp_gmac_reg_tx_packet_count,
            gmac_reg_tx_valid_rate       => udp_gmac_reg_tx_valid_rate,
            gmac_reg_tx_valid_count      => udp_gmac_reg_tx_valid_count,
            gmac_reg_rx_packet_rate      => udp_gmac_reg_rx_packet_rate,
            gmac_reg_rx_packet_count     => udp_gmac_reg_rx_packet_count,
            gmac_reg_rx_valid_rate       => udp_gmac_reg_rx_valid_rate,
            gmac_reg_rx_valid_count      => udp_gmac_reg_rx_valid_count,
            gmac_reg_rx_bad_packet_count => udp_gmac_reg_rx_bad_packet_count,
            gmac_reg_counters_reset      => udp_gmac_reg_counters_reset,
            gt_clk0_p                    => gt_clk0_p,
            gt_clk0_n                    => gt_clk0_n,
            gt_clk1_p                    => gt_clk1_p,
            gt_clk1_n                    => gt_clk1_n,   
            gt0_rx_p                     => gt0_rx_p,
            gt0_rx_n                     => gt0_rx_n, 
            gt1_rx_p                     => gt1_rx_p,
            gt1_rx_n                     => gt1_rx_n,
            gt0_tx_p                     => gt0_tx_p,
            gt0_tx_n                     => gt0_tx_n,
            gt1_tx_p                     => gt1_tx_p,
            gt1_tx_n                     => gt1_tx_n,
            axis_tx_clkout               => ClkQSFP,
            axis_rx_clkin                => ClkQSFP,
            lbus_tx_ovfout               => lbus_tx_ovfout,
            lbus_tx_unfout               => lbus_tx_unfout,
            lbus_reset                   => Reset,
            axis_rx_tdata                => axis_tx_tdata,
            axis_rx_tvalid               => axis_tx_tvalid,
            axis_rx_tready               => axis_tx_tready,
            axis_rx_tkeep                => axis_tx_tkeep,
            axis_rx_tlast                => axis_tx_tlast,
            axis_rx_tuser                => axis_tx_tuser,
            axis_tx_tdata                => axis_rx_tdata,
            axis_tx_tvalid               => axis_rx_tvalid,
            axis_tx_tkeep                => axis_rx_tkeep,
            axis_tx_tlast                => axis_rx_tlast,
            axis_tx_tuser                => axis_rx_tuser,
            yellow_block_user_clk        => axis_streaming_data_clk(0),
            yellow_block_rx_data         => yellow_block_rx_data,
            yellow_block_rx_valid        => yellow_block_rx_valid,
            yellow_block_rx_eof          => yellow_block_rx_eof,
            yellow_block_rx_overrun      => yellow_block_rx_overrun,
            -- GTM Transceivers config
            axi4_lite_aclk               => axi4_lite_aclk,
            axi4_lite_araddr             => axi4_lite_araddr,
            axi4_lite_aresetn            => axi4_lite_aresetn,
            axi4_lite_arready            => axi4_lite_arready,
            axi4_lite_arvalid            => axi4_lite_arvalid,
            axi4_lite_awaddr             => axi4_lite_awaddr,
            axi4_lite_awready            => axi4_lite_awready,
            axi4_lite_awvalid            => axi4_lite_awvalid,
            axi4_lite_bready             => axi4_lite_bready,
            axi4_lite_bresp              => axi4_lite_bresp,
            axi4_lite_bvalid             => axi4_lite_bvalid,
            axi4_lite_rdata              => axi4_lite_rdata,
            axi4_lite_rready             => axi4_lite_rready,
            axi4_lite_rresp              => axi4_lite_rresp,
            axi4_lite_rvalid             => axi4_lite_rvalid, 
            axi4_lite_wdata              => axi4_lite_wdata,
            axi4_lite_wready             => axi4_lite_wready,
            axi4_lite_wvalid             => axi4_lite_wvalid, 
            -- DCMAC core config/rst interfaces
            -- axi interface for DCMAC core configuration
            s_axi_aclk                   => s_axi_aclk,       
            s_axi_aresetn                => s_axi_aresetn,
            s_axi_awaddr                 => s_axi_awaddr,
            s_axi_awvalid                => s_axi_awvalid,
            s_axi_awready                => s_axi_awready,
            s_axi_wdata                  => s_axi_wdata,
            s_axi_wvalid                 => s_axi_wvalid,
            s_axi_wready                 => s_axi_wready,
            s_axi_bresp                  => s_axi_bresp,
            s_axi_bvalid                 => s_axi_bvalid,
            s_axi_bready                 => s_axi_bready,
            s_axi_araddr                 => s_axi_araddr,
            s_axi_arvalid                => s_axi_arvalid,
            s_axi_arready                => s_axi_arready,
            s_axi_rdata                  => s_axi_rdata,
            s_axi_rresp                  => s_axi_rresp,
            s_axi_rvalid                 => s_axi_rvalid,
            s_axi_rready                 => s_axi_rready,
            -- GT control signals
            gt_rxcdrhold                 => gt_rxcdrhold,
            gt_txprecursor               => gt_txprecursor,
            gt_txpostcursor              => gt_txpostcursor,
            gt_txmaincursor              => gt_txmaincursor,
            gt_loopback                  => gt_loopback,
            gt_line_rate                 => gt_line_rate,
            gt_reset_all_in              => gt_reset_all_in,
            -- TX & RX datapath
            gt_reset_tx_datapath_in      => gt_reset_tx_datapath_in,
            gt_reset_rx_datapath_in      => gt_reset_rx_datapath_in,
            -- reset_dyn
            rx_core_reset                => rx_core_reset,
            rx_serdes_reset              => rx_serdes_reset,
            tx_core_reset                => tx_core_reset,
            tx_serdes_reset              => tx_serdes_reset,
            -- reset_done_dyn
            gt_tx_reset_done_out         => gt_tx_reset_done_out,
            gt_rx_reset_done_out         => gt_rx_reset_done_out,
            -- am settings
            ctl_port_ctl_rx_custom_vl_length_minus1 => ctl_port_ctl_rx_custom_vl_length_minus1,
            ctl_port_ctl_tx_custom_vl_length_minus1 => ctl_port_ctl_tx_custom_vl_length_minus1,
            ctl_port_ctl_tx_vl_marker_id0           => ctl_port_ctl_tx_vl_marker_id0,
            ctl_port_ctl_tx_vl_marker_id1           => ctl_port_ctl_tx_vl_marker_id1,
            ctl_port_ctl_tx_vl_marker_id2           => ctl_port_ctl_tx_vl_marker_id2,
            ctl_port_ctl_tx_vl_marker_id3           => ctl_port_ctl_tx_vl_marker_id3,
            ctl_port_ctl_tx_vl_marker_id4           => ctl_port_ctl_tx_vl_marker_id4,
            ctl_port_ctl_tx_vl_marker_id5           => ctl_port_ctl_tx_vl_marker_id5,
            ctl_port_ctl_tx_vl_marker_id6           => ctl_port_ctl_tx_vl_marker_id6,
            ctl_port_ctl_tx_vl_marker_id7           => ctl_port_ctl_tx_vl_marker_id7,
            ctl_port_ctl_tx_vl_marker_id8           => ctl_port_ctl_tx_vl_marker_id8,
            ctl_port_ctl_tx_vl_marker_id9           => ctl_port_ctl_tx_vl_marker_id9,
            ctl_port_ctl_tx_vl_marker_id10          => ctl_port_ctl_tx_vl_marker_id10,
            ctl_port_ctl_tx_vl_marker_id11          => ctl_port_ctl_tx_vl_marker_id11,
            ctl_port_ctl_tx_vl_marker_id12          => ctl_port_ctl_tx_vl_marker_id12,
            ctl_port_ctl_tx_vl_marker_id13          => ctl_port_ctl_tx_vl_marker_id13,
            ctl_port_ctl_tx_vl_marker_id14          => ctl_port_ctl_tx_vl_marker_id14,
            ctl_port_ctl_tx_vl_marker_id15          => ctl_port_ctl_tx_vl_marker_id15,
            ctl_port_ctl_tx_vl_marker_id16          => ctl_port_ctl_tx_vl_marker_id16,
            ctl_port_ctl_tx_vl_marker_id17          => ctl_port_ctl_tx_vl_marker_id17,
            ctl_port_ctl_tx_vl_marker_id18          => ctl_port_ctl_tx_vl_marker_id18,
            ctl_port_ctl_tx_vl_marker_id19          => ctl_port_ctl_tx_vl_marker_id19,
            gt0_ch01_txmaincursor                   => gt0_ch01_txmaincursor,
            gt0_ch01_txpostcursor                   => gt0_ch01_txpostcursor,
            gt0_ch01_txprecursor                    => gt0_ch01_txprecursor,
            gt0_ch01_txprecursor2                   => gt0_ch01_txprecursor2,
            gt0_ch01_txprecursor3                   => gt0_ch01_txprecursor3,
            gt0_ch23_txmaincursor                   => gt0_ch23_txmaincursor,
            gt0_ch23_txpostcursor                   => gt0_ch23_txpostcursor,
            gt0_ch23_txprecursor                    => gt0_ch23_txprecursor,
            gt0_ch23_txprecursor2                   => gt0_ch23_txprecursor2,
            gt0_ch23_txprecursor3                   => gt0_ch23_txprecursor3,
            gt1_ch01_txmaincursor                   => gt1_ch01_txmaincursor,
            gt1_ch01_txpostcursor                   => gt1_ch01_txpostcursor,
            gt1_ch01_txprecursor                    => gt1_ch01_txprecursor,
            gt1_ch01_txprecursor2                   => gt1_ch01_txprecursor2,
            gt1_ch01_txprecursor3                   => gt1_ch01_txprecursor3,
            gt1_ch23_txmaincursor                   => gt1_ch23_txmaincursor,
            gt1_ch23_txpostcursor                   => gt1_ch23_txpostcursor,
            gt1_ch23_txprecursor                    => gt1_ch23_txprecursor,
            gt1_ch23_txprecursor2                   => gt1_ch23_txprecursor2,
            gt1_ch23_txprecursor3                   => gt1_ch23_txprecursor3
        );

    ----------------------------------------------------------------------------
    --                 Ethernet UDP/IP Communications module                  --
    -- The UDP/IP module resides in the static partition of the design.       --
    -- This module implements all UDP/IP  communications.                     --
    -- This module supports 9600 jumbo frame packets.                         --
    -- The  module depends on CPU for configuration settings and 100gmac      --    
    -- When C_INCLUDE_ICAP = true partial reconfiguration over UDP is enabled.--
    -- The module gets and sends streaming data using the module apps.        --
    -- All DSP high speed streaming data is connected to this module.         --
    -- To facilitate reaching maximum bandwidth several streaming apps can be --
    -- connected to the module as data sources/sinks.                         --     
    ----------------------------------------------------------------------------
    UDPIPIFFi : udpipinterfacepr400g
        generic map(
            G_INCLUDE_ICAP               => G_INCLUDE_ICAP,
            G_AXIS_DATA_WIDTH            => G_AXIS_DATA_WIDTH,
            G_SLOT_WIDTH                 => G_SLOT_WIDTH,
            -- Number of UDP Streaming Data Server Modules 
            G_NUM_STREAMING_DATA_SERVERS => G_NUM_STREAMING_DATA_SERVERS,
            G_ARP_CACHE_ASIZE            => C_ARP_CACHE_ASIZE,
            G_ARP_DATA_WIDTH             => C_ARP_DATA_WIDTH,
            G_CPU_TX_DATA_BUFFER_ASIZE   => C_CPU_TX_DATA_BUFFER_ASIZE,
            G_CPU_RX_DATA_BUFFER_ASIZE   => C_CPU_RX_DATA_BUFFER_ASIZE,
            G_PR_SERVER_PORT             => C_PR_SERVER_PORT
        )
        port map(
            axis_clk                                     => ClkQSFP,
            -- Running Microblaze at 125MHz used for ICAP Clocking
            aximm_clk                                    => aximm_clk,
            icap_clk                                     => icap_clk,
            axis_reset                                   => Reset,
            aximm_gmac_reg_phy_control_h                 => gmac_reg_phy_control_h,
            aximm_gmac_reg_phy_control_l                 => gmac_reg_phy_control_l,
            aximm_gmac_reg_mac_address(31 downto 0)      => gmac_reg_mac_address_l,
            aximm_gmac_reg_mac_address(47 downto 32)     => gmac_reg_mac_address_h(15 downto 0),
            aximm_gmac_reg_local_ip_address              => gmac_reg_local_ip_address,
            aximm_gmac_reg_local_ip_netmask              => gmac_reg_local_ip_netmask,
            aximm_gmac_reg_gateway_ip_address            => gmac_reg_gateway_ip_address,
            aximm_gmac_reg_multicast_ip_address          => gmac_reg_multicast_ip_address,
            aximm_gmac_reg_multicast_ip_mask             => gmac_reg_multicast_ip_mask,
            aximm_gmac_reg_udp_port                      => gmac_reg_udp_port(15 downto 0),
            aximm_gmac_reg_udp_port_mask                 => gmac_reg_udp_port(31 downto 16),
            aximm_gmac_reg_mac_enable                    => gmac_reg_core_ctrl(0),
            aximm_gmac_reg_mac_promiscous_mode           => gmac_reg_core_ctrl(8),
            aximm_gmac_reg_counters_reset                => gmac_reg_count_reset(0),
            aximm_gmac_reg_core_type                     => gmac_reg_core_type,
            aximm_gmac_reg_phy_status_h                  => gmac_reg_phy_status_h,
            aximm_gmac_reg_phy_status_l                  => gmac_reg_phy_status_l,
            aximm_gmac_reg_tx_packet_rate                => gmac_reg_tx_packet_rate,
            aximm_gmac_reg_tx_packet_count               => gmac_reg_tx_packet_count,
            aximm_gmac_reg_tx_valid_rate                 => gmac_reg_tx_valid_rate,
            aximm_gmac_reg_tx_valid_count                => gmac_reg_tx_valid_count,
            aximm_gmac_reg_tx_overflow_count             => gmac_reg_tx_overflow_count,
            aximm_gmac_reg_tx_afull_count                => gmac_reg_tx_almost_full_count,
            aximm_gmac_reg_rx_packet_rate                => gmac_reg_rx_packet_rate,
            aximm_gmac_reg_rx_packet_count               => gmac_reg_rx_packet_count,
            aximm_gmac_reg_rx_valid_rate                 => gmac_reg_rx_valid_rate,
            aximm_gmac_reg_rx_valid_count                => gmac_reg_rx_valid_count,
            aximm_gmac_reg_rx_overflow_count             => gmac_reg_rx_overflow_count,
            aximm_gmac_reg_rx_almost_full_count          => gmac_reg_rx_almost_full_count,
            aximm_gmac_reg_rx_bad_packet_count           => gmac_reg_rx_bad_packet_count,
            aximm_gmac_reg_arp_size                      => gmac_reg_arp_size,
            aximm_gmac_reg_tx_word_size                  => gmac_reg_word_size(31 downto 16),
            aximm_gmac_reg_rx_word_size                  => gmac_reg_word_size(15 downto 0),
            aximm_gmac_reg_tx_buffer_max_size            => gmac_reg_buffer_max_size(31 downto 16),
            aximm_gmac_reg_rx_buffer_max_size            => gmac_reg_buffer_max_size(15 downto 0),
            aximm_gmac_arp_cache_write_enable            => gmac_arp_cache_write_enable(0),
            aximm_gmac_arp_cache_read_enable             => gmac_arp_cache_read_enable(0),
            aximm_gmac_arp_cache_write_data              => gmac_arp_cache_write_data,
            aximm_gmac_arp_cache_read_data               => gmac_arp_cache_read_data,
            aximm_gmac_arp_cache_write_address           => gmac_arp_cache_write_address(C_ARP_CACHE_ASIZE - 1 downto 0),
            aximm_gmac_arp_cache_read_address            => gmac_arp_cache_read_address(C_ARP_CACHE_ASIZE - 1 downto 0),
            aximm_gmac_tx_data_write_enable              => '0', --gmac_tx_data_write_enable,
            aximm_gmac_tx_data_read_enable               => '0', --gmac_tx_data_read_enable,
            aximm_gmac_tx_data_write_data                => x"00", --gmac_tx_data_write_data,
            aximm_gmac_tx_data_write_byte_enable         => b"00", --gmac_tx_data_write_byte_enable,
            aximm_gmac_tx_data_read_data                 => open, --gmac_tx_data_read_data,
            aximm_gmac_tx_data_read_byte_enable          => open, --gmac_tx_data_read_byte_enable,
            aximm_gmac_tx_data_write_address             => (others => '0'), --gmac_tx_data_write_address,
            aximm_gmac_tx_data_read_address              => (others => '0'), --gmac_tx_data_read_address,
            aximm_gmac_tx_ringbuffer_slot_id             => (others => '0'), --gmac_tx_ringbuffer_slot_id,
            aximm_gmac_tx_ringbuffer_slot_set            => '0', --gmac_tx_ringbuffer_slot_set,
            aximm_gmac_tx_ringbuffer_slot_status         => open, --gmac_tx_ringbuffer_slot_status,
            aximm_gmac_tx_ringbuffer_number_slots_filled => open, --gmac_tx_ringbuffer_number_slots_filled,
            aximm_gmac_rx_data_read_enable               => '1', --gmac_rx_data_read_enable,
            aximm_gmac_rx_data_read_data                 => open, --gmac_rx_data_read_data,
            aximm_gmac_rx_data_read_byte_enable          => open, --gmac_rx_data_read_byte_enable,
            aximm_gmac_rx_data_read_address              => (others => '0'), --gmac_rx_data_read_address,
            aximm_gmac_rx_ringbuffer_slot_id             => (others => '0'), --gmac_rx_ringbuffer_slot_id,
            aximm_gmac_rx_ringbuffer_slot_clear          => '0', --gmac_rx_ringbuffer_slot_clear,
            aximm_gmac_rx_ringbuffer_slot_status         => open, --gmac_rx_ringbuffer_slot_status,
            aximm_gmac_rx_ringbuffer_number_slots_filled => open, --gmac_rx_ringbuffer_number_slots_filled,
            axis_streaming_data_clk                      => axis_streaming_data_clk,
            axis_streaming_data_rx_packet_length         => axis_streaming_data_rx_packet_length,                 
            axis_streaming_data_rx_tdata                 => open,--axis_streaming_data_rx_tdata,
            axis_streaming_data_rx_tvalid                => open,--axis_streaming_data_rx_tvalid,
            axis_streaming_data_rx_tready                => (others => '0'),--axis_streaming_data_rx_tready,
            axis_streaming_data_rx_tkeep                 => open,--axis_streaming_data_rx_tkeep,
            axis_streaming_data_rx_tlast                 => open,--axis_streaming_data_rx_tlast,
            axis_streaming_data_rx_tuser                 => open,--axis_streaming_data_rx_tuser,
            axis_streaming_data_tx_destination_ip        => axis_streaming_data_tx_destination_ip,
            axis_streaming_data_tx_destination_udp_port  => axis_streaming_data_tx_destination_udp_port,
            axis_streaming_data_tx_source_udp_port       => axis_streaming_data_tx_source_udp_port,
            axis_streaming_data_tx_packet_length         => axis_streaming_data_tx_packet_length,                 
            axis_streaming_data_tx_tdata                 => axis_streaming_data_tx_tdata,
            axis_streaming_data_tx_tvalid                => axis_streaming_data_tx_tvalid,
            axis_streaming_data_tx_tuser                 => axis_streaming_data_tx_tuser,
            axis_streaming_data_tx_tkeep                 => axis_streaming_data_tx_tkeep,
            axis_streaming_data_tx_tlast                 => axis_streaming_data_tx_tlast,
            axis_streaming_data_tx_tready                => axis_streaming_data_tx_tready,
            gmac_reg_core_type                           => udp_gmac_reg_core_type,
            gmac_reg_phy_status_h                        => udp_gmac_reg_phy_status_h,
            gmac_reg_phy_status_l                        => udp_gmac_reg_phy_status_l,
            gmac_reg_phy_control_h                       => udp_gmac_reg_phy_control_h,
            gmac_reg_phy_control_l                       => udp_gmac_reg_phy_control_l,
            gmac_reg_tx_packet_rate                      => udp_gmac_reg_tx_packet_rate,
            gmac_reg_tx_packet_count                     => udp_gmac_reg_tx_packet_count,
            gmac_reg_tx_valid_rate                       => udp_gmac_reg_tx_valid_rate,
            gmac_reg_tx_valid_count                      => udp_gmac_reg_tx_valid_count,
            gmac_reg_rx_packet_rate                      => udp_gmac_reg_rx_packet_rate,
            gmac_reg_rx_packet_count                     => udp_gmac_reg_rx_packet_count,
            gmac_reg_rx_valid_rate                       => udp_gmac_reg_rx_valid_rate,
            gmac_reg_rx_valid_count                      => udp_gmac_reg_rx_valid_count,
            gmac_reg_rx_bad_packet_count                 => udp_gmac_reg_rx_bad_packet_count,
            gmac_reg_counters_reset                      => udp_gmac_reg_counters_reset,
            gmac_reg_mac_enable                          => udp_gmac_reg_mac_enable,
            axis_tx_tdata                                => axis_tx_tdata,
            axis_tx_tvalid                               => axis_tx_tvalid,
            axis_tx_tready                               => axis_tx_tready,
            axis_tx_tkeep                                => axis_tx_tkeep,
            axis_tx_tlast                                => axis_tx_tlast,
            axis_tx_tuser                                => axis_tx_tuser,
            axis_rx_tdata                                => axis_rx_tdata,
            axis_rx_tvalid                               => axis_rx_tvalid,
            axis_rx_tuser                                => axis_rx_tuser,
            axis_rx_tkeep                                => axis_rx_tkeep,
            axis_rx_tlast                                => axis_rx_tlast
        );

end architecture rtl;

