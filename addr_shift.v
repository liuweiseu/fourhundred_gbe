`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2024 09:02:22 PM
// Design Name: 
// Module Name: addr_shift
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


module addr_shift(
    input [31:0] addr_in,
    output [15:0] addr_out
    );
assign addr_out = addr_in[17:2];

endmodule 
