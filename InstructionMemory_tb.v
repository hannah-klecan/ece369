`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: InstructionMemory_tb
// Project Name: 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory_tb(); 

    wire [31:0] Instruction;

    reg [31:0] Address;

	InstructionMemory u0(
		.Address(Address),
        .Instruction(Instruction)
	);

	initial begin
	
        Address = 32'b0;
        #10 Address = 32'd4;
        #10 Address = 32'd8;
        #10 Address = 32'd12;
        #10 Address = 32'd16;
        #10 Address = 32'd20;
        #10 Address = 32'd24;
	
	end

endmodule
