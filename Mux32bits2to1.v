 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Module Name: Mux32bits2to1
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux32bits2to1(inA, inB, Sel, Out);

    output reg [31:0] Out;
    
    input [31:0] inA;
    input [31:0] inB;
    input Sel;

    always @(inA, inB, Sel)begin
    
        if(Sel)begin
            Out <= inB;
        end
        else begin
            Out <= inA;
        end
    
    end

endmodule
