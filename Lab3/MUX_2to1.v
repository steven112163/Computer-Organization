`timescale 1ns / 1ps
//Subject:     CO project 3 - MUX 221
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module MUX_2to1(
    data0_i,   //size-1 bit data0_i (input)
    data1_i,   //size-1 bit data1_i (input)
    select_i,  //1 bit select_i     (input)
    data_o     //size-1 bit data_o  (output)
    );

parameter size = 0;
//I/O ports               
input   [size-1:0] data0_i;
input   [size-1:0] data1_i;
input              select_i;
output  [size-1:0] data_o;

//Internal Signals
reg     [size-1:0] data_o;
//Main function
always@ (*) begin
	case (select_i)
		1'b0: data_o <= data0_i;
		1'b1: data_o <= data1_i;
	endcase
end

endmodule