module 400g_axis_adapter #(
    parameter ETH = 400
)(
    clk,
    rst,
    tx_pkt,
    rx_pkt,
    dcmac_tx_pkt,
    dcmac_rx_pkt,
    dcmac_tx_axis_ch_status_id,
    dcmac_tx_axis_tuser_skip_response
);

typedef struct packed {
    logic [1023:0]            tdata;
    logic                     tvalid;
    logic [127:0]             tkeep;
    logic                     tlast;
    logic                     tuser,     
} axis_tx_pkt_t;

typedef struct packed {
    logic [1023:0]            tdata;
    logic                     tvalid;
    logic                     tready,
    logic [127:0]             tkeep,
    logic                     tlast,
    logic                     tuser,
} axis_rx_pkt_t;

typedef struct packed {
  logic [2:0]               id;
  logic [11:0]              ena;
  logic [11:0]              sop;
  logic [11:0]              eop;
  logic [11:0]              err;
  logic [11:0][3:0]         mty;
  logic [11:0][127:0]       dat;
  logic [5:0][55:0]         preamble;
  logic [5:0]               vld;    
} dcmac_axis_tx_i_pkt_t;

typedef struct packed {
  logic [5:0]               tready;
  logic [5:0]               af;
} dcmac_axis_tx_o_pkt_t;

typedef struct packed {
  logic [2:0]               id;
  logic [11:0]              ena;
  logic [11:0]              sop;
  logic [11:0]              eop;
  logic [11:0]              err;
  logic [11:0][3:0]         mty;
  logic [11:0][127:0]       dat;
  logic [5:0][55:0]         preamble;
  logic [5:0]               vld;
} dcmac_axis_rx_o_pkt_t;


input clk;
input rst;
// these two sets of ports are connected from the CASPER modules
input axis_tx_pkt_t tx_pkt;
output axis_rx_pkt_t rx_pkt;
// these two sets of ports are connected to the dcmac core
output dcmac_axis_tx_pkt_t dcmac_tx_pkt;
input dcmac_axis_rx_pkt_t dcmac_rx_pkt;
input dcmac_tx_axis_ch_status_id;
output dcmac_tx_axis_tuser_skip_response;
/* Implement the adapter logic here.
* Memo:
    1. For the axis interface connected to the dcmac core, there are 12 channels, each channel sends 16 bytes.
    2. In 400G application, we only use 8 channels, and the clock freq is 390.625MHz.
       So the data rate is 390.625MHz * 8 * 16 = 400Gbps.
    3. The tx/rx data from/to the CASPER module is packed to a standard axis interface, but the axis interface connected to the dcmac core is not standard.
       So this adapter module is used to convert the standard axis interface to the non-standard axis interface.
    4. Here is the info about the non-standard axis interface:
        (1) The non-standard axis interface is defined in the dcmac_axis_tx_pkt_t and dcmac_axis_rx_pkt_t.
        (2) The transmitting protocol is described here: https://docs.xilinx.com/r/en-US/pg369-dcmac/Transmit-Segmented-AXI4-Stream. 
    5. To the radio astronomy community, tx is more important than rx, so we only implement the tx part first.
    TODO: implement the rx part.
*/
always(posedge clk)
begin
    
end
endmodule