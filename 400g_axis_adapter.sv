module 400g_axis_adapter #(
    parameter ETH = 400,
    parameter DATA_WIDTH = 1024,
    parameter SEG_USED = 8,
    parameter BYTES_PER_SEG = 16,
    parameter PKT_SIZE = 8192
)(
    clk,
    rst,
    tx_pkt,
    rx_pkt,
    dcmac_tx_i_pkt,
    dcmac_tx_o_pkt,
    dcmac_rx_o_pkt,
    dcmac_tx_axis_ch_status_id,
    dcmac_tx_axis_tuser_skip_response
);
parameter SEG_N = 6;
parameter CYC = PKT_SIZE / BYTES_PER_SEG / SEG_USED;
parameter REM = PKT_SIZE - CYC * BYTES_PER_CHANNEL * CHANNELS;

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
} dcmac_axis_tx_o_pkt_t;

typedef struct packed {
  logic [5:0]               tready;
  logic [5:0]               af;
} dcmac_axis_tx_i_pkt_t;

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
} dcmac_axis_rx_i_pkt_t;


input clk;
input rst;
// these two sets of ports are connected from the CASPER modules
input axis_tx_pkt_t tx_pkt;
output axis_rx_pkt_t rx_pkt;
// these two sets of ports are connected to the dcmac core
output reg dcmac_axis_tx_o_pkt_t dcmac_tx_o_pkt;
input dcmac_axis_tx_i_pkt_t dcmac_tx_i_pkt;
input dcmac_axis_rx_i_pkt_t dcmac_rx_i_pkt;
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
/******************************* tx part ********************************/
// vld
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N; i++)
                begin
                    dcmac_tx_o_pkt.vld[i] <= 0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // TODO: check the vld signal for 400G, which is described on page 45 and 115 of the dcmac user guide.
            //--------------------------------
            // there are 6 vlds, but it seems we only need the first vld for 400G.
            // other 5 vlds should keep 0.
            dcmac_tx_o_pkt.vld[0] <= 1;
            dcmac_tx_o_pkt.vld[1] <= 0;
            dcmac_tx_o_pkt.vld[2] <= 0;
            dcmac_tx_o_pkt.vld[3] <= 0;
            dcmac_tx_o_pkt.vld[4] <= 0;
            dcmac_tx_o_pkt.vld[5] <= 0;
        end
    else
        begin
            dcmac_tx_o_pkt.vld[0] <= 0;
            dcmac_tx_o_pkt.vld[1] <= 0;
            dcmac_tx_o_pkt.vld[2] <= 0;
            dcmac_tx_o_pkt.vld[3] <= 0;
            dcmac_tx_o_pkt.vld[4] <= 0;
            dcmac_tx_o_pkt.vld[5] <= 0;
        end
end

// preamblein
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N; i++)
                begin
                    dcmac_tx_o_pkt.preamble[i] <= 56b'0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // TODO: 1. check the preambles signal for 400G, which is described on page 45 and 115 of the dcmac user guide.
            //       2. check the non-zero value for the preambles.
            //--------------------------------
            // there are 6 preambles, but it seems we only need the first two preambles for 400G.
            // other 4 preambles should keep 0.
            // -------------------------------
            // we use 8 seg for 400G.
            // if sop is on seg 0-3, then the preamble_0 should be set to non-zero value;
            // if sop is on seg 4-7, then the preamble_1 should be set to non-zero value;
            // the non-zero value is 56h'55555555555555.
            // -------------------------------
            // I'd like to keep sop always on seg 0, so we only need to set preamble_0 to non-zero value.
            dcmac_tx_o_pkt.preamble[0] <= 56h'55555555555555;
            dcmac_tx_o_pkt.preamble[1] <= 56h'0;
            dcmac_tx_o_pkt.preamble[2] <= 56h'0;
            dcmac_tx_o_pkt.preamble[3] <= 56h'0;
            dcmac_tx_o_pkt.preamble[4] <= 56h'0;
            dcmac_tx_o_pkt.preamble[5] <= 56h'0;
        end
    else
        begin
            dcmac_tx_o_pkt.preamble[0] <= 56h'0;
            dcmac_tx_o_pkt.preamble[1] <= 56h'0;
            dcmac_tx_o_pkt.preamble[2] <= 56h'0;
            dcmac_tx_o_pkt.preamble[3] <= 56h'0;
            dcmac_tx_o_pkt.preamble[4] <= 56h'0;
            dcmac_tx_o_pkt.preamble[5] <= 56h'0;
        end
