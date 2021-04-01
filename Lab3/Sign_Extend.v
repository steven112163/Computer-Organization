`timescale 1ns / 1ps
//Subject:     CO project 3 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
	ALUOp_i,   //4 bit ALUOp_i (input)
    data_i,    //16 bit data_i  (input)
    data_o     //32 bit data_o  (output)
    );
               
//I/O ports
input   [3:0]  ALUOp_i;
input   [15:0] data_i;
output  [31:0] data_o;

//Internal Signals
reg     [31:0] data_o;

//Sign extended
always@ (*) begin
	if(ALUOp_i == 4'b0111) data_o <= { {16{1'b0}}, data_i };
	else data_o <= { {16{data_i[15]}}, data_i };
end

endmodule