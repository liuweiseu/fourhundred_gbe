--------------------------------------------------------------------------------
-- Company          : Kutleng Dynamic Electronics Systems (Pty) Ltd            -
-- Engineer         : Benjamin Hector Hlophe                                   -
--                                                                             -
-- Design Name      : CASPER BSP                                               -
-- Module Name      : udpipinterfacepr - rtl                                   -
-- Project Name     : SKARAB2                                                  -
-- Target Devices   : N/A                                                      -
-- Tool Versions    : N/A                                                      -
-- Description      : This module instantiates the ARP,Streaming Data over UDP -
--                    and the Partial Reconfiguration UDP Controller.          -
--                    TODO                                                     -
--                    Must connect a Microblaze module, which can do the ARP   -
--                    and control ARP,RARP,DHCP,and the AXI Lite bus.          -
--                                                                             -
-- Dependencies     : cpuethernetmacif,arpcache,udpstreamingapps               -
--                    prconfigcontroller,axisthreeportfabricmultiplexer        -
--                    axistwoportfabricmultiplexer                             -
-- Revision History : V1.0 - Initial design                                    -
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity udpipinterfacepr400g is
    generic(
        G_INCLUDE_ICAP               : boolean                          := false;
        G_INCLUDE_HARDWARE_ARP       : boolean                          := false;
        G_AXIS_DATA_WIDTH            : natural                          := 1024;
        G_SLOT_WIDTH                 : natural                          := 4;
        -- Number of UDP Streaming Data Server Modules 
        G_NUM_STREAMING_DATA_SERVERS : natural range 1 to 4             := 1;
        G_ARP_CACHE_ASIZE            : natural                          := 10;
        G_ARP_DATA_WIDTH             : natural                          := 32;
        G_CPU_TX_DATA_BUFFER_ASIZE   : natural                          := 13;
        G_CPU_RX_DATA_BUFFER_ASIZE   : natural                          := 13;
        G_PR_SERVER_PORT             : natural range 0 to ((2**16) - 1) := 5
    );
    port(
        -- Axis clock is the Ethernet module clock running at 322.625MHz
        axis_clk                                     : in  STD_LOGIC;
        -- Aximm clock is the AXI Lite MM clock for the gmac register interface
        -- It's 100MHz on the VPK180 board
        aximm_clk                                    : in  STD_LOGIC;
        -- ICAP is the 125MHz ICAP clock used for PR
        -- TODO: Check if we need the icap_clk
        -- It looks like we don't use PR for 100g/400g, so we may not need this clock.
        icap_clk                                     : in  STD_LOGIC;
        -- Axis reset is the global synchronous reset to the highest clock
        axis_reset                                   : in  STD_LOGIC;
        ------------------------------------------------------------------------
        -- AXILite slave Interface                                            --
        -- This interface is for register access as the the Ethernet Core     --
        -- memory map, this core has mac & phy registers, arp cache and also  --
        -- cpu transmit and receive buffers                                   --
        ------------------------------------------------------------------------
        -- TODO: Is it a good idea to expose the register interface to the user?
        -- Maybe we should expose an AXI Lite interface here...
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
        axis_streaming_data_rx_packet_length         : out STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
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
        axis_streaming_data_tx_tuser                 : in  STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
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
        DataRateBackOff                              : in  STD_LOGIC;
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
end entity udpipinterfacepr400g;

architecture rtl of udpipinterfacepr400g is
    -- TODO: Check if we need to modify the cpuethermacif module. 
    -- It looks like we don't too many changes on the cpuethernetmacif module.
    -- The reason is the interface to the CPU side is registers from axi interface, which is not necessary to be modified;
    -- The interface to the MAC side is AXIS interface, and there is no fifo used in this module,
    -- so the only thing need to be changed here is the G_AXIS_DATA_WIDTH.
    component cpuethernetmacif is
        generic(
            G_SLOT_WIDTH               : natural := 4;
            G_AXIS_DATA_WIDTH          : natural := 1024;
            G_CPU_TX_DATA_BUFFER_ASIZE : natural := 13;
            G_CPU_RX_DATA_BUFFER_ASIZE : natural := 13
        );
        port(
            axis_clk                                     : in  STD_LOGIC;
            aximm_clk                                    : in  STD_LOGIC;
            axis_reset                                   : in  STD_LOGIC;
            aximm_gmac_reg_mac_address                   : in  STD_LOGIC_VECTOR(47 downto 0);
            aximm_gmac_reg_udp_port                      : in  STD_LOGIC_VECTOR(15 downto 0);
            aximm_gmac_reg_udp_port_mask                 : in  STD_LOGIC_VECTOR(15 downto 0);
            aximm_gmac_reg_mac_promiscous_mode           : in  STD_LOGIC;
            aximm_gmac_reg_local_ip_address              : in  STD_LOGIC_VECTOR(31 downto 0);
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
            --Inputs from AXIS bus of the MAC side
            --Outputs to AXIS bus MAC side 
            axis_tx_tpriority                            : out STD_LOGIC_VECTOR(G_SLOT_WIDTH - 1 downto 0);
            axis_tx_tdata                                : out STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_tx_tvalid                               : out STD_LOGIC;
            axis_tx_tready                               : in  STD_LOGIC;
            axis_tx_tkeep                                : out STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_tx_tlast                                : out STD_LOGIC;
            --Inputs from AXIS bus of the MAC side
            axis_rx_tdata                                : in  STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_rx_tvalid                               : in  STD_LOGIC;
            axis_rx_tuser                                : in  STD_LOGIC;
            axis_rx_tkeep                                : in  STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_rx_tlast                                : in  STD_LOGIC
        );
    end component cpuethernetmacif;

    -- TODO: Check if we need to modify the arpcache module.
    -- I think we don't need to modify this module, as we only get arp info from this module.
    -- It has nothing to do with the bus width.
    component arpcache is
        generic(
            G_WRITE_DATA_WIDTH : natural range 32 to 64 := 32;
            G_NUM_CACHE_BLOCKS : natural range 1 to 4   := 1;
            G_ARP_CACHE_ASIZE  : natural                := 13
        );
        port(
            CPUClk             : in  STD_LOGIC;
            EthernetClk        : in  STD_LOGIC_VECTOR(G_NUM_CACHE_BLOCKS - 1 downto 0);
            -- CPU port
            CPUReadDataEnable  : in  STD_LOGIC;
            CPUReadData        : out STD_LOGIC_VECTOR(G_WRITE_DATA_WIDTH - 1 downto 0);
            CPUReadAddress     : in  STD_LOGIC_VECTOR(G_ARP_CACHE_ASIZE - 1 downto 0);
            CPUWriteDataEnable : in  STD_LOGIC;
            CPUWriteData       : in  STD_LOGIC_VECTOR(G_WRITE_DATA_WIDTH - 1 downto 0);
            CPUWriteAddress    : in  STD_LOGIC_VECTOR(G_ARP_CACHE_ASIZE - 1 downto 0);
            -- Ethernet port
            ARPReadDataEnable  : in  STD_LOGIC_VECTOR(G_NUM_CACHE_BLOCKS - 1 downto 0);
            ARPReadData        : out STD_LOGIC_VECTOR((G_NUM_CACHE_BLOCKS * G_WRITE_DATA_WIDTH * 2) - 1 downto 0);
            ARPReadAddress     : in  STD_LOGIC_VECTOR((G_NUM_CACHE_BLOCKS * (G_ARP_CACHE_ASIZE - 1)) - 1 downto 0)
        );
    end component arpcache;

    -- We have to modify this module, as it's the most important module for generating UDP packets.
    -- We should keep the interface identical to the 100g design, and only change the DATA_WIDTH.
    component udpstreamingapps400g is
        generic(
            G_AXIS_DATA_WIDTH            : natural              := 1024;
            G_SLOT_WIDTH                 : natural              := 4;
            -- Number of UDP Streaming Data Server Modules 
            G_NUM_STREAMING_DATA_SERVERS : natural range 1 to 4 := 1;
            G_ARP_CACHE_ASIZE            : natural              := 13;
            G_ARP_DATA_WIDTH             : natural              := 32
        );
        port(
            -- Axis clock is the Ethernet module clock running at 322.625MHz
            axis_clk                                    : in  STD_LOGIC;
            -- Axis reset is the global synchronous reset to the highest clock
            axis_reset                                  : in  STD_LOGIC;
            ------------------------------------------------------------------------
            -- AXILite slave Interface                                            --
            -- This interface is for register access as the the Ethernet Core     --
            -- memory map, this core has mac & phy registers, arp cache and also  --
            -- cpu transmit and receive buffers                                   --
            ------------------------------------------------------------------------
            aximm_gmac_reg_mac_address                  : in  STD_LOGIC_VECTOR(47 downto 0);
            aximm_gmac_reg_local_ip_address             : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_local_ip_netmask             : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_gateway_ip_address           : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_multicast_ip_address         : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_multicast_ip_mask            : in  STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_mac_enable                   : in  STD_LOGIC;
            aximm_gmac_reg_tx_overflow_count            : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_tx_afull_count               : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_overflow_count            : out STD_LOGIC_VECTOR(31 downto 0);
            aximm_gmac_reg_rx_almost_full_count         : out STD_LOGIC_VECTOR(31 downto 0);
            -- ARP Cache Read Interface for IP transmit mapping                   --
            ------------------------------------------------------------------------ 
            ARPReadDataEnable                           : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            ARPReadData                                 : in  STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS * (G_ARP_DATA_WIDTH * 2)) - 1 downto 0);
            ARPReadAddress                              : out STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS * G_ARP_CACHE_ASIZE) - 1 downto 0);
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
            -- Streaming data outputs to AXIS of the Yellow Blocks
            axis_streaming_data_rx_tdata                : out STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_rx_tvalid               : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_rx_tready               : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_rx_tkeep                : out STD_LOGIC_VECTOR(((G_AXIS_DATA_WIDTH / 8) * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_rx_tlast                : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_rx_tuser                : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            --Data inputs from AXIS bus of the Yellow Blocks
            axis_streaming_data_tx_destination_ip       : in  STD_LOGIC_VECTOR((32 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_destination_udp_port : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_source_udp_port      : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_packet_length        : in  STD_LOGIC_VECTOR((16 * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tdata                : in  STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tvalid               : in  STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tuser                : in  STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tkeep                : in  STD_LOGIC_VECTOR(((G_AXIS_DATA_WIDTH / 8) * G_NUM_STREAMING_DATA_SERVERS) - 1 downto 0);
            axis_streaming_data_tx_tlast                : in  STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            axis_streaming_data_tx_tready               : out STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
            DataRateBackOff                             : in  STD_LOGIC;
            ------------------------------------------------------------------------
            -- Ethernet MAC Streaming Interface                                   --
            ------------------------------------------------------------------------
            -- Outputs to AXIS bus MAC side 
            axis_tx_tpriority                           : out STD_LOGIC_VECTOR(G_SLOT_WIDTH - 1 downto 0);
            axis_tx_tdata                               : out STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_tx_tvalid                              : out STD_LOGIC;
            axis_tx_tready                              : in  STD_LOGIC;
            axis_tx_tkeep                               : out STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_tx_tlast                               : out STD_LOGIC;
            --Inputs from AXIS bus of the MAC side
            axis_rx_tdata                               : in  STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
            axis_rx_tvalid                              : in  STD_LOGIC;
            axis_rx_tuser                               : in  STD_LOGIC;
            axis_rx_tkeep                               : in  STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
            axis_rx_tlast                               : in  STD_LOGIC
        );
    end component udpstreamingapps400g;

    -- TODO: Check if we need to modify the axistwoportfabricmultiplexer module.
    -- We don't need to change anything in the multiplexer module.
    -- The DATA_WIDTH is a variable,and the default value is 64.
    -- It works for the 100g design with DATA_WIDTH = 512, so it should work for the 400g design with DATA_WIDTH = 1024. 
    component axistwoportfabricmultiplexer is
        generic(
            G_MAX_PACKET_BLOCKS_SIZE : natural := 64;
            G_PRIORITY_WIDTH         : natural := 4;
            G_DATA_WIDTH             : natural := 8
        );
        port(
            axis_clk            : in  STD_LOGIC;
            axis_reset          : in  STD_LOGIC;
            --Inputs from AXIS bus of the MAC side
            --Outputs to AXIS bus MAC side 
            axis_tx_tdata       : out STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0);
            axis_tx_tvalid      : out STD_LOGIC;
            axis_tx_tready      : in  STD_LOGIC;
            axis_tx_tkeep       : out STD_LOGIC_VECTOR((G_DATA_WIDTH / 8) - 1 downto 0);
            axis_tx_tlast       : out STD_LOGIC;
            axis_tx_tuser       : out STD_LOGIC;
            -- Port 1
            axis_rx_tpriority_1 : in  STD_LOGIC_VECTOR(G_PRIORITY_WIDTH - 1 downto 0);
            axis_rx_tdata_1     : in  STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0);
            axis_rx_tvalid_1    : in  STD_LOGIC;
            axis_rx_tready_1    : out STD_LOGIC;
            axis_rx_tkeep_1     : in  STD_LOGIC_VECTOR((G_DATA_WIDTH / 8) - 1 downto 0);
            axis_rx_tlast_1     : in  STD_LOGIC;
            -- Port 2
            axis_rx_tpriority_2 : in  STD_LOGIC_VECTOR(G_PRIORITY_WIDTH - 1 downto 0);
            axis_rx_tdata_2     : in  STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0);
            axis_rx_tvalid_2    : in  STD_LOGIC;
            axis_rx_tready_2    : out STD_LOGIC;
            axis_rx_tkeep_2     : in  STD_LOGIC_VECTOR((G_DATA_WIDTH / 8) - 1 downto 0);
            axis_rx_tlast_2     : in  STD_LOGIC
        );
    end component axistwoportfabricmultiplexer;

    constant C_MAX_PACKET_BLOCKS_SIZE : natural := 256;
    constant C_PRIORITY_WIDTH         : natural := G_SLOT_WIDTH;

    signal axis_tx_tpriority_1_arp : STD_LOGIC_VECTOR(C_PRIORITY_WIDTH - 1 downto 0);
    signal axis_tx_tdata_1_arp     : STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
    signal axis_tx_tvalid_1_arp    : STD_LOGIC;
    signal axis_tx_tkeep_1_arp     : STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
    signal axis_tx_tlast_1_arp     : STD_LOGIC;
    signal axis_tx_tready_1_arp    : STD_LOGIC;

    signal axis_tx_tpriority_1_cpu : STD_LOGIC_VECTOR(C_PRIORITY_WIDTH - 1 downto 0);
    signal axis_tx_tdata_1_cpu     : STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
    signal axis_tx_tvalid_1_cpu    : STD_LOGIC;
    signal axis_tx_tkeep_1_cpu     : STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
    signal axis_tx_tlast_1_cpu     : STD_LOGIC;
    signal axis_tx_tready_1_cpu    : STD_LOGIC;

    signal axis_tx_tpriority_1_udp : STD_LOGIC_VECTOR(C_PRIORITY_WIDTH - 1 downto 0);
    signal axis_tx_tdata_1_udp     : STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
    signal axis_tx_tvalid_1_udp    : STD_LOGIC;
    signal axis_tx_tkeep_1_udp     : STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
    signal axis_tx_tlast_1_udp     : STD_LOGIC;
    signal axis_tx_tready_1_udp    : STD_LOGIC;

    signal axis_tx_tpriority_1_pr : STD_LOGIC_VECTOR(C_PRIORITY_WIDTH - 1 downto 0);
    signal axis_tx_tdata_1_pr     : STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
    signal axis_tx_tvalid_1_pr    : STD_LOGIC;
    signal axis_tx_tkeep_1_pr     : STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
    signal axis_tx_tlast_1_pr     : STD_LOGIC;
    signal axis_tx_tready_1_pr    : STD_LOGIC;

    constant C_ARP_REG_BUFFER_SIZE         : NATURAL                       := 512;
    constant C_READ_REG_BUFFER_SIZE        : NATURAL                       := 2048;
    constant C_WRITE_REG_BUFFER_SIZE       : NATURAL                       := 2048;
    constant C_REG_READ_WRITE_WORD_LENGTHS : NATURAL                       := 16; -- Word lengths are 16 bits at a time
    constant C_EMAC_ADDR_1                 : std_logic_vector(47 downto 0) := X"000A_3502_4192";
    constant C_IP_ADDR_1                   : std_logic_vector(31 downto 0) := X"C0A8_640A";
    signal ARPCacheClock                   : std_logic_vector(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
    signal ARPReadDataEnable               : STD_LOGIC_VECTOR(G_NUM_STREAMING_DATA_SERVERS - 1 downto 0);
    signal ARPReadData                     : STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS * G_ARP_DATA_WIDTH * 2) - 1 downto 0);
    signal ARPReadAddress                  : STD_LOGIC_VECTOR((G_NUM_STREAMING_DATA_SERVERS * (G_ARP_CACHE_ASIZE - 1)) - 1 downto 0);
    signal axis_prog_full                  : STD_LOGIC;
    signal axis_prog_empty                 : STD_LOGIC;
    signal axis_data_count                 : STD_LOGIC_VECTOR(13 downto 0);
    signal ICAP_PRDONE                     : std_logic;
    signal ICAP_PRERROR                    : std_logic;
    signal ICAP_AVAIL                      : std_logic;
    signal ICAP_CSIB                       : std_logic;
    signal ICAP_RDWRB                      : std_logic;
    signal ICAP_DataOut                    : std_logic_vector(31 downto 0);
    signal ICAP_DataIn                     : std_logic_vector(31 downto 0);

    signal laxis_tx_tdata  : STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 downto 0);
    signal laxis_tx_tvalid : STD_LOGIC;
    signal laxis_tx_tkeep  : STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 downto 0);
    signal laxis_tx_tlast  : STD_LOGIC;
    signal laxis_tx_tuser  : STD_LOGIC;