end
//ena
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N * 2; i++)
                begin
                    dcmac_tx_o_pkt.ena[i] <= 0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // there are 12 enas, but it seems we only need the first 8 enas for 400G.
            dcmac_tx_o_pkt.ena[0] <= 1;
            dcmac_tx_o_pkt.ena[1] <= 1;
            dcmac_tx_o_pkt.ena[2] <= 1;
            dcmac_tx_o_pkt.ena[3] <= 1;
            dcmac_tx_o_pkt.ena[4] <= 1;
            dcmac_tx_o_pkt.ena[5] <= 1;
            dcmac_tx_o_pkt.ena[6] <= 1;
            dcmac_tx_o_pkt.ena[7] <= 1;
            dcmac_tx_o_pkt.ena[8] <= 0;
            dcmac_tx_o_pkt.ena[9] <= 0;
            dcmac_tx_o_pkt.ena[10] <= 0;
            dcmac_tx_o_pkt.ena[11] <= 0;
        end
    else
        begin
            dcmac_tx_o_pkt.ena[0] <= 0;
            dcmac_tx_o_pkt.ena[1] <= 0;
            dcmac_tx_o_pkt.ena[2] <= 0;
            dcmac_tx_o_pkt.ena[3] <= 0;
            dcmac_tx_o_pkt.ena[4] <= 0;
            dcmac_tx_o_pkt.ena[5] <= 0;
            dcmac_tx_o_pkt.ena[6] <= 0;
            dcmac_tx_o_pkt.ena[7] <= 0;
            dcmac_tx_o_pkt.ena[8] <= 0;
            dcmac_tx_o_pkt.ena[9] <= 0;
            dcmac_tx_o_pkt.ena[10] <= 0;
            dcmac_tx_o_pkt.ena[11] <= 0;
        end
end
//sop
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N * 2; i++)
                begin
                    dcmac_tx_o_pkt.sop[i] <= 0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // there are 12 sops, but it seems we only need the first 8 sops for 400G.
            //--------------------------------
            // I'd like to keep sop always on seg 0, so we only need to set sop_0 to 1.
            dcmac_tx_o_pkt.sop[0] <= 1;
            dcmac_tx_o_pkt.sop[1] <= 0;
            dcmac_tx_o_pkt.sop[2] <= 0;
            dcmac_tx_o_pkt.sop[3] <= 0;
            dcmac_tx_o_pkt.sop[4] <= 0;
            dcmac_tx_o_pkt.sop[5] <= 0;
            dcmac_tx_o_pkt.sop[6] <= 0;
            dcmac_tx_o_pkt.sop[7] <= 0;
            dcmac_tx_o_pkt.sop[8] <= 0;
            dcmac_tx_o_pkt.sop[9] <= 0;
            dcmac_tx_o_pkt.sop[10] <= 0;
            dcmac_tx_o_pkt.sop[11] <= 0;
        end
    else
        begin
            dcmac_tx_o_pkt.sop[0] <= 0;
            dcmac_tx_o_pkt.sop[1] <= 0;
            dcmac_tx_o_pkt.sop[2] <= 0;
            dcmac_tx_o_pkt.sop[3] <= 0;
            dcmac_tx_o_pkt.sop[4] <= 0;
            dcmac_tx_o_pkt.sop[5] <= 0;
            dcmac_tx_o_pkt.sop[6] <= 0;
            dcmac_tx_o_pkt.sop[7] <= 0;
            dcmac_tx_o_pkt.sop[8] <= 0;
            dcmac_tx_o_pkt.sop[9] <= 0;
            dcmac_tx_o_pkt.sop[10] <= 0;
            dcmac_tx_o_pkt.sop[11] <= 0;
        end
