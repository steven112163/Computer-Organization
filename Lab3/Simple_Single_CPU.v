`timescale 1ns / 1ps
//Subject:     CO project 3 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Simple_Single_CPU(
        clk_i,  //1 bit clk_i (input)
	rst_i   //1 bit rst_i (input)  negative reset
	);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signls
wire  [31:0]  pc_in;
wire  [31:0]  pc_out;
wire  [31:0]  pc_next;
wire  [31:0]  pc_branch;
wire  [31:0]  instr;
wire  [1:0]   RegDst;
wire          RegWrite;
wire          Branch;
wire  [3:0]   ALUop;
wire          ALUSrc;
wire          Jump;
wire          MemRead;
wire          MemWrite;
wire  [1:0]   MemToReg;
wire  [2:0]   BranchType;
wire  [1:0]   RegDst_final;
wire          RegWrite_final;
wire          Branch_final;
wire  [3:0]   ALUop_final;
wire          ALUSrc_final;
wire          Jump_final;
wire          MemRead_final;
wire          MemWrite_final;
wire  [1:0]   MemToReg_final;
wire  [2:0]   BranchType_final;
wire  [4:0]   write_reg;
wire  [31:0]  imm_32bit;
wire  [3:0]   ALU_operation;
wire  [31:0]  second_data;
wire  [31:0]  ALU_src1;
wire  [31:0]  ALU_src2;
wire  [31:0]  ALU_result;
wire          ALU_zero;
wire  [31:0]  plus_address;
wire  [31:0]  MemData;
wire  [31:0]  part_Jump;
wire  [31:0]  nextOrBranch;
wire          part_Branch;
wire  [31:0]  WriteData;
wire  [31:0]  JumpOrNot;
wire          Jr;
wire          NopOrNot;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(pc_in),
	.pc_out_o(pc_out)
	);

Adder Adder1(
        .src1_i(32'd4),
	.src2_i(pc_out),
	.sum_o(pc_next)
	);

Instr_Memory IM(
        .pc_addr_i(pc_out),
	.instr_o(instr)
	);

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'b11111),
        .select_i(RegDst_final),
        .data_o(write_reg)
        );

Reg_File RF(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(instr[25:21]),
        .RTaddr_i(instr[20:16]),
        .RDaddr_i(write_reg),
        .RDdata_i(WriteData),
        .RegWrite_i(RegWrite_final),
        .RSdata_o(ALU_src1),
        .RTdata_o(second_data)
        );

Decoder Decoder(
        .instr_op_i(instr[31:26]),
	.RegWrite_o(RegWrite),
	.ALU_op_o(ALUop),
	.ALUSrc_o(ALUSrc),
	.RegDst_o(RegDst),
	.Branch_o(Branch),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemToReg_o(MemToReg),
        .BranchType_o(BranchType)
	);

Nop_detection ND(
        .instr_op_i(instr[31:26]),
        .funct_i(instr[5:0]),
        .Nop_o(NopOrNot)
        );

MUX_2to1 #(.size(17)) Mux_DecoderSelection(
        .data0_i({RegWrite, ALUop, ALUSrc, RegDst, Branch, Jump, MemRead, MemWrite, MemToReg, BranchType}),
        .data1_i(17'd0),
        .select_i(NopOrNot),
        .data_o({RegWrite_final, ALUop_final, ALUSrc_final, RegDst_final, Branch_final, Jump_final, MemRead_final, MemWrite_final, MemToReg_final, BranchType_final})
        );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),
        .ALUOp_i(ALUop_final),
        .ALUCtrl_o(ALU_operation),
        .Jr_o(Jr)
        );

Sign_Extend SE(
        .ALUOp_i(ALUop_final),
        .data_i(instr[15:0]),
        .data_o(imm_32bit)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(second_data),
        .data1_i(imm_32bit),
        .select_i(ALUSrc_final),
        .data_o(ALU_src2)
        );

MUX_3to1 #(.size(32)) Mux_MemToReg(
        .data0_i(ALU_result),
        .data1_i(MemData),
        .data2_i(pc_next),
        .select_i(MemToReg_final),
        .data_o(WriteData)
        );

ALU ALU(
        .src1_i(ALU_src1),
	.src2_i(ALU_src2),
	.ctrl_i(ALU_operation),
        .shamt_i(instr[10:6]),
	.result_o(ALU_result),
	.zero_o(ALU_zero)
	);

Adder Adder2(
        .src1_i(pc_next),
	.src2_i(plus_address),
	.sum_o(pc_branch)
        );

Shift_Left_Two_32 Shifter(
        .data_i(imm_32bit),
        .data_o(plus_address)
        );

Shift_Left_Two_32 Jump_Shifter(
        .data_i({6'd0, instr[25:0]}),
        .data_o(part_Jump)
        );

Branch_selection BranchBlock(
        .branchType_i(BranchType_final),
        .zero_i(ALU_zero),
        .resultBit31_i(ALU_result[31]),
        .branch_o(part_Branch)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next),
        .data1_i(pc_branch),
        .select_i(Branch_final && part_Branch),
        .data_o(nextOrBranch)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source_Second(
        .data0_i(nextOrBranch),
        .data1_i({pc_next[31:28], part_Jump[27:0]}),
        .select_i(Jump_final),
        .data_o(JumpOrNot)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source_Third(
        .data0_i(JumpOrNot),
        .data1_i(ALU_src1),
        .select_i(Jr),
        .data_o(pc_in)
        );

Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(ALU_result),
        .data_i(second_data),
        .MemRead_i(MemRead_final),
        .MemWrite_i(MemWrite_final),
        .data_o(MemData)
        );

endmodule