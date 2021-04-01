`timescale 1ns / 1ps
//Subject:      CO project 3 - Shift_Left_Two_32
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 �K౳� 0510009 �i౸�
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Shift_Left_Two_32(
    data_i,  //32 bit data_i (input)
    data_o   //32 bit data_o (output)
    );

//I/O ports                    
input  [31:0] data_i;
output [31:0] data_o;

//Internal Signals
reg [31:0] data_o;

//shift left 2
always@ (*) begin
	data_o[1:0] <= 2'b00;
	data_o[31:2] <= data_i[29:0];
end

endmodule