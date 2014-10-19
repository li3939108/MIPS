`timescale 1ns / 1ps

`define AND  4'b0000
`define OR   4'b0001
`define ADD  4'b0010
`define SLL  4'b0011
`define SRL  4'b0100
`define SUB  4'b0110
`define SLT  4'b0111
`define ADDU 4'b1000
`define SUBU 4'b1001
`define XOR  4'b1010
`define SLTU 4'b1011
`define NOR  4'b1100
`define SRA  4'b1101
`define LUI  4'b1110

module ALU(BusW, Zero, BusA, BusB, ALUCtrl
    );
input wire [31:0] BusA, BusB;
output reg [31:0] BusW;
input wire [3:0] ALUCtrl ;
output wire Zero ;

wire less;
wire [63:0] extendedBusA ;
wire [31:0] shiftedExtendedBusA ;


assign Zero = (BusW == 32'b0 ? 1'b1: 1'b0);
assign less = (BusA < BusB  ? 1'b1 : 1'b0) ;
assign extendedBusA = {{32{BusA[31]}} , BusA[31:0]} ;
assign shiftedExtendedBusA = extendedBusA >> BusB ;

always@(*)begin	
	
	case (ALUCtrl)
	`AND:   BusW <= BusA & BusB;
	`OR:    BusW <= BusA | BusB;
	`ADD:   BusW <= BusA + BusB;
	`ADDU:  BusW <= BusA + BusB;
	`SLL:   BusW <= BusA << BusB;
	`SRL:   BusW <= BusA >> BusB;
	`SUB:   BusW <= BusA - BusB;
	`SUBU:  BusW <= BusA - BusB;
	`XOR:   BusW <= BusA ^ BusB;
	`NOR:   BusW <= ~(BusA | BusB);
	`SLT:   BusW <= (( BusA - BusB ) & {1'b1, 31'b0} )>> 31 ;
	`SLTU:  BusW <= less ;
	`SRA:   BusW <= shiftedExtendedBusA;
	`LUI:   BusW <= BusB << 16 ;
	default:BusW <= 32'hxxxxxxxx;
	endcase
end
endmodule
