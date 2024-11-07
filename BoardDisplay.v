`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module BoardDisplay(Clk, Reset, en_out, out7); 
    
    input Clk, Reset;
    output wire [7:0]en_out;
    output wire [6:0]out7;
    wire ClkOut;
    wire [31:0] PCCounter, WriteData;
    
    ClkDiv _ClkDiv(Clk, Reset, ClkOut);
    TopModule _top (Clk, Reset, PCResult, WriteData);
    
    Two4DigitDisplay _Two4DigitDisplay(Clk, WriteData, PCCounter, en_out, out7);

//    Two4DigitDisplay _Two4DigitDisplay(Clk, WB_WBToWD[15:0], WB_PCAddResult[15:0] - 4, en_out, out7);



endmodule
