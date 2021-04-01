`timescale 1ns / 1ps
//Subject:     CO project 3 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,    //32 bit src1_i   (input)
	src2_i,    //32 bit src2_i   (input)
	ctrl_i,    //4 bit ctrl_i    (input)
	shamt_i,   //5 bit shamt_i   (input)
	result_o,  //32 bit result_o (output)
	zero_o     //1 bit zero_o    (output)
	);
     
//I/O ports
input  [31:0]    src1_i;
input  [31:0]	 src2_i;
input  [3:0]     ctrl_i;
input  [4:0]     shamt_i;

output [31:0]	 result_o;
output           zero_o;

//Internal signals
reg    [31:0]    result_o;
assign zero_o = (result_o == 0);
reg signed [31:0] shiftAmount;

//Main function
always@ (*) begin
	case (ctrl_i)
		4'b0000: result_o <= src1_i & src2_i;          //and
		4'b0001: result_o <= src1_i | src2_i;          //or
		4'b0010: result_o <= src1_i + src2_i;          //add
		4'b0011: result_o <= src1_i * src2_i;          //mul
		4'b0100: result_o <= src2_i;                   //jr
		4'b0110: result_o <= src1_i - src2_i;          //sub
		4'b0111: result_o <= src1_i < src2_i ? 1 : 0;  //slt
		4'b1000: result_o <= src2_i;                   //li
		4'b1100: result_o <= ~(src1_i | src2_i);       //nor
		4'b1110: begin                                 //sra
			shiftAmount = src2_i;
			result_o <= shiftAmount >>> shamt_i;
		end
		4'b1101: begin                                 //lui
			result_o[15:0] <= 0;
			result_o[31:16] <= src2_i[15:0];
		end
		4'b1111: begin                                 //srav
			if(src1_i < 32) begin
				shiftAmount = src2_i;
				result_o <= shiftAmount >>> src1_i;
			end
			else result_o <= 0;
		end
		default: result_o <= 0;
	endcase
end

endmodule