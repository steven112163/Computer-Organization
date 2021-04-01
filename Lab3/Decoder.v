`timescale 1ns / 1ps
//Subject:     CO project 3 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,   //6 bit instr_op_i    (input)
	RegWrite_o,   //1 bit RegWrite_o    (output)
	ALU_op_o,     //4 bit ALU_op_o      (output)
	ALUSrc_o,     //1 bit ALUSrc_o      (output)
	RegDst_o,     //2 bit RegDst_o      (output)
	Branch_o,     //1 bit Branch_o      (output)
	Jump_o,       //1 bit Jump_o        (output)
	MemRead_o,    //1 bit MemRead_o     (output)
	MemWrite_o,   //1 bit MemWrite_o    (output)
	MemToReg_o,   //2 bit MemToReg_o    (output)
	BranchType_o  //3 bit BranchType_o  (output)
	);
     
//I/O ports
input  [5:0]   instr_op_i;

output         RegWrite_o;
output [3:0]   ALU_op_o;
output         ALUSrc_o;
output [1:0]   RegDst_o;
output         Branch_o;
output         Jump_o;
output         MemRead_o;
output         MemWrite_o;
output [1:0]   MemToReg_o;
output [2:0]   BranchType_o;
 
//Internal Signals
reg    [3:0]   ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [1:0]   RegDst_o;
reg            Branch_o;
reg            Jump_o;
reg            MemRead_o;
reg            MemWrite_o;
reg    [1:0]   MemToReg_o;
reg    [2:0]   BranchType_o;

//Parameter


//Main function
always@ (*) begin
	if(instr_op_i == 6'b000000) begin  //addu, subu, and, or, slt, sra, srav, mul, jr
		ALU_op_o <= 4'b0010;
		ALUSrc_o <= 0;
		RegWrite_o <= 1;
		RegDst_o <= 1;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b001000) begin  //addi
		ALU_op_o <= 4'b0100;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b001011) begin  //sltiu
		ALU_op_o <= 4'b0101;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b000100) begin  //beq
		ALU_op_o <= 4'b0001;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 1;
		Branch_o <= 1;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b001;
	end
	if(instr_op_i == 6'b001111) begin  //lui
		ALU_op_o <= 4'b0110;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b001111) begin  //li
		ALU_op_o <= 4'b1100;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b001101) begin  //ori
		ALU_op_o <= 4'b0111;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b000101) begin  //bne, bnez
		ALU_op_o <= 4'b0011;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 1;
		Branch_o <= 1;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b010;
	end
	if(instr_op_i == 6'b100011) begin  //lw
		ALU_op_o <= 4'b1000;
		ALUSrc_o <= 1;
		RegWrite_o <= 1;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 1;
		MemWrite_o <= 0;
		MemToReg_o <= 1;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b101011) begin  //sw
		ALU_op_o <= 4'b1001;
		ALUSrc_o <= 1;
		RegWrite_o <= 0;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 1;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b000010) begin  //j
		ALU_op_o <= 4'b0000;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 0;
		Branch_o <= 0;
		Jump_o <= 1;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b000011) begin  //jal
		ALU_op_o <= 4'b0000;
		ALUSrc_o <= 0;
		RegWrite_o <= 1;
		RegDst_o <= 2;
		Branch_o <= 0;
		Jump_o <= 1;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 2;
		BranchType_o <= 3'b000;
	end
	if(instr_op_i == 6'b000110) begin  //ble
		ALU_op_o <= 4'b1010;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 1;
		Branch_o <= 1;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b011;
	end
	if(instr_op_i == 6'b000001) begin  //bltz
		ALU_op_o <= 4'b1011;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		RegDst_o <= 1;
		Branch_o <= 1;
		Jump_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		MemToReg_o <= 0;
		BranchType_o <= 3'b100;
	end
end

endmodule