`timescale 1ns / 1ps
//Subject:     CO project 3 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0510002 °Kà±³Ô 0510009 ±ià±¸©
//--------------------------------------------------------------------------------
//Date:        2018/05/11
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
    funct_i,    //6 bit funct_i   (input)
    ALUOp_i,    //4 bit ALUOp_i   (input)
    ALUCtrl_o,  //4 bit ALUCtrl_o (output)
    Jr_o        //1 bit Jr_o      (output)
    );
          
//I/O ports 
input      [5:0] funct_i;
input      [3:0] ALUOp_i;

output     [3:0] ALUCtrl_o; 
output           Jr_o;
     
//Internal Signals
reg        [3:0] ALUCtrl_o;
reg              Jr_o;
       
//Select exact operation
always@ (*) begin
	Jr_o <= 0;
	case (ALUOp_i)
		4'b0010: begin
			case (funct_i)
				6'b100001: ALUCtrl_o <= 4'b0010;  //addu
				6'b100011: ALUCtrl_o <= 4'b0110;  //subu
				6'b100100: ALUCtrl_o <= 4'b0000;  //and
				6'b100101: ALUCtrl_o <= 4'b0001;  //or
				6'b101010: ALUCtrl_o <= 4'b0111;  //slt
				6'b000011: ALUCtrl_o <= 4'b1110;  //sra
				6'b000111: ALUCtrl_o <= 4'b1111;  //srav
				6'b011000: ALUCtrl_o <= 4'b0011;  //mul
				6'b001000: begin                  //jr
					ALUCtrl_o <= 4'b0100;
					Jr_o <= 1;
				end
			endcase
		end
		4'b0100: ALUCtrl_o <= 4'b0010;  //addi
		4'b0101: ALUCtrl_o <= 4'b0111;  //sltiu
		4'b0001: ALUCtrl_o <= 4'b0110;  //beq
		4'b0110: ALUCtrl_o <= 4'b1101;  //lui
		4'b1100: ALUCtrl_o <= 4'b1000;  //li
		4'b0111: ALUCtrl_o <= 4'b0001;  //ori
		4'b0011: ALUCtrl_o <= 4'b0110;  //bne, bnez
		4'b1000: ALUCtrl_o <= 4'b0010;  //lw
		4'b1001: ALUCtrl_o <= 4'b0010;  //sw
		4'b0000: ALUCtrl_o <= 4'b0000;  //j, jal, nop
		4'b1010: ALUCtrl_o <= 4'b0110;  //ble
		4'b1011: ALUCtrl_o <= 4'b0110;  //bltz
	endcase
end

endmodule