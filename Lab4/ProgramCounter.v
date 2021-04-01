`timescale 1ns / 1ps
//Subject:     CO project 4 - PC
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/06/10
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ProgramCounter(
    clk_i,    //1 bit clk_i     (input)
	rst_i,    //1 bit rst_i     (input)  negative reset
	pc_in_i,  //32 bit pc_in_i  (input)
	pc_out_o  //32 bit pc_out_i (output)
	);
     
//I/O ports
input           clk_i;
input	        rst_i;
input  [31:0]   pc_in_i;
output [31:0]   pc_out_o;
 
//Internal Signals
reg    [31:0]   pc_out_o;
 
//Parameter

    
//Main function
always @(posedge clk_i) begin
    if(~rst_i)
	    pc_out_o <= 0;
	else
	    pc_out_o <= pc_in_i;
end

endmodule