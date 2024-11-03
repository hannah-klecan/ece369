`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: RegisterFile_tb
// 
//////////////////////////////////////////////////////////////////////////////////


module RegisterFile_tb();

	reg [4:0] ReadRegister1;
	reg [4:0] ReadRegister2;
	reg	[4:0] WriteRegister;
	reg [31:0] WriteData;
	reg RegWrite;
	reg Clk;

	wire [31:0] ReadData1;
	wire [31:0] ReadData2;


	RegisterFile u0(
		.ReadRegister1(ReadRegister1), 
		.ReadRegister2(ReadRegister2), 
		.WriteRegister(WriteRegister), 
		.WriteData(WriteData), 
		.RegWrite(RegWrite), 
		.Clk(Clk), 
		.ReadData1(ReadData1), 
		.ReadData2(ReadData2)
	);

	initial begin
		Clk <= 1'b0;
		forever #10 Clk <= ~Clk;
	end

	initial begin
	
    
    ReadRegister1 <= 0;
    ReadRegister2 <= 0;
    WriteRegister <= 0;
    RegWrite <= 0;
    WriteData <= 0;
    #5;
    WriteRegister <= 1;
    WriteData <= 25;
    RegWrite <= 1;
    ReadRegister1 <= 1;
    #5;
    WriteRegister <= 2;
    ReadRegister2 <= 2;
    #5;
    RegWrite <= 0;
    ReadRegister1 <= 5;
	
	end

endmodule
