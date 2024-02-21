module axis_data_gen_tb;

parameter PERIOD = 2;
parameter G_AXIS_DATA_WIDTH = 1024;
parameter PKT_SIZE = 64;
parameter CYC = 128;

reg clk;
reg rst;
reg enable;
//-----------------reset & clk init-----------------
initial 
begin
    clk = 0;
    rst = 1;
    enable = 0;
    #10 rst = 0;
    #10 enable = 1;
    #100 enable = 0;
end
//-----------------clock generation-----------------
// 100MHz clock
always #(PERIOD/2)
begin
    clk = ~clk;
end

wire [G_AXIS_DATA_WIDTH - 1: 0] axis_streaming_data_tx_tdata;
wire axis_streaming_data_tx_tvalid;
wire axis_streaming_data_tx_tuser;
wire [(G_AXIS_DATA_WIDTH / 8) - 1 : 0] axis_streaming_data_tx_tkeep;
wire axis_streaming_data_tx_tlast;

axis_data_gen #(
    .G_AXIS_DATA_WIDTH(G_AXIS_DATA_WIDTH)
) axis_data_gen_inst(
    .axis_streaming_data_clk(clk),
    .axis_streaming_arst(rst),
    .axis_data_gen_enable(enable),
    .pkt_length(PKT_SIZE),
    .period(CYC),
    .axis_streaming_data_tx_tdata(axis_streaming_data_tx_tdata),
    .axis_streaming_data_tx_tvalid(axis_streaming_data_tx_tvalid),
    .axis_streaming_data_tx_tuser(axis_streaming_data_tx_tuser),
    .axis_streaming_data_tx_tkeep(axis_streaming_data_tx_tkeep),
    .axis_streaming_data_tx_tlast(axis_streaming_data_tx_tlast),
    .axis_streaming_data_tx_tready(1'b1)
);

endmodule