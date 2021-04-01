`timescale 1ns / 1ps
//Subject:     CO project 3 - Nop detection
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Nop_detection(
	instr_op_i,   //6 bit instr_op_i  (input)
	funct_i,      //6 bit funct_i     (input)
	Nop_o         //1 bit Nop_o       (output)
    );

//I/O port
input  [5:0]  instr_op_i;
input  [5:0]  funct_i;
output        Nop_o;

//Internal Signls
reg           Nop_o;

//Main function
always@ (*) begin
	if ({instr_op_i, funct_i} == 12'd0) Nop_o <= 1;
	else Nop_o <= 0;
end
endmodule