end
//eop
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N * 2; i++)
                begin
                    dcmac_tx_o_pkt.eop[i] <= 0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // there are 12 eops, but it seems we only need the first 8 eops for 400G.
            //--------------------------------
            // The eop depends on how many bytes you are trying to send.
            // For each segment, the bit width is 128, so it sends 16 bytes.
            // For example, if you want to send 158 bytes, the first 9 segments send 16 bytes, and the last segment sends 14 bytes.
            // so eop should be set to 1 on the 10th segment.
            // therefore, eop[(10-1)%8] = eop[1] should be set to 1.
            //--------------------------------
            // tkeep is used to indicate how many bytes are valid in the last segment.
            // so eop is related to what tx_pkt.tkeep is.
            for(int i = 0; i < SEG_USED; i++)
                begin
                    dcmac_tx_o_pkt.eop[i] <= tx_pkt.tkeep[BYTES_PER_SEG*i]  & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+1] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+2] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+3] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+4] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+5] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+6] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+7] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+8] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+9] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+10] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+11] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+12] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+13] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+14] & 
                                            tx_pkt.tkeep[BYTES_PER_SEG*i+15];
                end
            // set the unused eop to 0.
            dcmac_tx_o_pkt.eop[8] <= 0;
            dcmac_tx_o_pkt.eop[9] <= 0;
            dcmac_tx_o_pkt.eop[10] <= 0;
            dcmac_tx_o_pkt.eop[11] <= 0;
            
        end
    else
        begin
            dcmac_tx_o_pkt.eop[0] <= 0;
            dcmac_tx_o_pkt.eop[1] <= 0;
            dcmac_tx_o_pkt.eop[2] <= 0;
            dcmac_tx_o_pkt.eop[3] <= 0;
            dcmac_tx_o_pkt.eop[4] <= 0;
            dcmac_tx_o_pkt.eop[5] <= 0;
            dcmac_tx_o_pkt.eop[6] <= 0;
            dcmac_tx_o_pkt.eop[7] <= 0;
            dcmac_tx_o_pkt.eop[8] <= 0;
            dcmac_tx_o_pkt.eop[9] <= 0;
            dcmac_tx_o_pkt.eop[10] <= 0;
            dcmac_tx_o_pkt.eop[11] <= 0;
        end
end
//err
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N * 2; i++)
                begin
                    dcmac_tx_o_pkt.err[i] <= 0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // there are 12 errs, but it seems we only need the first 8 errs for 400G.
            //--------------------------------
            // I don't know how to set the err signal.
            // I think we can keep it 0.
            //--------------------------------
            // TODO: check how to set the err signals.
            dcmac_tx_o_pkt.err[0] <= 0;
            dcmac_tx_o_pkt.err[1] <= 0;
            dcmac_tx_o_pkt.err[2] <= 0;
            dcmac_tx_o_pkt.err[3] <= 0;
            dcmac_tx_o_pkt.err[4] <= 0;
            dcmac_tx_o_pkt.err[5] <= 0;
            dcmac_tx_o_pkt.err[6] <= 0;
            dcmac_tx_o_pkt.err[7] <= 0;
            dcmac_tx_o_pkt.err[8] <= 0;
            dcmac_tx_o_pkt.err[9] <= 0;
            dcmac_tx_o_pkt.err[10] <= 0;
        end
    else
        begin
            dcmac_tx_o_pkt.err[0] <= 0;
            dcmac_tx_o_pkt.err[1] <= 0;
            dcmac_tx_o_pkt.err[2] <= 0;
            dcmac_tx_o_pkt.err[3] <= 0;
            dcmac_tx_o_pkt.err[4] <= 0;
            dcmac_tx_o_pkt.err[5] <= 0;
            dcmac_tx_o_pkt.err[6] <= 0;
            dcmac_tx_o_pkt.err[7] <= 0;
            dcmac_tx_o_pkt.err[8] <= 0;
            dcmac_tx_o_pkt.err[9] <= 0;
            dcmac_tx_o_pkt.err[10] <= 0;
        end
