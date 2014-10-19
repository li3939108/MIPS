`timescale 1 ns / 1 ps
`include "ALU.v"
`include "RegisterFile.v"
`include "DataMemory.v"
`include "ALUControl.v"
`include "SingleCycleControl.v"
`include "InstructionMemory.v"

module SingleCycleProc(CLK, Reset_L, startPC, dMemOut);

input wire CLK, Reset_L ;
input wire [31:0] startPC ;
output wire [31:0] dMemOut ;

wire [31:0] im_DataOut, BusW, dm_DataOut, dm_DataIn, ALUout, BusA, BusB, ALUinA, ALUinB, 
	signExtended, pc_plus4, pc_after_branch, pc_next;
reg [31:0] pc;
wire [4:0] RW;
wire RegDst, RegSrc, MemRead, MemWrite, SignExtend, BranchCtrl, Zero, BranchSel, Jump, RegWrite, ALUSrc1, ALUSrc2;
wire [5:0]  FuncCode ;
wire [3:0] ALUOp, ALUCtrl ;

assign dMemOut = dm_DataOut ;

assign signExtended = (SignExtend == 1'b1 ? 
	{{16{im_DataOut[15]}}, im_DataOut[15:0]} : 
	{16'b0,im_DataOut[15:0]}) ;

InstructionMemory im(
	.Data(im_DataOut), 
	.Address(pc)
);

assign dm_DataIn = BusB ;
DataMemory dm(
	.ReadData(dm_DataOut), 
	.Address(ALUout), 
	.WriteData(dm_DataIn), 
	.MemoryRead(MemRead), 
	.MemoryWrite(MemWrite), 
	.Clock(CLK)
);

assign RW = (RegDst == 1'b1 ? im_DataOut[15:11] : im_DataOut[20:16] );
assign BusW = (RegSrc == 1'b1 ? dm_DataOut : ALUout) ;
RegisterFile rf(
	.Clk(CLK), 
	.RegWr(RegWrite), 
	.BusA(BusA), 
	.BusB(BusB), 
	.BusW(BusW), 
	.RA(im_DataOut[25:21]), 
	.RB(im_DataOut[20:16]), 
	.RW(RW)
);

assign ALUinA = (ALUSrc1 == 1'b1 ? {27'b0, im_DataOut[10:6]} : BusA ) ;
assign ALUinB = (ALUSrc2 == 1'b1 ? signExtended : BusB ) ;
ALU alu(
	.BusW(ALUout), 
	.Zero(Zero), 
	.BusA(ALUinA), 
	.BusB(ALUinB), 
	.ALUCtrl(ALUCtrl)
);

assign FuncCode = signExtended[5:0] ;
ALUControl ALUCtl(
	.ALUCtrl(ALUCtrl), 
	.ALUOp(ALUOp), 
	.FuncCode(FuncCode) 
) ;

SingleCycleControl scc(
	.RegDst(RegDst), 
	.ALUSrc1(ALUSrc1),
	.ALUSrc2(ALUSrc2), 
	.MemToReg(RegSrc), 
	.RegWrite(RegWrite),
	.MemRead(MemRead), 
	.MemWrite(MemWrite), 
	.Branch(BranchCtrl), 
	.Jump(Jump), 
	.SignExtend(SignExtend), 
	.ALUOp(ALUOp), 
	.Opcode(im_DataOut[31:26]),
	.FuncCode(FuncCode)
);

assign BranchSel = BranchCtrl & Zero ;
assign pc_after_branch = (BranchSel == 1'b1 ? (signExtended << 2 ) + pc_plus4 : pc_plus4 ) ;
assign pc_next = (Jump == 1'b1 ?  {pc_plus4[31:28], im_DataOut[25:0], 2'b00} : pc_after_branch ) ;
assign pc_plus4 = pc + 32'd4 ;

always@(negedge CLK or negedge Reset_L)begin
	if(Reset_L == 1'b0)begin
		pc <= startPC ;
	end else begin
		pc <= pc_next ;
	end
end

endmodule
