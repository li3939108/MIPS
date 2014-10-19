`timescale 1ns / 1ps

`define SLLFunc  6'b000000
`define SRLFunc  6'b000010
`define SRAFunc  6'b000011
`define ADDFunc  6'b100000
`define ADDUFunc 6'b100001
`define SUBFunc  6'b100010
`define SUBUFunc 6'b100011
`define ANDFunc  6'b100100
`define ORFunc   6'b100101
`define XORFunc  6'b100110
`define NORFunc  6'b100111
`define SLTFunc  6'b101010
`define SLTUFunc 6'b101011

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
`define ANDIOPCODE  6'b001100
`define LUIOPCODE   6'b001111
`define SLTIOPCODE  6'b001010
`define XORIOPCODE  6'b001110
`define ADDIUOPCODE 6'b001001
`define SLTIUOPCODE 6'b001011

module SingleCycleControl(RegDst, ALUSrc1,ALUSrc2, MemToReg, RegWrite,
MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode, FuncCode);

input wire [5:0] Opcode, FuncCode ;
output wire RegDst, ALUSrc1, ALUSrc2, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignExtend ;
output wire [3:0] ALUOp ;

//assign RegDst      = 1'bx;
//assign ALUSrc1     = 1'bx;
//assign ALUSrc2     = 1'bx;
//assign MemToReg    = 1'bx;
//assign MemRead     = 1'bx;
//assign MemWrite    = 1'bx;
//assign RegWrite    = 1'bx;
//assign Jump        = 1'bx;
//assign Branch      = 1'bx;
//assign SignExtend  = 1'bx;

assign 	Jump       = (Opcode == `JOPCODE   ? 1'b1 : 1'b0 );
assign 	Branch     = (Opcode == `BEQOPCODE ? 1'b1 : 1'b0 );
//assign 	SignExtend = ( (Opcode == `ADDIOPCODE or Opcode == `SLTIOPCODE) ? 1'b1 : 1'b0 );
assign  MemToReg   = ( Opcode == `LWOPCODE ? 1'b1 : 1'b0 );
assign MemRead     = ( Opcode == `LWOPCODE ? 1'b1 : 1'b0 );
//assign  RegDst     = ( Opcode == `RTYPEOPCODE ? 1'b1 : 1'b0 );


always@(*) begin
	
	casex(Opcode)
	`ORIOPCODE  :  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp   <= `OR  ;
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'b0 ;
	end
	`ADDIOPCODE :  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp   <= `ADD ;
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'b1 ;
	end
	`ADDIUOPCODE:  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp <= `ADDU  ;
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'b0 ;
	end
	`ANDIOPCODE :  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp <= `AND   ; 
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'b0 ;
	end
        `LUIOPCODE  :  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp <= `LUI   ;
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'bx ;
	end
        `SLTIOPCODE :  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp <= `SLT   ;
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'b1 ;
	end
        `SLTIUOPCODE:  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp <= `SLTU  ;
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'b0 ;
	end
        `XORIOPCODE :  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp <= `XOR   ;
		ALUSrc1 <= 1'b0 ;
		ALUSrc2 <= 1'b1 ;
		SignExtend <= 1'b0 ;
	end
	`RTYPEOPCODE:  begin
		MemWrite  <= 1'b0 ;
		RegDst <= 1'b1 ;
		RegWrite   <= 1'b1;
		SignExtend <= 1'bx ;
		ALUOp <= 4'b1111;
		case (FuncCode)
		`SLLFunc : begin
			ALUSrc1 <= 1'b1 ;
			ALUSrc2 <= 1'b1 ;
		end
		`SRLFunc : begin
			ALUSrc1 <= 1'b1 ;
			ALUSrc2 <= 1'b1 ;
		end
		`SRLFunc : begin
			ALUSrc1 <= 1'b1 ;
			ALUSrc2 <= 1'b1 ;
		end
		default  : begin
			ALUSrc1 <= 1'bx ;
			ALUSrc2 <= 1'b0 ;
		end
		endcase
	end
	`BEQOPCODE: begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b0;
		RegDst <= 1'bx ;
		ALUOp <= `SUB ;
		ALUSrc2 <= 1'b0 ;
		ALUSrc1 <= 1'bx ;
		SignExtend <= 1'b1 ;
	end
	`SWOPCODE:  begin
		MemWrite  <= 1'b1 ;
		RegWrite   <= 1'b0;
		RegDst <= 1'bx ;
		ALUop <= `ADD ;
		SignExtend <= 1'b1 ;
		ALUSrc2 <= 1'b1; 
		ALUSrc1 <= 1'b0 ;
	end
	`LWOPCODE:  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b1;
		RegDst <= 1'b0 ;
		ALUOp <= `ADD ;
		SignExtend <= 1'b1 ;
		ALUSrc2 <= 1'b1;
		ALUSrc1 <= 1'b0 ;
	end
	`JOPCODE:  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b0;
		RegDst <= 1'bx ;
		ALUOp <= 4'bxxxx;
		SignExtend <= 1'bx;
		ALUSrc1 <= 1'bx;
		ALUSrc2 <= 1'bx ;
	end
	default     :  begin
		MemWrite  <= 1'b0 ;
		RegWrite   <= 1'b0;
		RegDst <= 1'bx ;
		ALUOp <= 4'bxxxx;
		SignExtend <= 1'bx ;
		ALUSrc1 <= 1'bx;
		ALUSrc2 <= 1'bx ;
	end
	endcase
end

endmodule
