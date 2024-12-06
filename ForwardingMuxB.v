module ForwardingMuxB(
    input [31:0] EX_ReadData2,      // Register value from EX stage
    input [31:0] SignExtension,
    input [31:0] MEM_ALUResult,    // ALU result from MEM stage
    input [1:0] ForwardB,          // Forwarding control signal
    input [3:0] ALUControl,        // control bits for ALU operation
    output reg [31:0] ALUInput2    // ALU input B
);

    always @(*) begin
        case (ForwardB)
            2'b00: ALUInput2 = EX_ReadData2;   // No forwarding
            2'b01: ALUInput2 = SignExtension;  // No forwarding, use Sign extend
            2'b10: ALUInput2 = MEM_ALUResult; // Forward from MEM stage
            2'b11: ALUInput2 = MEM_ALUResult; // Forward from MEM stage
            default: ALUInput2 = EX_ReadData2; // Default case
        endcase
    end

endmodule