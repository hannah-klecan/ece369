`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  
// Module Name: Sll
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Srl(in, out);
    input [31:0] in;
    output reg [31:0] out;
    
    always @(in)begin
        out <= in >> 2;
    end
endmodule
