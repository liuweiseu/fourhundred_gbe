module axis_data_gen # (
    parameter G_AXIS_DATA_WIDTH = 1024
)(
    input axis_streaming_data_clk,
    input axis_streaming_rst,
    input axis_data_gen_enable,
    input [15:0] pkt_length,
    input [15:0] period,
    output reg [G_AXIS_DATA_WIDTH - 1 : 0] axis_streaming_data_tx_tdata,
    output reg axis_streaming_data_tx_tvalid,
    output reg axis_streaming_data_tx_tuser,
    output reg [G_AXIS_DATA_WIDTH / 8 - 1 : 0] axis_streaming_data_tx_tkeep,
    output reg axis_streaming_data_tx_tlast,
    input axis_streaming_data_tx_tready
);

// TODO: Implement the data generator logic here.
parameter   IDLE    = 5'b00001;
parameter   START   = 5'b00010;
parameter   SEND    = 5'b00100;
parameter   LAST    = 5'b01000;
parameter   LOOP    = 5'b10000;

reg [4:0] st_cur, st_next;
reg [15:0] cnt;

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
            end
            START: 
            begin
                if(axis_streaming_data_tx_tready)
                    begin
                        axis_streaming_data_tx_tvalid <= 1;
                        axis_streaming_data_tx_tlast <= 0;
                        axis_streaming_data_tx_tkeep <= 128'hffffffffffffffffffffffffffffffff;
                        axis_streaming_data_tx_tuser <= 0;
                        axis_streaming_data_tx_tdata <= 1024'h123456789abcdef;
                        cnt <= cnt + 1;
                    end
                else
                    begin
                        axis_streaming_data_tx_tvalid <= axis_streaming_data_tx_tvalid;
                        axis_streaming_data_tx_tlast <= axis_streaming_data_tx_tlast;
                        axis_streaming_data_tx_tkeep <= axis_streaming_data_tx_tkeep;
                        axis_streaming_data_tx_tuser <= axis_streaming_data_tx_tuser;
                        axis_streaming_data_tx_tdata <= axis_streaming_data_tx_tdata;
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
                    end
                else
                    begin
                        axis_streaming_data_tx_tvalid <= axis_streaming_data_tx_tvalid;
                        axis_streaming_data_tx_tlast <= axis_streaming_data_tx_tlast;
                        axis_streaming_data_tx_tkeep <= axis_streaming_data_tx_tkeep;
                        axis_streaming_data_tx_tuser <= axis_streaming_data_tx_tuser;
                        axis_streaming_data_tx_tdata <= axis_streaming_data_tx_tdata;
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
                    end
                else
                    begin
                        axis_streaming_data_tx_tvalid <= axis_streaming_data_tx_tvalid;
                        axis_streaming_data_tx_tlast <= axis_streaming_data_tx_tlast;
                        axis_streaming_data_tx_tkeep <= axis_streaming_data_tx_tkeep;
                        axis_streaming_data_tx_tuser <= axis_streaming_data_tx_tuser;
                        axis_streaming_data_tx_tdata <= axis_streaming_data_tx_tdata;
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
            end
        endcase
   end  

end
endmodule