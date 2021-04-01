`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 0510002 °Kà±³Ô
// 0510009 ±ià±¸©
//////////////////////////////////////////////////////////////////////////////////

module alu(
	input rst_n,                // negative reset                               (input)
	input [31:0] src1,          // 32 bits source 1                             (input)
	input [31:0] src2,          // 32 bits source 2                             (input)
	input [3:0] ALU_control,    // 4 bits ALU control input                     (input)
	input [2:0] bonus_control,  // 3 bits bonus control input                   (input)
	output [31:0] result,       // 32 bits result                               (output)
	output zero,                // 1 bit when the output is 0, zero must be set (output)
	output cout,                // 1 bit carry out                              (output)
	output overflow             // 1 bit overflow                               (output)
	);

wire [31:0] carryout;
assign cout = carryout[31];
reg portZero;
assign zero = portZero;
wire [31:0] partResult;
assign result = partResult;

wire [31:0] number;
reg  equal;
reg less;
wire set;
generate
	genvar i;
	for(i = 1; i <= 31; i = i + 1) begin : label
		alu_top s_alu(src1[i], src2[i], 1'b0, ALU_control[3], ALU_control[2], carryout[i-1], ALU_control[1:0], partResult[i], carryout[i], number[i]);
	end
endgenerate
Compare cmp(less, equal, bonus_control, set);
alu_top s_alu(src1[0], src2[0], set, ALU_control[3], ALU_control[2], ALU_control[2], ALU_control[1:0], partResult[0], carryout[0], number[0]);

always @(*) begin
    less = ~carryout[31];
end


reg partOverflow;
assign overflow = partOverflow;

always@ (*) begin
	if(carryout[31] && (ALU_control == 4'b0010)) partOverflow = 1;
	else if(~carryout[31] && (ALU_control == 4'b0110)) partOverflow = 1;
	else partOverflow = 0;
end

always@ (*) begin
	if(~rst_n) portZero = 0;
	else if(partResult == 32'd0) portZero = 1;
	else portZero = 0;

	if(~rst_n) begin
		equal = 0;
	end
	if(number == 32'd0) begin
		equal = 1;
	end
	else begin
		equal = 0;

	end
end

endmodule
