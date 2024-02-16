library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
 
entity axis_data_fifo_400g is
    generic(
        PLATFORM          : string  := "versal";
        G_AXIS_DATA_WIDTH : natural := 1024;
        G_AXIS_FIFO_DEPTH : natural := 64
    );
    port(
        s_axis_aresetn  : IN STD_LOGIC;
        s_axis_aclk     : IN STD_LOGIC;
        s_axis_tvalid   : IN STD_LOGIC;
        s_axis_tready   : OUT STD_LOGIC;
        s_axis_tdata    : IN STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 DOWNTO 0);
        s_axis_tkeep    : IN STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 DOWNTO 0);
        s_axis_tlast    : IN STD_LOGIC;
        s_axis_tuser    : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axis_aclk     : IN STD_LOGIC;
        m_axis_tvalid   : OUT STD_LOGIC;
        m_axis_tready   : IN STD_LOGIC;
        m_axis_tdata    : OUT STD_LOGIC_VECTOR(G_AXIS_DATA_WIDTH - 1 DOWNTO 0);
        m_axis_tkeep    : OUT STD_LOGIC_VECTOR((G_AXIS_DATA_WIDTH / 8) - 1 DOWNTO 0);
        m_axis_tlast    : OUT STD_LOGIC;
        m_axis_tuser    : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
end entity axis_data_fifo_400g; 
 
architecture rtl of udpdatapacker400g is
    -- This is the FIFO work on Versal SoC
    component xpm_fifo_axis
    generic (
        CASCADE_HEIGHT          => 0,               -- DECIMAL
        CDC_SYNC_STAGES         => 2,               -- DECIMAL
        CLOCKING_MODE           => "common_clock",  -- String
        ECC_MODE                => "no_ecc",        -- String
        FIFO_DEPTH              => 64,              -- DECIMAL
        FIFO_MEMORY_TYPE        => "auto",          -- String
        PACKET_FIFO             => "false",         -- String
        PROG_EMPTY_THRESH       => 10,              -- DECIMAL
        PROG_FULL_THRESH        => 10,              -- DECIMAL
        RD_DATA_COUNT_WIDTH     => 1,               -- DECIMAL
        RELATED_CLOCKS          => 0,               -- DECIMAL
        SIM_ASSERT_CHK          => 0,               -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        TDATA_WIDTH             => 32,              -- DECIMAL
        TDEST_WIDTH             => 1,               -- DECIMAL
        TID_WIDTH               => 1,               -- DECIMAL
        TUSER_WIDTH             => 1,               -- DECIMAL
        USE_ADV_FEATURES        => "1000",          -- String
        WR_DATA_COUNT_WIDTH     => 1                -- DECIMAL
    );
    port(
        almost_empty_axis   : out STD_LOGIC;    
        almost_full_axis    : out STD_LOGIC;    
        dbiterr_axis        : out STD_LOGIC;    
        m_axis_tdata        : out STD_LOGIC_VECTOR(TDATA_WIDTH - 1 downto 0); 
        m_axis_tdest        : out STD_LOGIC_VECTOR(TDEST_WIDTH - 1 downto 0); 
        m_axis_tid          : out STD_LOGIC_VECTOR(TID_WIDTH - 1 downto 0); 
        m_axis_tkeep        : out STD_LOGIC_VECTOR(TDATA_WIDTH/8 - 1 downto 0); 
        m_axis_tlast        : out STD_LOGIC;    
        m_axis_tstrb        : out STD_LOGIC_VECTOR(TDATA_WIDTH/8 - 1 downto 0); 
        m_axis_tuser        : out STD_LOGIC_VECTOR(TUSER_WIDTH - 1 downto 0); 
        m_axis_tvalid       : out STD_LOGIC;    
        prog_empty_axis     : out STD_LOGIC;    
        prog_full_axis      : out STD_LOGIC;    
        rd_data_count_axis  : out STD_LOGIC_VECTOR(WR_DATA_COUNT_WIDTH - 1 downto 0);                         
        s_axis_tready       : in STD_LOGIC;     
        sbiterr_axis        : out STD_LOGIC;   
        wr_data_count_axis  : out STD_LOGIC_VECTOR(WR_DATA_COUNT_WIDTH - 1 downto 0); 
        injectdbiterr_axis  : in STD_LOGIC;     
        injectsbiterr_axis  : in STD_LOGIC;     
        m_aclk              : in STD_LOGIC;     
        m_axis_tready       : in STD_LOGIC;     
        s_aclk              : in STD_LOGIC;     
        s_aresetn           : in STD_LOGIC;     
        s_axis_tdata        : in STD_LOGIC_VECTOR(TDATA_WIDTH - 1 downto 0); 
        s_axis_tdest        : in STD_LOGIC_VECTOR(TDEST_WIDTH - 1 downto 0); 
        s_axis_tid          : in STD_LOGIC_VECTOR(TID_WIDTH - 1 downto 0); 
        s_axis_tkeep        : in STD_LOGIC_VECTOR(TDATA_WIDTH/8 - 1 downto 0); 
        s_axis_tlast        : in STD_LOGIC;     
        s_axis_tstrb        : in STD_LOGIC_VECTOR(TDATA_WIDTH/8 - 1 downto 0); 
        s_axis_tuser        : in STD_LOGIC_VECTOR(TUSER_WIDTH - 1 downto 0); 
        s_axis_tvalid       : in STD_LOGIC
    );
    end component;

begin
    AXIS_FIFO: xpm_fifo_axis
    generic map(
        FIFO_DEPTH              => G_AXIS_FIFO_DEPTH,
        TDATA_WIDTH             => G_AXIS_DATA_WIDTH,
        TDEST_WIDTH             => 1,
        TID_WIDTH               => 1,
        TUSER_WIDTH             => 1,
        WR_DATA_COUNT_WIDTH     => 1
    )
    port map(
        almost_empty_axis   => open,
        almost_full_axis    => open,
        dbiterr_axis        => open,
        m_axis_tdata        => m_axis_tdata,
        m_axis_tdest        => open,
        m_axis_tid          => open,
        m_axis_tkeep        => m_axis_tkeep,
        m_axis_tlast        => m_axis_tlast,
        m_axis_tstrb        => open,
        m_axis_tuser        => m_axis_tuser,
        m_axis_tvalid       => open,
        prog_empty_axis     => open,
        prog_full_axis      => open,
        rd_data_count_axis  => open,
        s_axis_tready       => s_axis_tready,
        sbiterr_axis        => open,
        wr_data_count_axis  => open,
        injectdbiterr_axis  => open,
        injectsbiterr_axis  => open,
        m_aclk              => m_axis_aclk,
        m_axis_tready       => m_axis_tready,
        s_aclk              => s_axis_aclk,
        s_aresetn           => s_axis_aresetn,
        s_axis_tdata        => s_axis_tdata,
        s_axis_tdest        => open,
        s_axis_tid          => open,
        s_axis_tkeep        => s_axis_tkeep,
        s_axis_tlast        => s_axis_tlast,
        s_axis_tstrb        => open,
        s_axis_tuser        => s_axis_tuser,
        s_axis_tvalid       => s_axis_tvalid
    );
end architecture rtl;
