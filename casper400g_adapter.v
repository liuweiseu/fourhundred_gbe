module casper400g_adapter#(
    parameter ETH = 400
)(
    /* Ports for connecting CASPER module*/
    // Reference clock to generate 100MHz from
    input Clk100MHz,
    // Global System Enable
    input Enable,
    input Reset,
    // Ethernet reference clock for 156.25MHz
    // QSFP+ -- Actually, it should be OSFP for 400G 
    input mgt_qsfp_clock_p,
    input mgt_qsfp_clock_n,
    // RX     
    input [3:0] qsfp_mgt_rx_p,
    input [3:0] qsfp_mgt_rx_n,
    // TX
    output [3:0] qsfp_mgt_tx_p,
    output [3:0] qsfp_mgt_tx_n,
    // Statistics interface            
    output [31:0] gmac_reg_core_type,
    output [31:0] gmac_reg_phy_status_h,
    output [31:0] gmac_reg_phy_status_l,
    input [31:0] gmac_reg_phy_control_h,
    input [31:0] gmac_reg_phy_control_l,
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
    // This bus runs at 322.265625MHz
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
    input axis_rx_clkin                : in  STD_LOGIC;
    input [511:0] axis_rx_tdata                : in  STD_LOGIC_VECTOR(511 downto 0);
    input axis_rx_tvalid               : in  STD_LOGIC;
    output axis_rx_tready               : out STD_LOGIC;
    input [63:0] axis_rx_tkeep                : in  STD_LOGIC_VECTOR(63 downto 0);
    input axis_rx_tlast                : in  STD_LOGIC;
    input axis_rx_tuser                : in  STD_LOGIC;
    // TX Bus
    output axis_tx_clkout               : out STD_LOGIC;
    output [511:0] axis_tx_tdata                : out STD_LOGIC_VECTOR(511 downto 0);
    output axis_tx_tvalid               : out STD_LOGIC;
    output [63:0] axis_tx_tkeep                : out STD_LOGIC_VECTOR(63 downto 0);
    output axis_tx_tlast                : out STD_LOGIC;
    // User signal for errors and dropping of packets
    output axis_tx_tuser                : out STD_LOGIC;
    input yellow_block_user_clk    : in STD_LOGIC;
    output [511:0] yellow_block_rx_data     : out  STD_LOGIC_VECTOR(511 downto 0);
    output yellow_block_rx_valid    : out  STD_LOGIC;
    output yellow_block_rx_eof      : out  STD_LOGIC;
    output yellow_block_rx_overrun  : out STD_LOGIC

);


endmodule