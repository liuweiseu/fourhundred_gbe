`timescale 1ns/1ns

module fhg_axis_adapter #(
    parameter ETH = 400,
    parameter DATA_WIDTH = 1024,
    parameter SEG_USED = 8,
    parameter BYTES_PER_SEG = 16,
    parameter PKT_SIZE = 8192
)(
    input clk,
    input rst,
    // casper tx in
    input   [1023:0]  casper_tx_tdata,
    input             casper_tx_tvalid,
    input   [127:0]   casper_tx_tkeep,
    input             casper_tx_tlast,
    input             casper_tx_tuser,
    output            casper_tx_tready,
    // casper rx out
    output  [1023:0]  casper_rx_tdata,
    output            casper_rx_tvalid,
    input             casper_rx_tready,
    output  [127:0]   casper_rx_tkeep,
    output            casper_rx_tlast,
    output            casper_rx_tuser,
    // dcmac tx out
    output reg [2:0]  dcmac_tx_id,
    output reg [11:0] dcmac_tx_ena,
    output reg [11:0] dcmac_tx_sop,
    output reg [11:0] dcmac_tx_eop,
    output reg [11:0] dcmac_tx_err,
    output reg [47:0] dcmac_tx_mty,
    output reg [1535:0]dcmac_tx_dat,
    output reg [335:0]dcmac_tx_preamble,
    output reg [5:0]  dcmac_tx_vld,
    input      [5:0]  dcmac_tx_tready,
    input      [5:0]  dcmac_tx_af,
    input             dcmac_tx_ch_status_id,
    output reg        dcmac_tx_tuser_skip_response,
    // dcmac rx in
    input   [2:0]     dcmac_rx_id,
    input   [11:0]    dcmac_rx_ena,
    input   [11:0]    dcmac_rx_sop,
    input   [11:0]    dcmac_rx_eop,
    input   [11:0]    dcmac_rx_err,
    input   [47:0]    dcmac_rx_mty,
    input   [1535:0]  dcmac_rx_dat,
    input   [335:0]   dcmac_rx_preamble,
    input   [5:0]     dcmac_rx_vld
);

integer i;
parameter SEG_N = 6;
parameter CYC = PKT_SIZE / BYTES_PER_SEG / SEG_USED;
parameter REM = PKT_SIZE - CYC * BYTES_PER_SEG;

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

// always ready to receive data from the casper module.
assign casper_tx_tready = 1'b1;

/******************************* tx part ********************************/
// vld
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_vld <= 6'b0;
        end
    else if(casper_tx_tvalid && casper_tx_tready)
        begin
            //--------------------------------
            // TODO: check the vld signal for 400G, which is described on page 45 and 115 of the dcmac user guide.
            //--------------------------------
            // there are 6 vlds, but it seems we only need the first vld for 400G.
            // other 5 vlds should keep 0.
            dcmac_tx_vld <= 6'b1;
        end
    else
        begin
            dcmac_tx_vld <= 6'b0;
        end
end

// preamblein
reg casper_tx_tvalid_d1;
always @(posedge clk)
begin
    if(rst)
        casper_tx_tvalid_d1 <= 1'b0;
    else
        casper_tx_tvalid_d1 <= casper_tx_tvalid;
end
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_preamble <= 336'b0;
        end
    else if(casper_tx_tvalid && ~casper_tx_tvalid_d1 && casper_tx_tready)
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
            // the non-zero value is 56'h55555555555555.
            // -------------------------------
            // I'd like to keep sop always on seg 0, so we only need to set preamble_0 to non-zero value.
            dcmac_tx_preamble[55:0] <= 56'h55555555555555;
            dcmac_tx_preamble[109:56] <= 56'h0;
            dcmac_tx_preamble[165:110] <= 56'h0;
            dcmac_tx_preamble[221:166] <= 56'h0;
            dcmac_tx_preamble[277:222] <= 56'h0;
            dcmac_tx_preamble[335:278] <= 56'h0;
        end
    else
        begin
            dcmac_tx_preamble <= 336'b0;
        end
end
//ena
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_ena <= 12'b0;
        end
    else if(casper_tx_tvalid && casper_tx_tready)
        begin
            //--------------------------------
            // there are 12 enas, but it seems we only need the first 8 enas for 400G.
            dcmac_tx_ena <= 12'b1;
        end
    else
        begin
            dcmac_tx_ena <= 12'b0;
        end
end

//sop
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_sop <= 12'b0;
        end
    else if(casper_tx_tvalid && ~casper_tx_tvalid_d1 && casper_tx_tready)
        begin
            //--------------------------------
            // there are 12 sops, but it seems we only need the first 8 sops for 400G.
            //--------------------------------
            // I'd like to keep sop always on seg 0, so we only need to set sop_0 to 1.
            dcmac_tx_sop <= 12'b1;
        end
    else
        begin
            dcmac_tx_sop <= 12'b0;
        end
end
//eop
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_eop <= 12'b0;
        end
    else if(casper_tx_tvalid && casper_tx_tready  && casper_tx_tlast) // we need tlast here.
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
            // so eop is related to what casper_tx_tkeep is.
            for(i = 0; i < SEG_USED; i = i+1)
                begin
                    dcmac_tx_eop[i] <=      casper_tx_tkeep[BYTES_PER_SEG*i]  & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+1] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+2] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+3] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+4] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+5] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+6] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+7] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+8] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+9] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+10] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+11] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+12] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+13] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+14] & 
                                            casper_tx_tkeep[BYTES_PER_SEG*i+15];
                end
            // set the unused eop to 0.
            dcmac_tx_eop[8] <= 0;
            dcmac_tx_eop[9] <= 0;
            dcmac_tx_eop[10] <= 0;
            dcmac_tx_eop[11] <= 0;   
        end
    else
        begin
            dcmac_tx_eop[0] <= 12'b0;
        end
end
//err
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_err <= 12'b0;
        end
    else if(casper_tx_tvalid && casper_tx_tready)
        begin
            //--------------------------------
            // there are 12 errs, but it seems we only need the first 8 errs for 400G.
            //--------------------------------
            // I don't know how to set the err signal.
            // I think we can keep it 0.
            //--------------------------------
            // TODO: check how to set the err signals.
            dcmac_tx_err <= 12'b0;
        end
    else
        begin
            dcmac_tx_err <= 12'b0;
        end
end
//mty
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_mty <= 48'b0;
        end
    else if(casper_tx_tvalid && casper_tx_tready)
        begin
            //--------------------------------
            // there are 12 mtys, but it seems we only need the first 8 mtys for 400G.
            //--------------------------------
            // the mty for each seg means segment empty bytes in the seg.
            // so it's related to casper_tx_tkeep.
            for(i = 0; i < SEG_USED; i = i + 1)
                begin
                    dcmac_tx_mty[i*4+3-:4] <= BYTES_PER_SEG -  (casper_tx_tkeep[BYTES_PER_SEG*i] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+1] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+2] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+3] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+4] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+5] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+6] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+7] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+8] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+9] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+10] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+11] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+12] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+13] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+14] +
                                                        casper_tx_tkeep[BYTES_PER_SEG*i+15]);
                end
            // set the unused mty to 0.
            dcmac_tx_mty[35:32] <= 4'b0;
            dcmac_tx_mty[39:36] <= 4'b0;
            dcmac_tx_mty[43:40] <= 4'b0;
            dcmac_tx_mty[47:44] <= 4'b0;
        end
        else
            begin
                dcmac_tx_mty <= 48'b0;
            end
end
//tdata
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_dat <= 1536'b0;
        end
    else if(casper_tx_tvalid && casper_tx_tready)
        begin
            //--------------------------------
            // there are 12 dats, but it seems we only need the first 8 dats for 400G.
            //--------------------------------
            // the tdata is related to casper_tx_tdata.
            dcmac_tx_dat[1023:0] <= casper_tx_tdata[1023:0];
            // set the unused dats to 0.
            dcmac_tx_dat[1535:1024] <= 512'b0;
        end
    else
        begin
            dcmac_tx_dat <= 1536'b0;
        end
end

// id
// not care about it for now
// TODO: check how to set this signal
always @(posedge clk)
begin
    if(rst)
        dcmac_tx_id <= 3'b0;
    else
        dcmac_tx_id <= 3'b0;
end

//tuser_skip_response
// not care about it for now
// TODO: check how to set this signal
always @(posedge clk)
begin
    if(rst)
        dcmac_tx_tuser_skip_response <= 1'b0;
    else
        dcmac_tx_tuser_skip_response <= 1'b0;
end

/******************************* rx part ********************************/
// TODO: finish the rx part
assign casper_rx_tdata  = 1024'b0;
assign casper_rx_tvalid = 1'b0;
assign casper_rx_tkeep  = 128'b0;
assign casper_rx_tlast  = 1'b0;
assign casper_rx_tuser  = 1'b0;

endmodule