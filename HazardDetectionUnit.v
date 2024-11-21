
`timescale 1ns / 1ps

module HazardDetectionUnit (
    input [4:0] ID_Rs,
    input [4:0] ID_Rt,
    input [1:0] ID_MemRead,
    input [1:0] EX_RegWrite,
    input [1:0] EX_RegDstSignal,
    input [4:0] EX_Rt,
    input [4:0] EX_Rd,
    input [1:0] MEM_RegWrite,
    input [4:0] MEM_RegDst,
    output reg ID_Stall
);

    // Internal signals to detect hazards in EX and MEM stages.
    reg EXStall, MEMStall;
    
    initial begin
        // Initialize stall signal to 0 (no stall initially).
        ID_Stall <= 0;
 
    end

    always @(ID_Rs, ID_Rt, ID_MemRead, EX_RegWrite, EX_RegDstSignal, EX_Rt, EX_Rd, MEM_RegWrite, MEM_RegDst) begin

        EXStall = 0;
        MEMStall = 0;
        
        //Detecting EX to ID Hazards
        /// Check if the EX stage is writing to a register.
        if (EX_RegWrite) begin
            // Rt is the destination register for the EX stage instruction.
            case (EX_RegDstSignal)
                //Destination register is Rd, used for R-type instructions  
                0:begin //Rt is WriteDestination for EX Instruction
                    if ((EX_Rt == ID_Rs || (EX_Rt == ID_Rt && ID_MemRead == 0)) && (EX_Rt != 0)) begin 
                        // Hazard occurs if EX_Rt matches either ID_Rs or ID_Rt (when not a memory-read) and EX_Rt is not $zero as we cannot write to zero reg.
                        //EX destination reg Rt matches source reg Rs of the instruction ID OR
                        //Ex desitination reg Rt matches ID Rt if the ID instruction is not a memory read. 
                        EXStall <= 1; 
                    end
                    
                end
                //Destination register is Rt, I-type instructions such as addi
                1:begin // Rd is the destination register for the EX stage instruction.
                    if ((EX_Rd == ID_Rs || (EX_Rd == ID_Rt && ID_MemRead == 0)) && (EX_Rd != 0)) begin
                        // Hazard occurs if EX_Rd matches either ID_Rs or ID_Rt (when not a memory-read) and EX_Rd is not $zero.
                        // EX instruction destination reg Rd matches source reg Rs of the instruction ID
                        //Ex desitination reg Rt matches ID Rt if the ID instruction is not a memory read. 
                        EXStall <= 1; // Set EXStall to 1 to indicate a hazard.
                    end
                end 
            endcase
        end
        //Detecting MEM to ID Hazards
        // Check if the MEM stage is writing to a register.
        if (MEM_RegWrite) begin
            if ((MEM_RegDst == ID_Rs || (MEM_RegDst == ID_Rt && ID_MemRead == 0)) && (MEM_RegDst != 0)) begin
            // Hazard occurs if MEM_RegDst matches either ID_Rs or ID_Rt (when not a memory-read) and MEM_RegDst is not $zero.
                MEMStall <= 1; // Set MEMStall to 1 to indicate a hazard.
            end
        end

    end
    
    // Always block triggered when EXStall or MEMStall changes.
    always @(EXStall, MEMStall) begin
        // Stall the pipeline if a hazard is detected in either EX or MEM stage.
        if (EXStall || MEMStall) begin
            ID_Stall <= 1;
        end
        else begin
            // No hazard detected; continue normal operation.
            ID_Stall <= 0;
        end
    end

endmodule