begin

    axis_tx_tuser  <= laxis_tx_tuser;
    axis_tx_tdata  <= laxis_tx_tdata;
    axis_tx_tvalid <= laxis_tx_tvalid;
    axis_tx_tkeep  <= laxis_tx_tkeep;
    axis_tx_tlast  <= laxis_tx_tlast;

    gmac_reg_mac_enable <= aximm_gmac_reg_mac_enable;

    aximm_gmac_reg_rx_word_size        <= std_logic_vector(to_unsigned(C_REG_READ_WRITE_WORD_LENGTHS, 16));
    aximm_gmac_reg_tx_word_size        <= std_logic_vector(to_unsigned(C_REG_READ_WRITE_WORD_LENGTHS, 16));
    aximm_gmac_reg_rx_buffer_max_size  <= std_logic_vector(to_unsigned(C_READ_REG_BUFFER_SIZE, 16));
    aximm_gmac_reg_tx_buffer_max_size  <= std_logic_vector(to_unsigned(C_WRITE_REG_BUFFER_SIZE, 16));
    aximm_gmac_reg_arp_size            <= std_logic_vector(to_unsigned(C_ARP_REG_BUFFER_SIZE, 32));
    aximm_gmac_reg_core_type           <= gmac_reg_core_type;
    aximm_gmac_reg_phy_status_h        <= gmac_reg_phy_status_h;
    aximm_gmac_reg_phy_status_l        <= gmac_reg_phy_status_l;
    gmac_reg_phy_control_h             <= aximm_gmac_reg_phy_control_h;
    gmac_reg_phy_control_l             <= aximm_gmac_reg_phy_control_l;
    aximm_gmac_reg_tx_packet_rate      <= gmac_reg_tx_packet_rate;
    aximm_gmac_reg_tx_packet_count     <= gmac_reg_tx_packet_count;
    aximm_gmac_reg_tx_valid_rate       <= gmac_reg_tx_valid_rate;
    aximm_gmac_reg_tx_valid_count      <= gmac_reg_tx_valid_count;
    aximm_gmac_reg_rx_packet_rate      <= gmac_reg_rx_packet_rate;
    aximm_gmac_reg_rx_packet_count     <= gmac_reg_rx_packet_count;
    aximm_gmac_reg_rx_valid_rate       <= gmac_reg_rx_valid_rate;
    aximm_gmac_reg_rx_valid_count      <= gmac_reg_rx_valid_count;
    aximm_gmac_reg_rx_bad_packet_count <= gmac_reg_rx_bad_packet_count;
    gmac_reg_counters_reset            <= aximm_gmac_reg_counters_reset;
    
    ARPCacheClock <= (others => axis_clk);

    ARPCacheClock <= (others => axis_clk);

    ARPCACHE_i : arpcache
        generic map(
            G_WRITE_DATA_WIDTH => G_ARP_DATA_WIDTH,
            G_NUM_CACHE_BLOCKS => G_NUM_STREAMING_DATA_SERVERS,
            G_ARP_CACHE_ASIZE  => G_ARP_CACHE_ASIZE
        )
        port map(
            CPUClk             => aximm_clk,
            EthernetClk        => ARPCacheClock,
            -- CPU port
            CPUReadDataEnable  => aximm_gmac_arp_cache_read_enable,
            CPUReadData        => aximm_gmac_arp_cache_read_data,
            CPUReadAddress     => aximm_gmac_arp_cache_read_address,
            CPUWriteDataEnable => aximm_gmac_arp_cache_write_enable,
            CPUWriteData       => aximm_gmac_arp_cache_write_data,
            CPUWriteAddress    => aximm_gmac_arp_cache_write_address,
            -- Ethernet port
            ARPReadDataEnable  => ARPReadDataEnable,
            ARPReadData        => ARPReadData,
            ARPReadAddress     => ARPReadAddress
        );

    STREAMAPPSi : udpstreamingapps
        generic map(
            G_AXIS_DATA_WIDTH            => G_AXIS_DATA_WIDTH,
            G_SLOT_WIDTH                 => G_SLOT_WIDTH,
            -- Number of UDP Streaming Data Server Modules 
            G_NUM_STREAMING_DATA_SERVERS => G_NUM_STREAMING_DATA_SERVERS,
            G_ARP_CACHE_ASIZE            => G_ARP_CACHE_ASIZE - 1,
            G_ARP_DATA_WIDTH             => 32
        )
        port map(
            axis_clk                                    => axis_clk,
            axis_reset                                  => axis_reset,
            aximm_gmac_reg_mac_address                  => aximm_gmac_reg_mac_address,
            aximm_gmac_reg_local_ip_address             => aximm_gmac_reg_local_ip_address,
            aximm_gmac_reg_local_ip_netmask             => aximm_gmac_reg_local_ip_netmask,
            aximm_gmac_reg_gateway_ip_address           => aximm_gmac_reg_gateway_ip_address,
            aximm_gmac_reg_multicast_ip_address         => aximm_gmac_reg_multicast_ip_address,
            aximm_gmac_reg_multicast_ip_mask            => aximm_gmac_reg_multicast_ip_mask,
            aximm_gmac_reg_mac_enable                   => aximm_gmac_reg_mac_enable,
            aximm_gmac_reg_tx_overflow_count            => aximm_gmac_reg_tx_overflow_count,
            aximm_gmac_reg_tx_afull_count               => aximm_gmac_reg_tx_afull_count,
            aximm_gmac_reg_rx_overflow_count            => aximm_gmac_reg_rx_overflow_count,
            aximm_gmac_reg_rx_almost_full_count         => aximm_gmac_reg_rx_almost_full_count,
            ARPReadDataEnable                           => ARPReadDataEnable,
            ARPReadData                                 => ARPReadData,
            ARPReadAddress                              => ARPReadAddress,
            axis_streaming_data_clk                     => axis_streaming_data_clk,
            axis_streaming_data_rx_packet_length        => axis_streaming_data_rx_packet_length,
            axis_streaming_data_rx_tdata                => axis_streaming_data_rx_tdata,
            axis_streaming_data_rx_tvalid               => axis_streaming_data_rx_tvalid,
            axis_streaming_data_rx_tready               => axis_streaming_data_rx_tready,
            axis_streaming_data_rx_tkeep                => axis_streaming_data_rx_tkeep,
            axis_streaming_data_rx_tlast                => axis_streaming_data_rx_tlast,
            axis_streaming_data_rx_tuser                => axis_streaming_data_rx_tuser,
            axis_streaming_data_tx_destination_ip       => axis_streaming_data_tx_destination_ip,
            axis_streaming_data_tx_destination_udp_port => axis_streaming_data_tx_destination_udp_port,
            axis_streaming_data_tx_source_udp_port      => axis_streaming_data_tx_source_udp_port,
            axis_streaming_data_tx_packet_length        => axis_streaming_data_tx_packet_length,
            axis_streaming_data_tx_tdata                => axis_streaming_data_tx_tdata,
            axis_streaming_data_tx_tvalid               => axis_streaming_data_tx_tvalid,
            axis_streaming_data_tx_tuser                => axis_streaming_data_tx_tuser,
            axis_streaming_data_tx_tkeep                => axis_streaming_data_tx_tkeep,
            axis_streaming_data_tx_tlast                => axis_streaming_data_tx_tlast,
            axis_streaming_data_tx_tready               => axis_streaming_data_tx_tready,
            DataRateBackOff                             => DataRateBackOff,
            --Outputs to AXIS bus MAC side 
            axis_tx_tpriority                           => axis_tx_tpriority_1_udp,
            axis_tx_tdata                               => axis_tx_tdata_1_udp,
            axis_tx_tvalid                              => axis_tx_tvalid_1_udp,
            axis_tx_tready                              => axis_tx_tready_1_udp,
            axis_tx_tkeep                               => axis_tx_tkeep_1_udp,
            axis_tx_tlast                               => axis_tx_tlast_1_udp,
            --Inputs from AXIS bus of the MAC side
            axis_rx_tdata                               => axis_rx_tdata,
            axis_rx_tvalid                              => axis_rx_tvalid,
            axis_rx_tuser                               => axis_rx_tuser,
            axis_rx_tkeep                               => axis_rx_tkeep,
            axis_rx_tlast                               => axis_rx_tlast
        );

    CPUIFi : cpuethernetmacif
        generic map(
            G_SLOT_WIDTH               => G_SLOT_WIDTH,
            G_AXIS_DATA_WIDTH          => G_AXIS_DATA_WIDTH,
            G_CPU_TX_DATA_BUFFER_ASIZE => G_CPU_TX_DATA_BUFFER_ASIZE,
            G_CPU_RX_DATA_BUFFER_ASIZE => G_CPU_RX_DATA_BUFFER_ASIZE
        )
        port map(
            axis_clk                                     => axis_clk,
            aximm_clk                                    => aximm_clk,
            axis_reset                                   => axis_reset,
            aximm_gmac_reg_mac_address                   => aximm_gmac_reg_mac_address,
            aximm_gmac_reg_udp_port                      => aximm_gmac_reg_udp_port,
            aximm_gmac_reg_udp_port_mask                 => aximm_gmac_reg_udp_port_mask,
            aximm_gmac_reg_mac_promiscous_mode           => aximm_gmac_reg_mac_promiscous_mode,
            aximm_gmac_reg_local_ip_address              => aximm_gmac_reg_local_ip_address,
            aximm_gmac_tx_data_write_enable              => aximm_gmac_tx_data_write_enable,
            aximm_gmac_tx_data_read_enable               => aximm_gmac_tx_data_read_enable,
            aximm_gmac_tx_data_write_data                => aximm_gmac_tx_data_write_data,
            aximm_gmac_tx_data_write_byte_enable         => aximm_gmac_tx_data_write_byte_enable,
            aximm_gmac_tx_data_read_data                 => aximm_gmac_tx_data_read_data,
            aximm_gmac_tx_data_read_byte_enable          => aximm_gmac_tx_data_read_byte_enable,
            aximm_gmac_tx_data_write_address             => aximm_gmac_tx_data_write_address,
            aximm_gmac_tx_data_read_address              => aximm_gmac_tx_data_read_address,
            aximm_gmac_tx_ringbuffer_slot_id             => aximm_gmac_tx_ringbuffer_slot_id,
            aximm_gmac_tx_ringbuffer_slot_set            => aximm_gmac_tx_ringbuffer_slot_set,
            aximm_gmac_tx_ringbuffer_slot_status         => aximm_gmac_tx_ringbuffer_slot_status,
            aximm_gmac_tx_ringbuffer_number_slots_filled => aximm_gmac_tx_ringbuffer_number_slots_filled,
            aximm_gmac_rx_data_read_enable               => aximm_gmac_rx_data_read_enable,
            aximm_gmac_rx_data_read_data                 => aximm_gmac_rx_data_read_data,
            aximm_gmac_rx_data_read_byte_enable          => aximm_gmac_rx_data_read_byte_enable,
            aximm_gmac_rx_data_read_address              => aximm_gmac_rx_data_read_address,
            aximm_gmac_rx_ringbuffer_slot_id             => aximm_gmac_rx_ringbuffer_slot_id,
            aximm_gmac_rx_ringbuffer_slot_clear          => aximm_gmac_rx_ringbuffer_slot_clear,
            aximm_gmac_rx_ringbuffer_slot_status         => aximm_gmac_rx_ringbuffer_slot_status,
            aximm_gmac_rx_ringbuffer_number_slots_filled => aximm_gmac_rx_ringbuffer_number_slots_filled,
            --Inputs from AXIS bus of the MAC side
            --Outputs to AXIS bus MAC side 
            axis_tx_tpriority                            => axis_tx_tpriority_1_cpu,
            axis_tx_tdata                                => axis_tx_tdata_1_cpu,
            axis_tx_tvalid                               => axis_tx_tvalid_1_cpu,
            axis_tx_tready                               => axis_tx_tready_1_cpu,
            axis_tx_tkeep                                => axis_tx_tkeep_1_cpu,
            axis_tx_tlast                                => axis_tx_tlast_1_cpu,
            --
            axis_rx_tdata                                => axis_rx_tdata,
            axis_rx_tvalid                               => axis_rx_tvalid,
            axis_rx_tuser                                => axis_rx_tuser,
            axis_rx_tkeep                                => axis_rx_tkeep,
            axis_rx_tlast                                => axis_rx_tlast
        );

    NOPRCFGi : if G_INCLUDE_ICAP = false generate
    begin
        NOHWARPi : if G_INCLUDE_HARDWARE_ARP = false generate
        begin
            -- When not using ICAP we only need two ports for the multiplexer 
            AXISMUX_i : axistwoportfabricmultiplexer
                generic map(
                    G_MAX_PACKET_BLOCKS_SIZE => C_MAX_PACKET_BLOCKS_SIZE,
                    G_PRIORITY_WIDTH         => C_PRIORITY_WIDTH,
                    G_DATA_WIDTH             => G_AXIS_DATA_WIDTH
                )
                port map(
                    axis_clk            => axis_clk,
                    axis_reset          => axis_reset,
                    axis_tx_tdata       => laxis_tx_tdata,
                    axis_tx_tvalid      => laxis_tx_tvalid,
                    axis_tx_tready      => axis_tx_tready,
                    axis_tx_tkeep       => laxis_tx_tkeep,
                    axis_tx_tlast       => laxis_tx_tlast,
                    axis_tx_tuser       => laxis_tx_tuser,
                    -- Port 1 - ARP Controller Module
                    axis_rx_tpriority_1 => axis_tx_tpriority_1_cpu,
                    axis_rx_tdata_1     => axis_tx_tdata_1_cpu,
                    axis_rx_tvalid_1    => axis_tx_tvalid_1_cpu,
                    axis_rx_tready_1    => axis_tx_tready_1_cpu,
                    axis_rx_tkeep_1     => axis_tx_tkeep_1_cpu,
                    axis_rx_tlast_1     => axis_tx_tlast_1_cpu,
                    -- Port 2 - Streaming Data Module
                    axis_rx_tpriority_2 => axis_tx_tpriority_1_udp,
                    axis_rx_tdata_2     => axis_tx_tdata_1_udp,
                    axis_rx_tvalid_2    => axis_tx_tvalid_1_udp,
                    axis_rx_tready_2    => axis_tx_tready_1_udp,
                    axis_rx_tkeep_2     => axis_tx_tkeep_1_udp,
                    axis_rx_tlast_2     => axis_tx_tlast_1_udp
                );
        end generate;
    end generate;

end architecture rtl;
