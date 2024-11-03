`timescale 1ns / 1ps

module ProgramCounter( 
    input wire Clk,        
    input wire Reset, 
    input wire [31:0] input_address,  // given address
    output reg [31:0] output_address   // output address
    );

    initial begin
    
        output_address <= 32'b0;
        
    end

    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            // Reset program counter to 0
            output_address <= 32'b0;
        end
        else begin
            output_address <= input_address;
        end
    end

endmodule
