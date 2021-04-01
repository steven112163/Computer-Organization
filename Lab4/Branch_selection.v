`timescale 1ns / 1ps
//Subject:     CO project 4 - Branch_selection
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/06/10
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Branch_selection(
	branchType_i,   //3 bit branchType_i   (input)
	zero_i,         //1 bit zero_i         (input)
	resultBit31_i,  //1 bit resultBit31_i  (input)
	branch_o        //1 bit branch_o       (output)
    );

//I/O ports
input  [2:0]     branchType_i;
input            zero_i;
input            resultBit31_i;
output           branch_o;

//Internal Signals
reg              branch_o;

//Main function
always@ (*) begin
	case (branchType_i)
		3'b001: branch_o <= (zero_i) ? 1 : 0;                   //beq
		3'b010: branch_o <= (!zero_i) ? 1 : 0;                  //bne, bnez
		3'b011: branch_o <= (zero_i || resultBit31_i) ? 1 : 0;  //ble
		3'b100: branch_o <= (resultBit31_i) ? 1 : 0;            //bltz
		default: branch_o <= 0;
	endcase
end

endmodule
