`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 07:00:42 PM
// Design Name: 
// Module Name: ForwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ForwardingUnit(
    input [4:0] EX_Rs,        // Source register 1 in EX stage
    input [4:0] EX_Rt,        // Source register 2 in EX stage
    input [4:0] MEM_RegWriteAddress,  // Destination register in MEM stage
    input [4:0] WB_RegWriteAddress,   // Destination register in WB stage
    input [1:0] MEM_RegWrite,         // RegWrite signal in MEM stage
    input [1:0] WB_RegWrite,          // RegWrite signal in WB stage
    output reg [1:0] ForwardA,        // Forwarding control for ALU input A
    output reg ForwardB               // Forwarding control for ALU input B
);

    always @(*) begin
        // Default: no forwarding
        ForwardA = 2'b00;
        ForwardB = 1'b0;

        // Check for hazards for EX_Rs (ALU input A)
        if (MEM_RegWrite != 2'b00 && MEM_RegWriteAddress != 5'b0 && MEM_RegWriteAddress == EX_Rs)
            ForwardA = 2'b10; // Forward from MEM stage
        else if (WB_RegWrite != 2'b00 && WB_RegWriteAddress != 5'b0 && WB_RegWriteAddress == EX_Rs)
            ForwardA = 2'b01; // Forward from WB stage


        // Check for hazards for EX_Rt (ALU input B)
        if (MEM_RegWrite != 2'b00 && MEM_RegWriteAddress != 5'b0 && MEM_RegWriteAddress == EX_Rt)
            ForwardB = 1'b1; // Forward from MEM stage
    end

endmodule