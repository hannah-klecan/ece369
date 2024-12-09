module ForwardingMuxA(
    input [31:0] EX_ReadData1,      // Register value from EX stage
    input [31:0] MEM_ALUResult,    // ALU result from MEM stage
    input [31:0] WB_WBToWD,        // Write-back data from WB stage
    input [1:0] ForwardA,          // Forwarding control signal
    input [3:0] ALUControl, // control bits for ALU operation
    output reg [31:0] ALUInputA    // ALU input A
);

    always @(ForwardA, ALUInputA, EX_ReadData1, MEM_ALUResult, WB_WBToWD, ALUControl) begin
        case (ForwardA)
            2'b00: ALUInputA = EX_ReadData1;  // No forwarding
            2'b10: ALUInputA = MEM_ALUResult; // Forward from MEM stage
            2'b01: ALUInputA = WB_WBToWD;     // Forward from WB stage
            default: ALUInputA = EX_ReadData1; // Default case
        endcase
    end

endmodule