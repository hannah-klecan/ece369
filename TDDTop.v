`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// Module Name: TDDTop
// Project Name:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TDDTop(Reset, Clk, out7, en_out);
    input Reset; 
    input Clk;
    output wire [6:0] out7;
    output wire [7:0] en_out;
    wire ClkOut;
    
    ClkDiv _ClkDiv(Clk, 0, ClkOut);
    wire [31:0] PCResult, WriteData;
    
    TopModule _TopModule(ClkOut, Reset, PCResult, WriteData);
    
    Two4DigitDisplay _Two4DigitDisplay(Clk, PCResult, WriteData, out7, en_out);
endmodule
