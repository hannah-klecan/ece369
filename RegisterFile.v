`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Module Name: RegisterFile
// Project Name: 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    input[4:0] ReadRegister1;
    input[4:0] ReadRegister2;
    input[4:0] WriteRegister;
    input[31:0] WriteData;
    input [1:0] RegWrite;
    output reg [31:0] ReadData1;
    output reg [31:0] ReadData2;
    input Clk;
	
	
	reg [31:0] registers [31:0];
	
	initial begin
        registers[0]  <= 32'd0;
        registers[1]  <= 32'd0;
        registers[2]  <= 32'd0;
        registers[3]  <= 32'd0;
        registers[4]  <= 32'd0;
        registers[5]  <= 32'd0;
        registers[6]  <= 32'd0;
        registers[7]  <= 32'd0;
        registers[8]  <= 32'd0;
        registers[9]  <= 32'd0;
        registers[10] <= 32'd0;
        registers[11] <= 32'd0;
        registers[12] <= 32'd0;
        registers[13] <= 32'd0;
        registers[14] <= 32'd0;
        registers[15] <= 32'd0;
        registers[16] <= 32'd0;
        registers[17] <= 32'd0;
        registers[18] <= 32'd0;
        registers[19] <= 32'd0;
        registers[20] <= 32'd0;
        registers[21] <= 32'd0;
        registers[22] <= 32'd0;
        registers[23] <= 32'd0;
        registers[24] <= 32'd0;
        registers[25] <= 32'd0;
        registers[26] <= 32'd0;
        registers[27] <= 32'd0;
        registers[28] <= 32'd0;
        registers[29] <= 32'd0;
        registers[30] <= 32'd0;
        registers[31] <= 32'd0;
	end
	
	always @(posedge Clk)begin
	   if(RegWrite == 1)begin  //Regular Write 32'b
	       registers[WriteRegister] <= WriteData;
	   end
	   else if(RegWrite == 2)begin //lb
	       if(WriteData[7])begin   
	           registers[WriteRegister] <= {24'b1, WriteData[7:0]};
	       end
	       else begin
	           registers[WriteRegister] <= {24'b0, WriteData[7:0]};
	       end
	   end
	   else if(RegWrite == 3)begin //lh
	       if(WriteData[15])begin   
	           registers[WriteRegister] <= {16'b1, WriteData[15:0]};
	       end
	       else begin
	           registers[WriteRegister] <= {16'b0, WriteData[15:0]};
	       end
	   end

	end
	
	always @(negedge Clk) begin
	   ReadData1 = registers[ReadRegister1];
	   ReadData2 = registers[ReadRegister2];
	end

endmodule
