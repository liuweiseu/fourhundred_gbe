module axis_data_gen # (
    parameter G_AXIS_DATA_WIDTH = 1024,
    parameter D = 2
)(
    input axi_clk,
    input axis_streaming_data_clk,
    input axis_streaming_rst,
    input axis_data_gen_enable_axi,
    input [15:0] pkt_length_axi,
    input [15:0] period_axi,
    output [G_AXIS_DATA_WIDTH - 1 : 0] axis_streaming_data_tx_tdata_o,
    output axis_streaming_data_tx_tvalid_o,
    output axis_streaming_data_tx_tuser_o,
    output [G_AXIS_DATA_WIDTH / 8 - 1 : 0] axis_streaming_data_tx_tkeep_o,
    output axis_streaming_data_tx_tlast_o,
    input axis_streaming_data_tx_tready
);

reg [G_AXIS_DATA_WIDTH - 1 : 0] axis_streaming_data_tx_tdata;
reg axis_streaming_data_tx_tvalid;
reg axis_streaming_data_tx_tuser;
reg [G_AXIS_DATA_WIDTH / 8 - 1 : 0] axis_streaming_data_tx_tkeep;
reg axis_streaming_data_tx_tlast;
// TODO: Implement the data generator logic here.
parameter   IDLE    = 5'b00000;
parameter   START   = 5'b00010;
parameter   SEND    = 5'b00100;
parameter   LAST    = 5'b01000;
parameter   LOOP    = 5'b10000;

reg [4:0] st_cur, st_next;
reg [15:0] cnt;
reg [15:0] counter;

reg [15:0] pkt_length_tmp, pkt_length;
reg [15:0] period_tmp, period;
reg axis_data_gen_enable_tmp, axis_data_gen_enable;

always @(posedge axis_streaming_data_clk)
begin
    if(axis_streaming_rst)
        begin
            pkt_length_tmp <= 0;
            pkt_length <= 0;
            period_tmp <= 0;
            period <= 0;
            axis_data_gen_enable <= 0;
            axis_data_gen_enable_tmp <= 0;
        end
    else
        begin
            pkt_length_tmp <= pkt_length_axi;
            pkt_length <= pkt_length_tmp;
            period_tmp <= period_axi;
            period <= period_tmp;  
            axis_data_gen_enable_tmp <= axis_data_gen_enable_axi;
            axis_data_gen_enable <= axis_data_gen_enable_tmp;  
        end
end


always @(posedge axis_streaming_data_clk) 
begin
    if (axis_streaming_rst) begin
        st_cur      <= 5'b0 ;
    end
    else begin
        st_cur      <= st_next ;
    end
end

always @(*)
begin
    if(axis_streaming_rst)
        st_next = IDLE;
    else
        case(st_cur)
            IDLE: begin
                if(axis_data_gen_enable)
                    st_next = START;
                else
                    st_next = IDLE;
            end
            START: begin
                st_next = SEND;
            end
            SEND: begin
                if(cnt == pkt_length - 2)
                    st_next = LAST;
                else
                    st_next = SEND;
            end
            LAST: begin
                    st_next = LOOP;
            end
            LOOP: begin
                if(cnt == period - 2)
                    st_next = IDLE;
                else
                    st_next = LOOP;
            end
        endcase
end

/*
always @(posedge axis_streaming_data_clk)
begin
    if(axis_streaming_rst)
        counter <= 0;
    else
        counter <= counter + 1;
end
*/

