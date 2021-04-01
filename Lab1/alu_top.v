`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 0510002 °Kà±³Ô
// 0510009 ±ià±¸©
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
	input src1,             //1 bit source 1              (input)
	input src2,             //1 bit source 2              (input)
    input set,              //1 bit set                   (input)
	input A_invert,         //1 bit A_invert              (input)
	input B_invert,         //1 bit B_invert              (input)
	input cin,              //1 bit carry in              (input)
	input [1:0] operation,  //operation                   (input)
	output result,          //1 bit result                (output)
	output cout,            //1 bit carry out             (output)
	output number           //1 bit number                (output)
	);

wire portA, portB;
TwotoOneMUX M0(src1, ~src1, A_invert, portA);
TwotoOneMUX M1(src2, ~src2, B_invert, portB);

wire sum;
assign number = sum;
Adder M2(portA, portB, cin, sum, cout);

FourtoOneMUX M4(portA & portB, portA | portB, sum, set, operation, result);

endmodule
