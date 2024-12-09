`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members:
// Seti 50%
// Hannah 50%
// 
// ECE369A - Computer Architecture
////////////////////////////////////////////////////////////////////////////////

module TopModule(Clk, Reset, PCResult, WriteData); 

   input Clk;
   input Reset;
//    output [7:0]en_out;
//    output [6:0]out7;
   wire ClkOut = Clk;
   output [31:0] PCResult;       // Output for PC count
   output [31:0] WriteData;      // Output for write-back data
    
   // ClkDiv _ClkDiv(Clk, Reset, ClkOut);
   //Two4DigitDisplay _Two4DigitDisplay(Clk,PCResult, WriteData
  // Two4DigitDisplay _Two4DigitDisplay(Clk, ID_WriteData[15:0], WB_PCAddResult[15:0] - 4, out7, en_out);

    //IF Wires
    wire [31:0] IF_PCInput;
    wire [31:0] IF_PCOutput;
    wire [31:0] IF_Instruction;
    wire [31:0] IF_PCAddResult;
    wire IF_PCSrcSelector;
    
    //ID Wires
    wire [31:0] ID_PCAddResult;
    wire [31:0] ID_Instruction;
    wire [31:0] ID_SEOutput;
    wire [31:0] ID_PCOutput;
    wire [31:0] ID_WriteData;
    wire [1:0] ID_PCSrc;
    wire ID_MemToReg;
    wire [1:0] ID_MemRead;
    wire [1:0]ID_MemWrite;
    wire ID_Branch;
    wire ID_ALUSrc;
    wire [3:0] ID_ALUOp;
    wire [1:0] ID_RegWrite;
    wire ID_Jal;
    wire [1:0] ID_RegDst;
    wire [31:0] ID_ReadData1;
    wire [31:0] ID_ReadData2;
    wire ID_Shift;
    wire ID_Stall;
    wire Flush_IF_ID;
    
    //EX Wires
    wire [4:0] EX_Rs;
    wire [1:0] EX_PCSrc;
    wire EX_MemToReg;
    wire [1:0] EX_MemRead;
    wire [1:0]EX_MemWrite;
    wire EX_Branch;
    wire EX_ALUSrc;
    wire [3:0] EX_ALUOp;
    wire [1:0]EX_RegWrite;
    wire [31:0] EX_ReadData1;
    wire [31:0] EX_ReadData2;
    wire [31:0] EX_SEOutput;
    wire [25:0] EX_Instruction26b;
    wire [31:0] EX_PCOutput;
    wire EX_Jal;
    wire [1:0] EX_RegDst;
    wire [31:0] EX_PCAddResult;
    wire [31:0] EX_ALUSrcOutput;
    wire [3:0] EX_ALUControlOutput;
    wire [31:0] EX_JumpOutput;
    wire [31:0] EX_ALUResult;
    wire EX_Zero;
    wire [31:0] EX_ShiftOutput;
    wire [31:0] EX_BranchAdderOutput;
    wire [4:0] EX_RegWriteAddress;
    wire EX_Shift;
    wire [31:0] EX_ALUInput1;
    wire [31:0] EX_ALUInput2;
    wire [1:0] ForwardA;           // Forwarding control signal for ALU input A
    wire ForwardB;                 // Forwarding control signal for ALU input B
    
    //MEM Wires
    wire MEM_MemToReg;
    wire [1:0] MEM_MemRead;
    wire [1:0]MEM_MemWrite;
    wire [1:0]MEM_RegWrite;
    wire MEM_Jal;
    wire [4:0] MEM_RegWriteAddress;
    wire [31:0] MEM_ALUResult;
    wire MEM_Zero;
    wire [31:0] MEM_ReadData2;
    wire [31:0] MEM_PCAddResult;
    wire [31:0] MEM_JumpOutput;
    wire [31:0] MEM_BranchAdderOutput;
    wire [31:0] MEM_MemReadData;
    wire MEM_ZeroANDBranch;
    wire [1:0] MEM_PCSrc;
    wire [31:0] MEM_ReadData1;
    
    //WB Wires
    wire WB_MemToReg;
    wire [1:0]WB_RegWrite;
    wire WB_Jal;
    wire [4:0] WB_RegWriteAddress;
    wire [31:0] WB_ALUResult;
    wire [31:0] WB_PCAddResult;
    wire [31:0] WB_MemReadData;
    wire [31:0] WB_WBToWD;
    
   
 
    // IF
    // ProgramCounter(Clk, Reset, input_address, output_address)
    ProgramCounter _PC(
        ClkOut, 
        Reset, 
        IF_PCInput,
        ID_Stall, 
        IF_PCOutput);
        
    // PCAdder(PCResult, PCAddResult)
    PCAdder _PCAdder(
    
       IF_PCOutput,    // Input should be current PC value
       IF_PCAddResult  // Output is PC+4
       );
        
    // Or(inA, inB, Out)
    Or _Or(
        MEM_PCSrc[0], 
        MEM_ZeroANDBranch,
        IF_PCSrcSelector
        );
        
    // Mux32bits4to1(A, B, C, D, Src, Out)
    Mux32bits4to1 _PCSrcMux( 
        IF_PCAddResult,
        MEM_BranchAdderOutput, 
        MEM_JumpOutput, 
        MEM_ReadData1, 
        {MEM_PCSrc[1], IF_PCSrcSelector},
        IF_PCInput);
        
    // InstructionMemory(Address, Instruction)
    InstructionMemory _IM(
        IF_PCOutput, 
        IF_Instruction);

    //IF/ID Register
    IF_IDRegister IF_IDReg(
        ClkOut, 
        Reset, 
        IF_Instruction, 
        IF_PCOutput, 
        IF_PCAddResult,
        ID_Stall,
        Flush_IF_ID,
        ID_Branch, 
        ID_Instruction,
        ID_PCOutput, 
        ID_PCAddResult);

    //ID
    // Controller(Instruction, ShiftCheck, RegWrite, ALUSrc,
    //  ALUOp, RegDst, MemWrite, MemRead, MemtoReg, PCSrc, Jal, Branch, Shift)
    Controller _Controller(
        ID_Instruction[31:26], 
        ID_Instruction[5:0],
        ID_RegWrite, 
        ID_ALUSrc, 
        ID_ALUOp, 
        ID_RegDst, 
        ID_MemWrite, 
        ID_MemRead, 
        ID_MemToReg, 
        ID_PCSrc, 
        ID_Jal, 
        ID_Branch, 
        ID_Shift);
        
    // Mux32bits2to1(inA, inB, Sel, Out)
    Mux32bits2to1 _JalMux(    // checked 
        WB_WBToWD, 
        WB_PCAddResult, 
        WB_Jal,
        ID_WriteData);
        
    // RegisterFile(ReadRegister1, ReadRegister2,
    // WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2)
    RegisterFile _Register(
        ID_Instruction[25:21], 
        ID_Instruction[20:16], 
        WB_RegWriteAddress,
        ID_WriteData, 
        WB_RegWrite, 
        ClkOut, 
        ID_ReadData1, 
        ID_ReadData2);
    
    // SignExtension(in, out) 
    SignExtension _SE(
        ID_Instruction[15:0], 
        ID_SEOutput);

   // HazardDetection(ID_Rs, ID_Rt, ID_MemRead, EX_RegWrite,
   // EX_RegDstSignal, EX_Rt, EX_Rd, MEM_RegWrite, MEM_RegDst, ID_Stall)
//   HazardDetectionUnit _HDU(
//        ID_Instruction[25:21],
//        ID_Instruction[20:16],
//        ID_MemRead,
//        EX_RegWrite,
//        EX_RegDst,
//        EX_Instruction26b[20:16],
//        EX_Instruction26b[15:11],
//        MEM_RegWrite,
//        MEM_RegWriteAddress,
//        ID_Stall
//    );

    HazardDetectionUnit _HDU(
            ClkOut,
            Reset,
            ID_Instruction[25:21],
            ID_Instruction[20:16],
            ID_Branch,
            ID_MemRead,
            EX_MemRead,
            EX_RegWrite,
            MEM_RegWrite,
            MEM_ZeroANDBranch,
            EX_RegDst,
            EX_Rs,
            EX_Instruction26b[20:16],
            EX_Instruction26b[15:11],
            MEM_RegWriteAddress,
            ForwardA,
            ID_Stall,
            Flush_IF_ID
        );

    //ID/EX Register
    ID_EXRegister ID_EXReg(
        ClkOut,
        Reset,
        ID_PCSrc,
        ID_MemToReg,
        ID_MemRead,
        ID_MemWrite,
        ID_Branch,
        ID_ALUSrc,
        ID_ALUOp,
        ID_RegWrite,
        ID_ReadData1,
        ID_ReadData2,
        ID_SEOutput,
        ID_Instruction[25:21],
        ID_Instruction[25:0],
        ID_PCOutput,
        ID_Jal,
        ID_RegDst,
        ID_PCAddResult,
        ID_Shift,
        ID_Stall,
        EX_PCSrc,
        EX_MemToReg,
        EX_MemRead,
        EX_MemWrite,
        EX_Branch,
        EX_ALUSrc,
        EX_ALUOp,
        EX_RegWrite,
        EX_ReadData1,
        EX_ReadData2,
        EX_SEOutput,
        EX_Rs,
        EX_Instruction26b,
        EX_PCOutput,
        EX_Jal,
        EX_RegDst,
        EX_PCAddResult,
        EX_Shift
);

    //EX
    
    // Sll(in, out)
    Sll _Shift( 
        EX_SEOutput, 
        EX_ShiftOutput);
        
    // Adder(inA, inB, Out)
    Adder _BranchAdder(
        EX_PCAddResult, 
        EX_ShiftOutput,
        EX_BranchAdderOutput);
    
    // Mux32bits2to1(inA, inB, Sel, Out)
//    Mux32bits2to1 _ShiftMux( //  checked           // Changed Not needed
//        EX_ReadData1, 
//        EX_ReadData2, 
//        EX_Shift,
//        EX_ALUInput1);
        
    // Srl(in, out)
//    Srl _Shiftright (                     // Changed Not needed
//        EX_ALUInput1,
//        EX_AlUInput1 // shifted
//    );

//    // Mux32bits2to1(inA, inB, Sel, Out)
//    Mux32bits2to1 _ALUSrcMux( 
//        EX_ReadData2, 
//        EX_SEOutput, 
//        EX_ALUSrc,
//        EX_ALUSrcOutput);

    // Forwarding Unit instantiation
    ForwardingUnit _ForwardingUnit (
        EX_Rs,
        EX_Instruction26b[20:16],
        MEM_RegWriteAddress,
        WB_RegWriteAddress,
        MEM_RegWrite,
        WB_RegWrite,
        ForwardA,
        ForwardB);
        
    // Mux5bits3to1(inA, inB, inC, Sel, Out)
    ForwardingMuxA _ForwardingMuxA(
       EX_ReadData1,
       MEM_ALUResult,
       WB_WBToWD,
       ForwardA,
       EX_ALUControlOutput,
       EX_ALUInput1);
        

    ForwardingMuxB _ForwardingMuxB(
        EX_ReadData2,
        EX_SEOutput,
        MEM_ALUResult,
        {ForwardB, EX_ALUSrc},
        EX_ALUControlOutput,
        EX_ALUInput2);
        
    // ALU(ALUControl, A, B, ALUResult, Zero)
    ALU _ALU(
        EX_ALUControlOutput, 
        EX_ALUInput1,                       // Changed from EX_AlUInput1 as it should be taking straight from Reg file
        EX_ALUInput2, 
        EX_ALUResult, 
        EX_Zero);
    
    // ALUControl(ALUOp, Opcode, RT, Ctrl)
    ALUControl _ALUControl(
        EX_ALUOp, 
        EX_Instruction26b[5:0], 
        EX_Instruction26b[20:16], 
        EX_ALUControlOutput);
        
    // Jump(Immediate, PCOut, Address)
    Jump _Jump(
        EX_Instruction26b, 
        EX_PCOutput, 
        EX_JumpOutput);
    
    // Mux5bits3to1(inA, inB, inC, Sel, Out)
    Mux5bits3to1 _RegDstMux(
        EX_Instruction26b[20:16], 
        EX_Instruction26b[15:11], 
        5'b11111, 
        EX_RegDst,
        EX_RegWriteAddress);


    //EX/MEM Register
    // EX_MEMRegister(Clk, Reset, MemToReg_in, MemRead_in,
    // MemWrite_in, RegWrite_in, Jal_in, RegWriteAddress_in,
    // ALUResult_in, Zero_in, ReadData2_in, PCAdderOut_in, JumpOutput_in,
    // BranchAdderOut_in, PCSrc_in, ReadData1_in, Branch_in,
    // MemToReg_out, MemRead_out, MemWrite_out, RegWrite_out,
    // Jal_out, RegWriteAddress_out, ALUResult_out, Zero_out,
    // ReadData2_out, PCAdderOut_out, JumpOutput_out,
    // BranchAdderOut_out, PCSrc_out, ReadData1_out, Branch_out)
    EX_MEMRegister EX_MEMReg(
        ClkOut,
        Reset,
        EX_MemToReg,
        EX_MemRead,
        EX_MemWrite,
        EX_RegWrite,
        EX_Jal,
        EX_RegWriteAddress,
        EX_ALUResult,
        EX_Zero,
        EX_ReadData2,
        EX_PCAddResult,
        EX_JumpOutput,
        EX_BranchAdderOutput,
        EX_PCSrc,
        EX_ReadData1,
        EX_Branch,
        MEM_MemToReg,
        MEM_MemRead,
        MEM_MemWrite,
        MEM_RegWrite,
        MEM_Jal,
        MEM_RegWriteAddress,
        MEM_ALUResult,
        MEM_Zero,
        MEM_ReadData2,
        MEM_PCAddResult,
        MEM_JumpOutput,
        MEM_BranchAdderOutput,
        MEM_PCSrc,
        MEM_ReadData1,
        MEM_Branch
);

    //MEM
    // DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData)
    DataMemory _DM(
        MEM_ALUResult, 
        MEM_ReadData2, 
        ClkOut, 
        MEM_MemWrite, 
        MEM_MemRead, 
        MEM_MemReadData);
        
    // And(inA, inB, Out)
    And _ZeroANDBranch(
        MEM_Branch,
        MEM_Zero,
        MEM_ZeroANDBranch);
    

    // MEM_WBRegister(Clk, Reset, MemToReg_in,
    // RegWrite_in, Jal_in, RegWriteAddress_in, ALUResult_in, PCAdderOut_in,
    //MemReadData_in, MemToReg_out, RegWrite_out, Jal_out,
    // RegWriteAddress_out, ALUResult_out, PCAdderOut_out,
    // MemReadData_out)
    MEM_WBRegister MEM_RBReg(
        ClkOut,
        Reset,
        MEM_MemToReg,
        MEM_RegWrite,
        MEM_Jal,
        MEM_RegWriteAddress,
        MEM_ALUResult,
        MEM_PCAddResult,
        MEM_MemReadData,
        WB_MemToReg,
        WB_RegWrite,
        WB_Jal,
        WB_RegWriteAddress,
        WB_ALUResult,
        WB_PCAddResult,
        WB_MemReadData
    );
  
    //WB
    // Mux32bits2to1(inA, inB, Sel, Out)
    Mux32bits2to1 _MemToRegMux( 
        WB_MemReadData, 
        WB_ALUResult, 
        WB_MemToReg,
        WB_WBToWD);

    assign PCResult = WB_PCAddResult;       
    assign WriteData = ID_WriteData;       

endmodule
