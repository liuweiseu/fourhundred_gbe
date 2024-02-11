`timescale 1ns/1ns

module fhg_axis_adapter_sim;

parameter PERIOD = 2;
parameter DATA_WIDTH = 1024;
parameter PKT_SIZE = 8192;
parameter SEND_CYC = PKT_SIZE / (DATA_WIDTH / 8);
parameter CYC = SEND_CYC + 1;
parameter SEG_N = 6;

reg clk;
reg rst;
//casper tx
reg [1023:0]    casper_tx_tdata;
reg             casper_tx_tvalid;
reg [127:0]     casper_tx_tkeep;
reg             casper_tx_tlast;
reg             casper_tx_tuser;
// casper rx
wire  [1023:0]  casper_rx_tdata;
wire            casper_rx_tvalid;
reg             casper_rx_tready;
wire  [127:0]   casper_rx_tkeep;
wire            casper_rx_tlast;
wire            casper_rx_tuser;
// dcmac tx 
wire  [2:0]     dcmac_tx_id;
wire  [11:0]    dcmac_tx_ena;
wire  [11:0]    dcmac_tx_sop;
wire  [11:0]    dcmac_tx_eop;
wire  [11:0]    dcmac_tx_err;
wire  [47:0]    dcmac_tx_mty;
wire  [1535:0]  dcmac_tx_dat;
wire  [335:0]   dcmac_tx_preamble;
wire  [5:0]     dcmac_tx_vld;
reg   [5:0]     dcmac_tx_tready;
reg   [5:0]     dcmac_tx_af;
reg             dcmac_tx_ch_status_id;
wire            dcmac_tx_tuser_skip_response;
// dcmac rx
reg   [2:0]     dcmac_rx_id;
reg   [11:0]    dcmac_rx_ena;
reg   [11:0]    dcmac_rx_sop;
reg   [11:0]    dcmac_rx_eop;
reg   [11:0]    dcmac_rx_err;
reg   [47:0]    dcmac_rx_mty;
reg   [1535:0]  dcmac_rx_dat;
reg   [335:0]   dcmac_rx_preamble;
reg   [5:0]     dcmac_rx_vld;

//-----------------reset & clk init-----------------
initial 
begin
    clk = 0;
    rst = 1;
    #10 rst = 0;
end
//-----------------clock generation-----------------
// 100MHz clock
always #(PERIOD/2)
begin
    clk = ~clk;
end
//---------------------casper tx--------------------
reg [9:0] cnt = 0;
always @(posedge clk)
begin
    if(rst)
        begin
            cnt <= 0;
        end
    else if(cnt == CYC - 1)
        begin
            cnt <= 0;
        end
    else
        begin
            cnt <= cnt + 1;
        end
end

always @(posedge clk)
begin
    if(rst)
        begin
            casper_tx_tdata <= 0;
            casper_tx_tvalid<= 0;
            casper_tx_tkeep <= 0;
            casper_tx_tlast <= 0;
            casper_tx_tuser <= 0;
        end
    else if(cnt == SEND_CYC - 2)
        begin
            casper_tx_tdata <= casper_tx_tdata + 1;
            casper_tx_tvalid<= 1'b1;
            casper_tx_tkeep <= 128'hffffffffffffffffffffffffffffffff;
            casper_tx_tlast <= 1'b1;
            casper_tx_tuser <= 1'b0;
        end
    else if(cnt == SEND_CYC - 1)
        begin
            casper_tx_tdata <= 0;
            casper_tx_tvalid<= 0;
            casper_tx_tkeep <= 0;
            casper_tx_tlast <= 0;
            casper_tx_tuser <= 0;
        end
    else
        begin
            casper_tx_tdata <= casper_tx_tdata + 1;
            casper_tx_tvalid<= 1'b1;
            casper_tx_tkeep <= 128'hffffffffffffffffffffffffffffffff;
            casper_tx_tlast <= 1'b0;
            casper_tx_tuser <= 1'b0;
        end
end
//---------------------casper rx--------------------
// we only need rx_tready here.
always @(posedge clk)
begin
    if(rst)
        begin
            casper_rx_tready <= 0;
        end
    else
        begin
            casper_rx_tready <= 1;
        end
end
//---------------------dcmac tx---------------------
// we only need tx_tready, tx_af and tx_ch_status_id here.
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_tx_tready <= 0;
            dcmac_tx_af <= 0;
            dcmac_tx_ch_status_id <= 0;
        end
    else
        begin
            dcmac_tx_tready <= 1;
            dcmac_tx_af <= 0;
            dcmac_tx_ch_status_id <= 0;
        end
end
//---------------------dcmac rx---------------------
// we don't care about the dcmac rx signals for now.
always @(posedge clk)
begin
    if(rst)
        begin
            dcmac_rx_id <= 0;
            dcmac_rx_ena <= 0;
            dcmac_rx_sop <= 0;
            dcmac_rx_eop <= 0;
            dcmac_rx_err <= 0;
            dcmac_rx_mty <= 0;
            dcmac_rx_dat <= 0;
            dcmac_rx_preamble <= 0;
            dcmac_rx_vld <= 0;
        end
    else
        begin
            dcmac_rx_id <= 0;
            dcmac_rx_ena <= 0;
            dcmac_rx_sop <= 0;
            dcmac_rx_eop <= 0;
            dcmac_rx_err <= 0;
            dcmac_rx_mty <= 0;
            dcmac_rx_dat <= 0;
            dcmac_rx_preamble <= 0;
            dcmac_rx_vld <= 0;
        end
end

//---------------------400g_axis_adapter module is here--------------------------
fhg_axis_adapter#(
    .PKT_SIZE(PKT_SIZE)
)adapter_inst(
    .clk(clk),
    .rst(rst),
    // casper tx in
    .casper_tx_tdata(casper_tx_tdata),
    .casper_tx_tvalid(casper_tx_tvalid),
    .casper_tx_tkeep(casper_tx_tkeep),
    .casper_tx_tlast(casper_tx_tlast),
    .casper_tx_tuser(casper_tx_tuser),
    .casper_tx_tready(casper_tx_tready),
    // casper rx out
    .casper_rx_tdata(casper_rx_tdata),
    .casper_rx_tvalid(casper_rx_tvalid),
    .casper_rx_tready(casper_rx_tready),
    .casper_rx_tkeep(casper_rx_tkeep),
    .casper_rx_tlast(casper_rx_tlast),
    .casper_rx_tuser(casper_rx_tuser),
    // dcmac tx out
    .dcmac_tx_id(dcmac_tx_id),
    .dcmac_tx_ena(dcmac_tx_ena),
    .dcmac_tx_sop(dcmac_tx_sop),
    .dcmac_tx_eop(dcmac_tx_eop),
    .dcmac_tx_err(dcmac_tx_err),
    .dcmac_tx_mty(dcmac_tx_mty),
    .dcmac_tx_dat(dcmac_tx_dat),
    .dcmac_tx_preamble(dcmac_tx_preamble),
    .dcmac_tx_vld(dcmac_tx_vld),
    .dcmac_tx_tready(dcmac_tx_tready),
    .dcmac_tx_af(dcmac_tx_af),
    .dcmac_tx_ch_status_id(dcmac_tx_ch_status_id),
    .dcmac_tx_tuser_skip_response(dcmac_tx_tuser_skip_response),
    // dcmac rx in
    .dcmac_rx_id(dcmac_rx_id),
    .dcmac_rx_ena(dcmac_rx_ena),
    .dcmac_rx_sop(dcmac_rx_sop),
    .dcmac_rx_eop(dcmac_rx_eop),
    .dcmac_rx_err(dcmac_rx_err),
    .dcmac_rx_mty(dcmac_rx_mty),
    .dcmac_rx_dat(dcmac_rx_dat),
    .dcmac_rx_preamble(dcmac_rx_preamble),
    .dcmac_rx_vld(dcmac_rx_vld)
);

endmodule