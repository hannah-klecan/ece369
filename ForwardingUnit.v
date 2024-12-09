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

   // This always block is sensitive to any changes in the input signals.
    always @(*) begin
        // Initialize forwarding control signals to default values:
        // - ForwardA = 2'b00: No forwarding for ALU input A
        // - ForwardB = 1'b0: No forwarding for ALU input B
        ForwardA = 2'b00;
        ForwardB = 1'b0;

        // Hazard detection for EX_Rs (ALU input A)
        // If the MEM stage is writing to a register and the destination register matches EX_Rs:
        if (MEM_RegWrite != 2'b00 && MEM_RegWriteAddress != 5'b0 && MEM_RegWriteAddress == EX_Rs)
            ForwardA = 2'b10; // Forward data from the MEM stage to the EX stage for input A
        // If the WB stage is writing to a register and the destination register matches EX_Rs:
        else if (WB_RegWrite != 2'b00 && WB_RegWriteAddress != 5'b0 && WB_RegWriteAddress == EX_Rs)
            ForwardA = 2'b01; // Forward data from the WB stage to the EX stage for input A

        // Hazard detection for EX_Rt (ALU input B)
        // If the MEM stage is writing to a register and the destination register matches EX_Rt:
        if (MEM_RegWrite != 2'b00 && MEM_RegWriteAddress != 5'b0 && MEM_RegWriteAddress == EX_Rt)
            ForwardB = 1'b1; // Forward data from the MEM stage to the EX stage for input B
    end

endmodule