`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 08:13:13 PM
// Design Name: 
// Module Name: delay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module delay # (
    parameter D 		= 1,
	parameter BITWIDTH 	= 1
)(
    input clk,
	input rst,
	input [(BITWIDTH-1):0]din,
	output [(BITWIDTH-1):0]dout
);

reg [(BITWIDTH-1):0] d [(D-1):0];
integer i;
always @(posedge clk)
	begin
		d[0][(BITWIDTH-1):0]	<= din;

		for(i = 1; i< D ;i = i+1)
			d[i][(BITWIDTH-1):0] <= d[i-1][(BITWIDTH-1):0]; 
	end
assign dout = d[D-1][(BITWIDTH-1):0]; 

endmodule