
`timescale 1ns / 1ps

module HazardDetectionUnit (
    input        Clk,                    // Clock signal
    input        Reset,                  // Reset signal
    input [4:0]  ID_Rs,                  // Source register 1 in ID stage
    input [4:0]  ID_Rt,                  // Source register 2 in ID stage
    input        ID_Branch,              // Branch instruction in ID stage
    input        ID_MemRead,             // Memory read signal in ID stage
    input        EX_MemRead,             // Memory read signal in EX stage
    input        EX_RegWrite,            // Register write signal in EX stage
    input        MEM_RegWrite,           // Register write signal in MEM stage
    input        MEM_ZeroANDBranch,      // Condition for branch execution in MEM stage
    input [1:0]  EX_RegDstSignal,        // Register destination control signal in EX stage
    input [4:0]  EX_Rs,                  // Source register 1 in EX stage
    input [4:0]  EX_Rt,                  // Source register 2 in EX stage
    input [4:0]  EX_Rd,                  // Destination register in EX stage
    input [4:0]  MEM_RegDst,             // Destination register in MEM stage
    input [1:0]  ForwardA,               // Forwarding control signal for ALU input A
    input       ID_Jump,                 // Jump instruction signal in ID stage
    input       ID_Jal,                  // Jump and Link (JAL) instruction in ID stage
    input [1:0] ID_PCSrc,                // PC source control signal in ID stage
    input [1:0] MEM_PCSrc,               // PC source control signal in MEM stage
    output reg   ID_Stall,               // Stall signal for ID stage
    output reg   Flush_IF_ID             // Flush signal for IF/ID pipeline register
);

    reg EXStall, MEMStall, BranchStall;  // Intermediate stall signals
    reg [4:0] StallCounter;              // Counter for multi-cycle stalls

    // Initialize all relevant signals
    initial begin
        ID_Stall     <= 0;               // No stall initially
        EXStall      <= 0;               // No EX-stage stall initially
        MEMStall     <= 0;               // No MEM-stage stall initially
        BranchStall  <= 0;               // No branch-related stall initially
        Flush_IF_ID  <= 0;               // No pipeline flush initially
        StallCounter <= 0;               // Stall counter set to 0 initially
    end

    // Detect hazards (combinational logic)
    always @(*) begin
        EXStall = 0;                     // Reset EX stall flag
        MEMStall = 0;                    // Reset MEM stall flag
        BranchStall = 0;                 // Reset branch stall flag
    
        // Check for branch, jump, or JR instruction hazards
        if (ID_Branch || ID_Jump || ID_Jal || ID_PCSrc == 2'b11) begin
            BranchStall = 1;             // Stall if branch, jump, or JR instruction detected
        end

        // Detect EX to ID hazards (load-use hazard)
        if (EX_MemRead) begin
            if ((EX_Rt == ID_Rs || EX_Rt == ID_Rt) && (EX_Rt != 0)) begin
                EXStall = 1;             // Stall if data hazard detected between EX and ID stages
            end
        end

        // Detect MEM to ID hazards
        if (MEM_RegWrite) begin
            if ((MEM_RegDst == ID_Rs || MEM_RegDst == ID_Rt) && (MEM_RegDst != 0)) begin
                MEMStall = 1;            // Stall if data hazard detected between MEM and ID stages
            end
        end
    end

    // Sequential logic for multi-cycle stall and flush control
    always @(EXStall, MEMStall, BranchStall) begin
        // If any stall condition is detected, start a multi-cycle stall
        if (EXStall || MEMStall || BranchStall) begin
            StallCounter <= 5;           // Set stall counter for multi-cycle stall
            ID_Stall <= 1;               // Assert stall signal for ID stage
            if (BranchStall) begin
                Flush_IF_ID <= 1;        // Flush the IF/ID pipeline register for branch instructions
            end
        end 
    end
    
    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            // Reset all signals on reset
            ID_Stall     <= 0;
            Flush_IF_ID  <= 0;
            StallCounter <= 0;
        end 
        else begin
            if (ForwardA == 2'b01) begin
                // Stop stalling if data is forwarded from WB stage
                StallCounter <= 0;
                ID_Stall <= 0;
            end
            else if (MEM_PCSrc == 2'b11) begin
                // Stop stalling for JR instruction
                StallCounter <= 0;
                ID_Stall <= 0;
            end
            else if (StallCounter > 0) begin
                // Decrement stall counter during multi-cycle stalls
                StallCounter <= StallCounter - 1;
                ID_Stall <= 1;           // Keep stalling
                Flush_IF_ID <= 1;        // Keep flushing pipeline during stall
            end 
            else begin
                // Clear stall and flush signals when stall counter reaches 0
                ID_Stall <= 0;
                Flush_IF_ID <= 0;
            end
        end
    end

endmodule