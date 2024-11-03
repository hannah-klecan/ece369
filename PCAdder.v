`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  
// Module Name: PCAdder
// Project Name: 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PCAdder(PCResult,PCAddResult);
    input[31:0] PCResult;
    output reg [31:0] PCAddResult; 
    
    always @ (PCResult)
        begin
            PCAddResult <= PCResult + 4;
        end
endmodule
