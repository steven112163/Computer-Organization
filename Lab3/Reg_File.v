`timescale 1ns / 1ps
//Subject:     CO project 3 - Register File
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 �K౳� 0510009 �i౸�
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Reg_File(
    clk_i,       //1 bit clk_i      (input)
	rst_i,       //1 bit rst_i      (input)  negative reset
    RSaddr_i,    //5 bit RSaddr_i   (input)
    RTaddr_i,    //5 bit RTaddr_i   (input)
    RDaddr_i,    //5 bit RDaddr_i   (input)
    RDdata_i,    //32 bit RDdata_i  (input)
    RegWrite_i,  //1 bit RegWrite_i (input)
    RSdata_o,    //32 bit RSdata_o  (output)
    RTdata_o     //32 bit RTdata_o  (output)
    );
          
//I/O ports
input           clk_i;
input           rst_i;
input           RegWrite_i;
input  [4:0]    RSaddr_i;
input  [4:0]    RTaddr_i;
input  [4:0]    RDaddr_i;
input  [31:0]   RDdata_i;

output [31:0]   RSdata_o;
output [31:0]   RTdata_o;   

//Internal signals/registers           
reg  signed [31:0]   Reg_File [0:31];     //32 word registers
wire        [31:0]   RSdata_o;
wire        [31:0]   RTdata_o;

//Read the data
assign RSdata_o = Reg_File[RSaddr_i] ;
assign RTdata_o = Reg_File[RTaddr_i] ;   

//Writing data when postive edge clk_i and RegWrite_i was set.
always@ (posedge rst_i or posedge clk_i) begin
    if(rst_i == 0) begin
	    Reg_File[0]  <= 0; Reg_File[1]  <= 0;   Reg_File[2]  <= 0; Reg_File[3]  <= 0;
	    Reg_File[4]  <= 0; Reg_File[5]  <= 0;   Reg_File[6]  <= 0; Reg_File[7]  <= 0;
        Reg_File[8]  <= 0; Reg_File[9]  <= 0;   Reg_File[10] <= 0; Reg_File[11] <= 0;
	    Reg_File[12] <= 0; Reg_File[13] <= 0;   Reg_File[14] <= 0; Reg_File[15] <= 0;
        Reg_File[16] <= 0; Reg_File[17] <= 0;   Reg_File[18] <= 0; Reg_File[19] <= 0;      
        Reg_File[20] <= 0; Reg_File[21] <= 0;   Reg_File[22] <= 0; Reg_File[23] <= 0;
        Reg_File[24] <= 0; Reg_File[25] <= 0;   Reg_File[26] <= 0; Reg_File[27] <= 0;
        Reg_File[28] <= 0; Reg_File[29] <= 128; Reg_File[30] <= 0; Reg_File[31] <= 0;
	end
    else begin
        if(RegWrite_i) 
            Reg_File[RDaddr_i] <= RDdata_i;	
		else 
		    Reg_File[RDaddr_i] <= Reg_File[RDaddr_i];
	end
end

endmodule