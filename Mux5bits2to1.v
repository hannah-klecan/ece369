
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Mux5bits2to1
// 
//////////////////////////////////////////////////////////////////////////////////



module Mux5bits2to1(inA, inB, Sel, Out);
    
    input [4:0] inA;
    input [4:0] inB;
    input Sel;
    output reg [4:0] Out;

    
    always @(Sel)begin
        if(Sel)begin
            Out <= inB;
        end
        else begin
            Out <= inA;
        end
    
    end

endmodule
