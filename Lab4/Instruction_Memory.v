`timescale 1ns / 1ps
//Subject:     CO project 4 - Instruction Memory
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/06/10
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Instruction_Memory(
	addr_i,  //32 bit addr_i   (input)
	instr_o  //32 bit instr_o  (output)
	);

// Interface
input	[31:0]		addr_i;
output	[31:0]		instr_o;
integer             i;

// Instruction File
reg		[31:0]		instruction_file	[0:65-1];

initial begin

    for (i = 0; i < 65; i = i + 1)
            instruction_file[i] = 32'b0;
        
    $readmemb("lab4_test_data.txt", instruction_file);  //Read instruction from "lab4_test_data.txt"   
end

assign	instr_o = instruction_file[addr_i/4];  

endmodule