always @(posedge axis_streaming_data_clk)
begin
   if(axis_streaming_rst)
   begin
         axis_streaming_data_tx_tvalid <= 0;
         axis_streaming_data_tx_tlast <= 0;
         axis_streaming_data_tx_tkeep <= 0;
         axis_streaming_data_tx_tuser <= 0;
         axis_streaming_data_tx_tdata <= 0;
         cnt <= 0;
         counter <= 0;
    end
    else
    begin
        case(st_cur)
            IDLE: 
            begin
                axis_streaming_data_tx_tvalid <= 0;
                axis_streaming_data_tx_tlast <= 0;
                axis_streaming_data_tx_tkeep <= 0;
                axis_streaming_data_tx_tuser <= 0;
                axis_streaming_data_tx_tdata <= 0;
                cnt <= 0;
                counter <= counter;
            end
            START: 
            begin
                if(axis_streaming_data_tx_tready)
                    begin
                        axis_streaming_data_tx_tvalid <= 1;
                        axis_streaming_data_tx_tlast <= 0;
                        axis_streaming_data_tx_tkeep <= 128'hffffffffffffffffffffffffffffffff;
                        axis_streaming_data_tx_tuser <= 0;
                        //axis_streaming_data_tx_tdata <= 1024'h123456789abcdef;
                        axis_streaming_data_tx_tdata <= {1008'h0, counter};
                        cnt <= cnt + 1;
                        counter <= counter + 1;
                    end
                else
                    begin
                        axis_streaming_data_tx_tvalid <= 0;
                        axis_streaming_data_tx_tlast <= axis_streaming_data_tx_tlast;
                        axis_streaming_data_tx_tkeep <= axis_streaming_data_tx_tkeep;
                        axis_streaming_data_tx_tuser <= axis_streaming_data_tx_tuser;
                        axis_streaming_data_tx_tdata <= axis_streaming_data_tx_tdata;
                        cnt <= cnt;
                        counter <= counter;
                    end
            end
            SEND: 
            begin
                if(axis_streaming_data_tx_tready)
                    begin
                        axis_streaming_data_tx_tvalid <= 1;
                        axis_streaming_data_tx_tlast <= 0;
                        axis_streaming_data_tx_tkeep <= 128'hffffffffffffffffffffffffffffffff;
                        axis_streaming_data_tx_tuser <= 0;
                        axis_streaming_data_tx_tdata <= 1024'h123456789abcdef;
                        cnt <= cnt + 1;
                        counter <= counter;
                    end
                else
                    begin
                        axis_streaming_data_tx_tvalid <= 0;
                        axis_streaming_data_tx_tlast <= axis_streaming_data_tx_tlast;
                        axis_streaming_data_tx_tkeep <= axis_streaming_data_tx_tkeep;
                        axis_streaming_data_tx_tuser <= axis_streaming_data_tx_tuser;
                        axis_streaming_data_tx_tdata <= axis_streaming_data_tx_tdata;
                        cnt <= cnt;
                        counter <= counter;
                    end
            end
            LAST: 
            begin
                if(axis_streaming_data_tx_tready)
                    begin
                        axis_streaming_data_tx_tvalid <= 1;
                        axis_streaming_data_tx_tlast <= 1;
                        axis_streaming_data_tx_tkeep <= 128'hffffffffffffffffffffffffffffffff;
                        axis_streaming_data_tx_tuser <= 0;
                        axis_streaming_data_tx_tdata <= 1024'h123456789abcdef;
                        cnt <= cnt + 1;
                        counter <= counter;
                    end
                else
                    begin
                        axis_streaming_data_tx_tvalid <= 0;
                        axis_streaming_data_tx_tlast <= axis_streaming_data_tx_tlast;
                        axis_streaming_data_tx_tkeep <= axis_streaming_data_tx_tkeep;
                        axis_streaming_data_tx_tuser <= axis_streaming_data_tx_tuser;
                        axis_streaming_data_tx_tdata <= axis_streaming_data_tx_tdata;
                        cnt <= cnt;
                        counter <= counter;
                    end
            end
            LOOP: 
            begin
                axis_streaming_data_tx_tvalid <= 0;
                axis_streaming_data_tx_tlast <= 0;
                axis_streaming_data_tx_tkeep <= 0;
                axis_streaming_data_tx_tuser <= 0;
                axis_streaming_data_tx_tdata <= 0;
                cnt <= cnt + 1;        
                counter <= counter;    
            end
            default:
            begin
                axis_streaming_data_tx_tvalid <= 0;
                axis_streaming_data_tx_tlast <= 0;
                axis_streaming_data_tx_tkeep <= 0;
                axis_streaming_data_tx_tuser <= 0;
                axis_streaming_data_tx_tdata <= 0;
                cnt <= cnt + 1;        
                counter <= 0;
            end
        endcase
   end  
end

delay #(
    .D(D),
    .BITWIDTH(G_AXIS_DATA_WIDTH)
) delay_axis_streaming_data_tx_tdata (
    .clk(axis_streaming_data_clk),
    .rst(axis_streaming_rst),
    .din(axis_streaming_data_tx_tdata),
    .dout(axis_streaming_data_tx_tdata_o)
);

delay #(
    .D(D),
    .BITWIDTH(1)
) delay_axis_streaming_data_tx_tvalid (
    .clk(axis_streaming_data_clk),
    .rst(axis_streaming_rst),
    .din(axis_streaming_data_tx_tvalid),
    .dout(axis_streaming_data_tx_tvalid_o)
);

delay #(
    .D(D),
    .BITWIDTH(1)
) delay_axis_streaming_data_tx_tuser (
    .clk(axis_streaming_data_clk),
    .rst(axis_streaming_rst),
    .din(axis_streaming_data_tx_tuser),
    .dout(axis_streaming_data_tx_tuser_o)
);

delay #(
    .D(D),
    .BITWIDTH(G_AXIS_DATA_WIDTH / 8)
) delay_axis_streaming_data_tx_tkeep (
    .clk(axis_streaming_data_clk),
    .rst(axis_streaming_rst),
    .din(axis_streaming_data_tx_tkeep),
    .dout(axis_streaming_data_tx_tkeep_o)
);

delay #(
    .D(D),
    .BITWIDTH(1)
) delay_axis_streaming_data_tx_tlast (
    .clk(axis_streaming_data_clk),
    .rst(axis_streaming_rst),
    .din(axis_streaming_data_tx_tlast),
    .dout(axis_streaming_data_tx_tlast_o)
);

endmodule