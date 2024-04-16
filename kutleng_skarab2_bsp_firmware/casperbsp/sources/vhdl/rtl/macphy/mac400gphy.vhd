--------------------------------------------------------------------------------
-- Company          : Kutleng Dynamic Electronics Systems (Pty) Ltd            -
-- Engineer         : Benjamin Hector Hlophe                                   -
--                                                                             -
-- Design Name      : CASPER BSP                                               -
-- Module Name      : mac400gphy - rtl                                         -
-- Project Name     : CASPER                                                   -
-- Target Devices   : Xilinx Versal SoC                                        -
-- Tool Versions    : N/A                                                      -
-- Description      : This module instantiates one QSFP28+ ports with CMACs.   -
-- Dependencies     : gmacqsfp1top,gmacqsfp2top                                -
-- Revision History : V1.0 - Initial design                                    -
--                    V1.1 - Modify the module for 400g Ethernet               -
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mac400gphy is
    generic(
        C_MAC_INSTANCE             : natural range 0 to 3 := 0;
        C_COURSE_PACKET_THROTTLING : boolean              := false;
        C_USE_RS_FEC : boolean := false;
        -- Number GTME4_COMMON primitives to be instanced
        -- For the 400g design, it's requried to use 2GTM per quad across 2 quads.
        -- Search "full density or half density mode" in this document:
        -- https://docs.xilinx.com/r/en-US/am017-versal-gtm-transceivers/Transceiver-and-Tool-Overview
        C_N_COMMON : natural range 1 to 2 := 2;
        G_AXIS_DATA_WIDTH          : natural  := 1024;
        DCMAC_ID                   : natural  := 0
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
end entity mac400gphy;

architecture rtl of mac400gphy is
    component dcmactop is
    generic(
        C_USE_RS_FEC : boolean := false;
        C_INST_ID : integer;
        C_N_COMMON : natural range 1 to 2 := 2;
        DCMAC_ID   : natural range 0 to 1 := 1
    );
        port(
            -- Ethernet reference clock for 156.25MHz
            -- We need 2 quads for the 400G Ethernet by default.
            gt_clk0_p                    : in  STD_LOGIC;
            gt_clk0_n                    : in  STD_LOGIC;
            gt_clk1_p                    : in  STD_LOGIC;
            gt_clk1_n                    : in  STD_LOGIC; 
            -- incoming packet filters
            fabric_mac                   : in STD_LOGIC_VECTOR(47 downto 0);
            fabric_ip                    : in STD_LOGIC_VECTOR(31 downto 0);
            fabric_port                  : in STD_LOGIC_VECTOR(15 downto 0);
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
            -- These signals/buses run at 390.625MHz clock domain.              -
            ------------------------------------------------------------------------
            -- Global System Enable
            Enable                       : in  STD_LOGIC;
            Reset                        : in  STD_LOGIC;
            -- Statistics interface   
            -- TODO: these registers are not yet implemented in the dcmactop yet         
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
            -- This bus runs at 390.625MHz
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
    end component dcmactop;

    component macaxisdecoupler400g is
        generic(
            G_AXIS_DATA_WIDTH : natural := 1024
        );
        port(
            axis_tx_clk       : in  STD_LOGIC;
            axis_rx_clk       : in  STD_LOGIC;
            axis_reset        : in  STD_LOGIC;
            DataRateBackOff   : in  STD_LOGIC;
            TXOverFlowCount   : out STD_LOGIC_VECTOR(31 downto 0);
            TXAlmostFullCount : out STD_LOGIC_VECTOR(31 downto 0);
            --Outputs to AXIS bus MAC side 
            axis_tx_tdata     : out STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_tx_tvalid    : out STD_LOGIC;
            axis_tx_tready    : in  STD_LOGIC;
            axis_tx_tuser     : out STD_LOGIC;
            axis_tx_tkeep     : out STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_tx_tlast     : out STD_LOGIC;
            --Inputs from AXIS bus of the MAC side
            axis_rx_tready    : out STD_LOGIC;
            axis_rx_tdata     : in  STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_rx_tvalid    : in  STD_LOGIC;
            axis_rx_tuser     : in  STD_LOGIC;
            axis_rx_tkeep     : in  STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_rx_tlast     : in  STD_LOGIC
        );
    end component macaxisdecoupler400g;

    -- TODO: we need a new ip core for this fifo
    component axispacketbufferfifo400g
        port(
            s_aclk         : IN  STD_LOGIC;
            s_aresetn      : IN  STD_LOGIC;
            s_axis_tvalid  : IN  STD_LOGIC;
            s_axis_tready  : OUT STD_LOGIC;
            s_axis_tdata   : IN  STD_LOGIC_VECTOR(1023 DOWNTO 0);
            s_axis_tkeep   : IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
            s_axis_tlast   : IN  STD_LOGIC;
            s_axis_tuser   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
            m_axis_tvalid  : OUT STD_LOGIC;
            m_axis_tready  : IN  STD_LOGIC;
            m_axis_tdata   : OUT STD_LOGIC_VECTOR(1023 DOWNTO 0);
            m_axis_tkeep   : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
            m_axis_tlast   : OUT STD_LOGIC;
            m_axis_tuser   : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            axis_prog_full : OUT STD_LOGIC
        );
    end component axispacketbufferfifo400g;

    -- TODO: we need a new ip core for this ila
    component axis_stream_data_tx_ila_400g is
        port(
            clk    : in STD_LOGIC;
            probe0 : in STD_LOGIC_VECTOR(1023 downto 0);
            probe1 : in STD_LOGIC_VECTOR(127 downto 0);
            probe2 : in STD_LOGIC_VECTOR(0 to 0);
            probe3 : in STD_LOGIC_VECTOR(0 to 0);
            probe4 : in STD_LOGIC_VECTOR(0 to 0);
            probe5 : in STD_LOGIC_VECTOR(0 to 0);
            probe6 : in STD_LOGIC_VECTOR(0 to 0)
        );
    end component axis_stream_data_tx_ila_400g;

    signal axis_tdata       : STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1  downto 0);
    signal axis_tvalid      : STD_LOGIC;
    signal axis_tready      : STD_LOGIC;
    signal axis_tkeep       : STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
    signal axis_tlast       : STD_LOGIC;
    signal axis_tuser       : STD_LOGIC;
    signal axis_cp_tdata    : STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
    signal axis_cp_tvalid   : STD_LOGIC;
    signal axis_cp_tready   : STD_LOGIC;
    signal axis_cp_tkeep    : STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
    signal axis_cp_tlast    : STD_LOGIC;
    signal axis_cp_tuser    : STD_LOGIC;
    signal laxis_tx_clk     : STD_LOGIC;
    signal lDataRateBackOff : STD_LOGIC;
    signal ResetN           : STD_LOGIC;

begin
    ResetN          <= not Reset;
    DataRateBackOff <= lDataRateBackOff;

    axis_tx_clkout <= laxis_tx_clk;
    Throttle_false_i : if (C_COURSE_PACKET_THROTTLING = false) generate
    begin
        ------------------------------------------------------------------------
        -- Here we generate a simple packet decoupling FIFO buffer.           -- 
        -- This buffer will have very fine packet throttling through tready.  -- 
        ------------------------------------------------------------------------
        AXISPAcketBufferFIFO_i : axispacketbufferfifo400g
            PORT MAP(
                s_aclk          => laxis_tx_clk,
                s_aresetn       => ResetN,
                s_axis_tvalid   => axis_rx_tvalid,
                s_axis_tready   => axis_rx_tready,
                s_axis_tdata    => axis_rx_tdata,
                s_axis_tkeep    => axis_rx_tkeep,
                s_axis_tlast    => axis_rx_tlast,
                s_axis_tuser(0) => axis_rx_tuser,
                m_axis_tvalid   => axis_tvalid,
                m_axis_tready   => axis_tready,
                m_axis_tdata    => axis_tdata,
                m_axis_tkeep    => axis_tkeep,
                m_axis_tlast    => axis_tlast,
                m_axis_tuser(0) => axis_tuser,
                axis_prog_full  => lDataRateBackOff
            );
    end generate;

    Throttle_true_i : if (C_COURSE_PACKET_THROTTLING = true) generate
        ------------------------------------------------------------------------
        -- Here we generate a course packet decoupling FIFO buffer.           -- 
        -- This buffer will have course packet throttling through the use of  --         
        -- lDataRateBackOff. The incoming data will only be injested as whole --
        -- packets delimited by TLAST. TREADY will never toggle to control    --
        -- packet rate.                                                       --
        ------------------------------------------------------------------------        
        AXISPAcketBufferFIFO_i : axispacketbufferfifo400g
            PORT MAP(
                s_aclk          => laxis_tx_clk,
                s_aresetn       => ResetN,
                s_axis_tvalid   => axis_cp_tvalid,
                s_axis_tready   => axis_cp_tready,
                s_axis_tdata    => axis_cp_tdata,
                s_axis_tkeep    => axis_cp_tkeep,
                s_axis_tlast    => axis_cp_tlast,
                s_axis_tuser(0) => axis_cp_tuser,
                m_axis_tvalid   => axis_tvalid,
                m_axis_tready   => axis_tready,
                m_axis_tdata    => axis_tdata,
                m_axis_tkeep    => axis_tkeep,
                m_axis_tlast    => axis_tlast,
                m_axis_tuser(0) => axis_tuser,
                axis_prog_full  => lDataRateBackOff
            );

        DecouplerIlAi : axis_stream_data_tx_ila_400g
            port map(
                clk       => laxis_tx_clk,
                probe0    => axis_tdata,
                probe1    => axis_tkeep,
                probe2(0) => axis_tready,
                probe3(0) => axis_tlast,
                probe4(0) => axis_tuser,
                probe5(0) => axis_tvalid,
                probe6(0) => lDataRateBackOff
            );

        AXISDecoupleri : macaxisdecoupler400g
            port map(
                axis_tx_clk       => laxis_tx_clk,
                axis_rx_clk       => axis_rx_clkin,
                axis_reset        => Reset,
                DataRateBackOff   => lDataRateBackOff,
                TXOverFlowCount   => open,
                TXAlmostFullCount => open,
                axis_tx_tdata     => axis_cp_tdata,
                axis_tx_tvalid    => axis_cp_tvalid,
                axis_tx_tready    => axis_cp_tready,
                axis_tx_tuser     => axis_cp_tuser,
                axis_tx_tkeep     => axis_cp_tkeep,
                axis_tx_tlast     => axis_cp_tlast,
                axis_rx_tready    => axis_rx_tready,
                axis_rx_tdata     => axis_rx_tdata,
                axis_rx_tvalid    => axis_rx_tvalid,
                axis_rx_tuser     => axis_rx_tuser,
                axis_rx_tkeep     => axis_rx_tkeep,
                axis_rx_tlast     => axis_rx_tlast
            );

    end generate;

    assert C_MAC_INSTANCE > 3 report "Error bad C_MAC_INSTANCE = " & integer'image(C_MAC_INSTANCE) severity failure;

    DCMAC0_i : dcmactop
        generic map(
            C_USE_RS_FEC => C_USE_RS_FEC,
            C_INST_ID => C_MAC_INSTANCE,
            C_N_COMMON  => C_N_COMMON,
            DCMAC_ID    => DCMAC_ID
        )
        port map(
            Enable                       => Enable,
            Reset                        => Reset,
            fabric_mac                   => fabric_mac,
            fabric_ip                    => fabric_ip,
            fabric_port                  => fabric_port,
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
            gmac_reg_core_type           => gmac_reg_core_type,
            gmac_reg_phy_status_h        => gmac_reg_phy_status_h,
            gmac_reg_phy_status_l        => gmac_reg_phy_status_l,
            gmac_reg_phy_control_h       => gmac_reg_phy_control_h,
            gmac_reg_phy_control_l       => gmac_reg_phy_control_l,
            gmac_reg_tx_packet_rate      => gmac_reg_tx_packet_rate,
            gmac_reg_tx_packet_count     => gmac_reg_tx_packet_count,
            gmac_reg_tx_valid_rate       => gmac_reg_tx_valid_rate,
            gmac_reg_tx_valid_count      => gmac_reg_tx_valid_count,
            gmac_reg_rx_packet_rate      => gmac_reg_rx_packet_rate,
            gmac_reg_rx_packet_count     => gmac_reg_rx_packet_count,
            gmac_reg_rx_valid_rate       => gmac_reg_rx_valid_rate,
            gmac_reg_rx_valid_count      => gmac_reg_rx_valid_count,
            gmac_reg_rx_bad_packet_count => gmac_reg_rx_bad_packet_count,
            gmac_reg_counters_reset      => gmac_reg_counters_reset,
            lbus_reset                   => lbus_reset,
            lbus_tx_ovfout               => lbus_tx_ovfout,
            lbus_tx_unfout               => lbus_tx_unfout,
            axis_rx_clkin                => axis_rx_clkin,
            axis_rx_tdata                => axis_tdata,
            axis_rx_tvalid               => axis_tvalid,
            axis_rx_tready               => axis_tready,
            axis_rx_tkeep                => axis_tkeep,
            axis_rx_tlast                => axis_tlast,
            axis_rx_tuser                => axis_tuser,
            axis_tx_clkout               => laxis_tx_clk,
            axis_tx_tdata                => axis_tx_tdata,
            axis_tx_tvalid               => axis_tx_tvalid,
            axis_tx_tkeep                => axis_tx_tkeep,
            axis_tx_tlast                => axis_tx_tlast,
            axis_tx_tuser                => axis_tx_tuser,
            yellow_block_user_clk        => yellow_block_user_clk,
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

end architecture rtl;