end
//mty
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N * 2; i++)
                begin
                    dcmac_tx_o_pkt.mty[i] <= 4b'0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // there are 12 mtys, but it seems we only need the first 8 mtys for 400G.
            //--------------------------------
            // the mty for each seg means segment empty bytes in the seg.
            // so it's related to tx_pkt.tkeep.
            for(int i = 0; i < SEG_USED; i++)
                begin
                    dcmac_tx_o_pkt.mty[i] <= BYTES_PER_SEG- (tx_pkt.tkeep[BYTES_PER_SEG*i] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+1] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+2] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+3] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+4] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+5] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+6] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+7] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+8] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+9] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+10] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+11] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+12] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+13] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+14] +
                                                             tx_pkt.tkeep[BYTES_PER_SEG*i+15]);
                end
            // set the unused mty to 0.
            dcmac_tx_o_pkt.mty[8] <= 4b'0;
            dcmac_tx_o_pkt.mty[9] <= 4b'0;
            dcmac_tx_o_pkt.mty[10] <= 4b'0;
            dcmac_tx_o_pkt.mty[11] <= 4b'0;
        end
        else
            begin
                dcmac_tx_o_pkt.mty[0] <= 4b'0;
                dcmac_tx_o_pkt.mty[1] <= 4b'0;
                dcmac_tx_o_pkt.mty[2] <= 4b'0;
                dcmac_tx_o_pkt.mty[3] <= 4b'0;
                dcmac_tx_o_pkt.mty[4] <= 4b'0;
                dcmac_tx_o_pkt.mty[5] <= 4b'0;
                dcmac_tx_o_pkt.mty[6] <= 4b'0;
                dcmac_tx_o_pkt.mty[7] <= 4b'0;
                dcmac_tx_o_pkt.mty[8] <= 4b'0;
                dcmac_tx_o_pkt.mty[9] <= 4b'0;
                dcmac_tx_o_pkt.mty[10] <= 4b'0;
                dcmac_tx_o_pkt.mty[11] <= 4b'0;
            end
end
//tdata
always @(posedge clk)
begin
    if(rst)
        begin
            for(int i = 0; i < SEG_N * 2; i++)
                begin
                    dcmac_tx_o_pkt.dat[i] <= 128b'0;
                end
        end
    else if(tx_pkt.tvalid && tx_pkt.tready)
        begin
            //--------------------------------
            // there are 12 dats, but it seems we only need the first 8 dats for 400G.
            //--------------------------------
            // the tdata is related to tx_pkt.tdata.
            for(int i = 0; i < SEG_USED; i++)
                begin
                    dcmac_tx_o_pkt.dat[i] <= tx_pkt.tdata[BYTES_PER_SEG*i*8+127:BYTES_PER_SEG*i*8];
                end
            // set the unused dats to 0.
            dcmac_tx_o_pkt.dat[8] <= 128b'0;
            dcmac_tx_o_pkt.dat[9] <= 128b'0;
            dcmac_tx_o_pkt.dat[10] <= 128b'0;
            dcmac_tx_o_pkt.dat[11] <= 128b'0;
        end
    else
        begin
            dcmac_tx_o_pkt.dat[0] <= 128b'0;
            dcmac_tx_o_pkt.dat[1] <= 128b'0;
            dcmac_tx_o_pkt.dat[2] <= 128b'0;
            dcmac_tx_o_pkt.dat[3] <= 128b'0;
            dcmac_tx_o_pkt.dat[4] <= 128b'0;
            dcmac_tx_o_pkt.dat[5] <= 128b'0;
            dcmac_tx_o_pkt.dat[6] <= 128b'0;
            dcmac_tx_o_pkt.dat[7] <= 128b'0;
            dcmac_tx_o_pkt.dat[8] <= 128b'0;
            dcmac_tx_o_pkt.dat[9] <= 128b'0;
            dcmac_tx_o_pkt.dat[10] <= 128b'0;
            dcmac_tx_o_pkt.dat[11] <= 128b'0;
        end
end
/******************************* rx part ********************************/
// TODO: finish the rx part
assign rx_pkt.tdata = 1024b'0;
assign rx_pkt.tvalid = 1'b0;
assign rx_pkt.tkeep = 128b'0;
assign rx_pkt.tlast = 1'b0;
assign rx_pkt.tuser = 1'b0;

endmodule