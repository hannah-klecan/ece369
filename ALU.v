`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Module Name: ALU
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(ALUControl, A, B, ALUResult, Zero);

	input [3:0] ALUControl; // control bits for ALU operation
	input [31:0] A, B;	    // inputs

	output reg [31:0] ALUResult;
	output reg Zero;	    // Zero=1 if ALUResult == 0

    always @(A,B, ALUControl)begin
        //add
        if(ALUControl == 0)begin
            ALUResult <= A + B;
        end
        //sub
        else if(ALUControl == 1)begin
            ALUResult <= A - B;
        end
        //Mult
        else if(ALUControl == 2)begin
            ALUResult <= A * B;
        end
        //and
        else if(ALUControl == 3)begin
            ALUResult <= A & B;
        end
        //or
        else if(ALUControl == 4)begin
            ALUResult <= A | B;
        end
        //Nor
        else if(ALUControl == 5)begin
            ALUResult <= ~(A | B);
        end
        //Xor
        else if(ALUControl == 6)begin
            ALUResult <= A ^ B;
        end
        //Sll
        else if(ALUControl == 7)begin
            ALUResult <= A << B[10:6];
        end
        //srl
        else if(ALUControl == 8)begin
            ALUResult <= A >> B[10:6];
        end
        //slt
        else if(ALUControl == 9)begin
            ALUResult <= $signed(A) < $signed(B);
        end
        //Bne//////////////////////////////////////////////////////////////////////////
        else if(ALUControl == 10)begin
            ALUResult <= (A == B);
        end
        //Gteq0
        else if(ALUControl == 11)begin
            ALUResult <= ($signed(A) < 0);
        end
        //Gt0
        else if(ALUControl == 12)begin
            ALUResult <= ($signed(A) <= 0);
        end
        //Lteq0
        else if(ALUControl == 13)begin
            ALUResult <= ($signed(A) > 0);
        end
        //Lt0
        else if(ALUControl == 14)begin
            ALUResult <= ($signed(A) >= 0);
        end
    
    end
    
    
    always @(ALUResult, A, B)begin
        if(ALUResult == 0)begin
            Zero <= 1;
        end
        else begin
            Zero <= 0;
        end    
    end

endmodule
