
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Module Name: Mux5bits3to1
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux5bits3to1(
    input [4:0] inA,
    input [4:0] inB,
    input [4:0] inC,
    input [1:0] Sel,
    output reg [4:0] Out
);


always @(Sel or inA or inB or inC) begin
    case (Sel)
        2'b00: Out = inA; // Select input is 00, output is data0
        2'b01: Out = inB; // Select input is 01, output is data1
        2'b10: Out = inC; // Select input is 10, output is data2
    endcase
end

endmodule
