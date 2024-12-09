
`timescale 1ns / 1ps

module HazardDetectionUnit (
    input        Clk,
    input        Reset,
    input [4:0]  ID_Rs,
    input [4:0]  ID_Rt,
    input        ID_Branch,
    input        ID_MemRead,
    input        EX_MemRead,
    input        EX_RegWrite,
    input        MEM_RegWrite,
    input [1:0]  EX_RegDstSignal,
    input [4:0]  EX_Rs,
    input [4:0]  EX_Rt,
    input [4:0]  EX_Rd,
    input [4:0]  MEM_RegDst,
    input [1:0] ForwardA,
    output reg   ID_Stall,
    output reg   Flush_IF_ID
);

    reg EXStall, MEMStall, BranchStall;
    reg [1:0] StallCounter; // Counter for multi-cycle stalls

    // Initialize all relevant signals
    initial begin
        ID_Stall     <= 0;
        EXStall      <= 0;
        MEMStall     <= 0;
        BranchStall  <= 0;
        Flush_IF_ID  <= 0;
        StallCounter <= 0;
    end

    // Detect hazards (combinational logic)
    always @(*) begin
        EXStall = 0;
        MEMStall = 0;
        BranchStall = 0;
    
        if (ID_Branch) begin
            BranchStall = 1;
        end

        // Detect EX to ID hazards
        if (EX_MemRead) begin
            if ((EX_Rt == ID_Rs || EX_Rt == ID_Rt) && (EX_Rt != 0)) begin
                EXStall = 1; // Stall due to load-use hazard
            end
        end

        // Detect MEM to ID hazards
        if (MEM_RegWrite) begin
            if ((MEM_RegDst == ID_Rs || MEM_RegDst == ID_Rt) && (MEM_RegDst != 0)) begin
                MEMStall = 1;
            end
        end
    end

    // Sequential logic for multi-cycle stall and flush control
    always @(EXStall, MEMStall, BranchStall) begin
            // If a hazard is detected, start a multi-cycle stall
            if (EXStall || MEMStall || BranchStall) begin
                StallCounter <= 2; // Two-cycle stall for load-use hazard
                ID_Stall <= 1;
                if(BranchStall) begin
                    Flush_IF_ID <= 1; // Flush IF/ID
                end
            end 
//            if(BranchStall) begin
//                ID_Stall <= 1;
//            end
    end
    
    always @(posedge Clk, posedge Reset) begin
        if (Reset) begin
            ID_Stall     <= 0;
            Flush_IF_ID  <= 0;
            StallCounter <= 0;
        end 
        else begin
            if(ForwardA == 2'b01) begin
                StallCounter <= 0;              //Stop Stalling if forwarding from WB
                ID_Stall <= 0;
            end
            if (StallCounter > 0) begin
                // Decrement stall counter during multi-cycle stalls
                StallCounter <= StallCounter - 1;
                ID_Stall <= 1;
//                Flush_IF_ID <= 1; // Continue flushing during stall
            end 
            else begin
                // Clear stall and flush signals when the stall counter reaches 0
                ID_Stall <= 0;
                Flush_IF_ID <= 0;
            end
        end
    end

endmodule


