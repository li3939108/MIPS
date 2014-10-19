`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:03:35 10/01/2014 
// Design Name: 
// Module Name:    DataMemory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DataMemory(ReadData, Address, WriteData, MemoryRead, MemoryWrite, Clock
    );
	 
output reg [31:0] ReadData ;
input wire [5:0] Address ;
input wire [31:0] WriteData ;
input wire MemoryWrite;
input wire MemoryRead;
input wire Clock ;

reg [31:0] data [0:63] ;

always@(negedge Clock)begin
	if(MemoryWrite == 1'b1)begin
		data[Address ] <= WriteData ;
	end
end

always@(posedge Clock) begin
	if(MemoryRead == 1'b1)begin
		ReadData <= data[Address] ;
	end else begin
		ReadData <= ReadData ;
	end
end

endmodule
