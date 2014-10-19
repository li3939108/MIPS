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

`define RTYPEOPCODE 6'b000000
`define LWOPCODE    6'b100011
`define SWOPCODE    6'b101011
`define BEQOPCODE   6'b000100
`define JOPCODE     6'b000010
`define ORIOPCODE   6'b001101
`define ADDIOPCODE  6'b001000
`define ADDIUOPCODE 6'b001001
`define ANDIOPCODE  6'b001100
`define LUIOPCODE   6'b001111
`define SLTIOPCODE  6'b001010
`define SLTIUOPCODE 6'b001011
`define XORIOPCODE  6'b001110

module SingleCycleControl(RegDst, ALUSrc1,ALUSrc2, MemToReg, RegWrite,
MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode);

input wire [5:0] Opcode ;
output wire RegDst, ALUSrc1, ALUSrc2, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignExtend ;
output wire [3:0] ALUOp ;

assign RegDst      = 1'bx;
assign ALUSrc1     = 1'bx;
assign ALUSrc2     = 1'bx;
assign MemToReg    = 1'bx;
assign RegWrite    = 1'bx;
assign MemRead     = 1'bx;
assign MemWrite    = 1'bx;
assign Branch      = 1'bx;
assign Jump        = 1'bx;
assign SignExtend  = 1'bx;

always@(*) begin
	casex(Opcode)
	`ORIOPCODE  :  ALUOp <= `OR    ;
	`ADDIOPCODE :  ALUOp <= `ADD   ;
	`ADDIUOPCODE:  ALUOp <= `ADDU  ;
	`ANDIOPCODE :  ALUOp <= `AND   ; 
        `LUIOPCODE  :  ALUOp <= `LUI   ;
        `SLTIOPCODE :  ALUOp <= `SLT   ;
        `SLTIUOPCODE:  ALUOp <= `SLTU  ;
        `XORIOPCODE :  ALUOp <= `XOR   ;
	`RTYPEOPCODE:  ALUOp <= 4'b1111;
	default     :  ALUOp <= 4'bxxxx;
	endcase
end

endmodule
