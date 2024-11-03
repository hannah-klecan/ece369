`timescale 1ns / 1ps

module Adder(inA, inB, Out);

    input [31:0] inA;
    input [31:0] inB;
    output reg [31:0] Out;


    initial begin
        Out = 32'd0;
    end
    
    always @(inA,inB)begin
        Out <= inA + inB;
    end
    

endmodule
