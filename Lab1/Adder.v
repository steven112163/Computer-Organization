`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 0510002 °Kà±³Ô
// 0510009 ±ià±¸©
//////////////////////////////////////////////////////////////////////////////////

module Adder(
	input a,         //1 bit a         (input)
	input b,         //1 bit b         (input)
	input carryin,   //1 bit carryin   (input)
	output sum,      //1 bit sum       (output)
	output carryout  //1 bit carryout  (output)
	);

reg [1:0] w = 2'd0;
assign sum = w[0];
assign carryout = w[1];
always@ (*) begin
	w = a + b + carryin;
end

endmodule
