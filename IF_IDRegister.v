`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: IF_IDRegister
// 
//////////////////////////////////////////////////////////////////////////////////


module IF_IDRegister (
    input Clk,
    input Reset,
    input [31:0] Instruction_in,
    input [31:0] PCOutput_in,
    input [31:0] PCAdderOut_in,
    
    output reg [31:0] Instruction_out,
    output reg [31:0] PCOutput_out,
    output reg [31:0] PCAdderOut_out
);

always @(posedge Clk) begin
    if (Reset) begin
        Instruction_out <= 0;
        PCOutput_out <= 0;
        PCAdderOut_out <= 0;
    end 
    else begin
        Instruction_out <= Instruction_in;
        PCOutput_out <= PCOutput_in;
        PCAdderOut_out <= PCAdderOut_in;
    end
end

endmodule

