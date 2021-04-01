`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 0510002 °Kà±³Ô
// 0510009 ±ià±¸©
//////////////////////////////////////////////////////////////////////////////////

module Compare(
	input less,            //1 bit less   (input)
	input equal,           //1 bit equal  (input)
	input [2:0] comp,      //3 bit comp   (input)
	output set             //1 bit set    (output)
    );

reg partSet;
assign set = partSet;
always@ (*) begin
	if(comp == 3'b000) partSet = less;
	else if(comp == 3'b001) partSet = less | equal;
	else if(comp == 3'b010) partSet = ~equal;
	else if(comp == 3'b011) partSet = equal;
	else if(comp == 3'b111) partSet = ~less;
	else if(comp == 3'b110) partSet = ~less & ~equal;
end

endmodule
