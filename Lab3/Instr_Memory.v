`timescale 1ns / 1ps
//Subject:     CO project 3 - Instruction Memory
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Instr_Memory(
    pc_addr_i,  //32 bit pc_addr_i (input)
	instr_o     //32 bit instr_o   (output)
	);
 
//I/O ports
input  [31:0]    pc_addr_i;
output [31:0]	 instr_o;

//Internal Signals
reg    [31:0]	 instr_o;
integer          i;

//32 words Memory
reg    [31:0]    Instr_Mem [0:31];

//Parameter
    
//Main function
always @(pc_addr_i) begin
	instr_o = Instr_Mem[pc_addr_i/4];
end
    
//Initial Memory Contents
initial begin
    for (i = 0; i < 32; i = i + 1)
	    Instr_Mem[i] = 32'b0;
    $readmemb("CO_P3_test_data3.txt", Instr_Mem);  //Read instruction from "CO_P3_test_data1.txt"   
		
end

endmodule              