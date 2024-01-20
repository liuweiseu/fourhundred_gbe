module axis_adapter#(
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
    --RX     
    qsfp_mgt_rx_p                : in  STD_LOGIC_VECTOR(3 downto 0);
    qsfp_mgt_rx_n                : in  STD_LOGIC_VECTOR(3 downto 0);
    -- TX
    qsfp_mgt_tx_p                : out STD_LOGIC_VECTOR(3 downto 0);
    qsfp_mgt_tx_n                : out STD_LOGIC_VECTOR(3 downto 0);
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
    -- This bus runs at 322.265625MHz
    lbus_reset                   : in  STD_LOGIC;
    -- Overflow signal
    lbus_tx_ovfout               : out STD_LOGIC;
    -- Underflow signal
    lbus_tx_unfout               : out STD_LOGIC;
    -- Incoming packet filters (seemingly should be brought onto lbus_tx_clk)
    fabric_mac  : in STD_LOGIC_VECTOR(47 downto 0);
    fabric_ip   : in STD_LOGIC_VECTOR(31 downto 0);
    fabric_port : in STD_LOGIC_VECTOR(15 downto 0);
    -- AXIS Bus
    -- RX Bus
    axis_rx_clkin                : in  STD_LOGIC;
    axis_rx_tdata                : in  STD_LOGIC_VECTOR(511 downto 0);
    axis_rx_tvalid               : in  STD_LOGIC;
    axis_rx_tready               : out STD_LOGIC;
    axis_rx_tkeep                : in  STD_LOGIC_VECTOR(63 downto 0);
    axis_rx_tlast                : in  STD_LOGIC;
    axis_rx_tuser                : in  STD_LOGIC;
    -- TX Bus
    axis_tx_clkout               : out STD_LOGIC;
    axis_tx_tdata                : out STD_LOGIC_VECTOR(511 downto 0);
    axis_tx_tvalid               : out STD_LOGIC;
    axis_tx_tkeep                : out STD_LOGIC_VECTOR(63 downto 0);
    axis_tx_tlast                : out STD_LOGIC;
    -- User signal for errors and dropping of packets
    axis_tx_tuser                : out STD_LOGIC;
    yellow_block_user_clk    : in STD_LOGIC;
    yellow_block_rx_data     : out  STD_LOGIC_VECTOR(511 downto 0);
    yellow_block_rx_valid    : out  STD_LOGIC;
    yellow_block_rx_eof      : out  STD_LOGIC;
    yellow_block_rx_overrun  : out STD_LOGIC

);


endmodule