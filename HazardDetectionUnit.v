
`timescale 1ns / 1ps

module HazardDetectionUnit (
    input Clk,
    input Reset,
    input [4:0] ID_Rs,
    input [4:0] ID_Rt,
    input       ID_MemRead,
    input       EX_MemRead,
    input       EX_RegWrite,
    input       MEM_RegWrite,
    input [1:0] EX_RegDstSignal,
    input [4:0] EX_Rt,
    input [4:0] EX_Rd,
    input [4:0] MEM_RegDst,
    output reg  ID_Stall,
    output reg  Flush_IF_ID
);

    reg EXStall, MEMStall;

    // Initialize all relevant signals
    initial begin
        ID_Stall <= 0;
        EXStall  <= 0;
        MEMStall <= 0;
        Flush_IF_ID <= 0;
    end

    always @(*) begin
        EXStall = 0;
        MEMStall = 0;

        // Detect EX to ID hazards
        if (EX_RegWrite) begin
            case (EX_RegDstSignal)
                0: begin // Rt is write destination
                    if ((EX_Rt == ID_Rs || EX_Rt == ID_Rt) && (EX_Rt != 0)) begin
                        EXStall = 1;
                    end
                end
                1: begin // Rd is write destination
                    if ((EX_Rd == ID_Rs || EX_Rd == ID_Rt) && (EX_Rd != 0)) begin
                        EXStall = 1;
                    end
                end
                default: EXStall = 0;
            endcase
        end

        // Detect MEM to ID hazards
        if (MEM_RegWrite) begin
            if ((MEM_RegDst == ID_Rs || MEM_RegDst == ID_Rt) && (MEM_RegDst != 0)) begin
                MEMStall = 1;
            end
        end
    end

    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            ID_Stall <= 0;
            Flush_IF_ID <= 0;
        end else begin
            // Update stall and flush signals
            ID_Stall <= EXStall || MEMStall;
            Flush_IF_ID <= EXStall || MEMStall; // Optionally flush IF/ID
        end
    end

endmodule

