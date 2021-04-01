`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 0510002 °Kà±³Ô
// 0510009 ±ià±¸©
//////////////////////////////////////////////////////////////////////////////////

module TwotoOneMUX(
	input i0,          //1 bit i0         (input)
	input i1,          //1 bit i1         (input)
	input selection,   //1 bit selection  (input)
	output o           //1 bit o          (output)
	);

reg out;
assign o = out;
always@ (*) begin
	if(selection == 1'b0) out = i0;
	else out = i1;
end

endmodule
