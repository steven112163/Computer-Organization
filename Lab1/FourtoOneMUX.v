`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 0510002 °Kà±³Ô
// 0510009 ±ià±¸©
//////////////////////////////////////////////////////////////////////////////////

module FourtoOneMUX(
	input i0,               //1 bit i0         (input)
	input i1,               //1 bit i1         (input)
	input i2,               //1 bit i2         (input)
	input i3,               //1 bit i3         (input)
	input [1:0] selection,  //2 bit selection  (input)
	output o                //1 bit o          (output)
	);

reg out;
assign o = out;
always@ (*) begin
	if(selection == 2'd0) out = i0;
	else if(selection == 2'd1) out = i1;
	else if(selection == 2'd2) out = i2;
	else out = i3;
end

endmodule
