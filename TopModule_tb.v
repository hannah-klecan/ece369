`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: TopModule_tb
// 
//////////////////////////////////////////////////////////////////////////////////

module TopModule_tb();
    reg Clk;
    reg Reset;
    wire [31:0] PCResult;
    wire [31:0] WriteData;
//    wire [5:0] ShiftCheck;
//    wire [5:0] Instr;
//    wire [31:0] ReadData;
//    wire [3:0] ALUControlOut; 

//    TopModule _top(Clk, Reset, PCResult, WriteData); 
    
    TopModule test1(
        .Clk(Clk), .Reset(Reset), .PCResult(PCResult) , .WriteData(WriteData) );
//       , .ShiftCheck(ShiftCheck), .Instr(Instr), .ReadData(ReadData), . ALUControlOut(ALUControlOut));
     
    initial begin
		Clk <= 1'b0;
		Reset <= 1;
		#100;
		Clk <= 1;
		#50;
		Reset <= 0;
		#50;
		Clk <= 0;
		
		forever #100 Clk <= ~Clk;
	end

endmodule
