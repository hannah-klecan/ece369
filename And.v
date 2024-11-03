`timescale 1ns / 1ps

module And(inA, inB, Out);
    input inA;
    input inB;
    output reg Out;

    always @(inA, inB)begin
        Out <= (inA & inB);
    end
endmodule
