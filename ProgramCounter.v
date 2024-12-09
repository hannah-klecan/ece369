`timescale 1ns / 1ps

module ProgramCounter(
    input wire Clk,          // Clock input
    input wire Reset,        // Reset input
    input wire [31:0] input_address,  // given address
    input Stall_in,
    input [1:0] PCSrc,
    output reg [31:0] output_address   // output address
); 

    reg [31:0] last_instruction; 

    initial begin
    
        output_address <= 32'b0;
        last_instruction <= 32'b0;
        
    end

    always @(negedge Clk or posedge Reset) begin
        if (Reset) begin
            // Reset the program counter to 0
            output_address <= 32'b0;
        end
        else begin
            if(PCSrc > 0) begin                         //If branch or jump instruction, save/update address of instruction
                output_address <= input_address;        //Needed when either instruction comes up while Stalling
                last_instruction <= input_address;      //Or instruction gets overwritten/lost
            end
            else if (Stall_in == 1) begin               //If stalling, disregard instruction
                output_address <= last_instruction;
            end
            else begin                                  //If instruction and no stall, carry on as normal
                output_address <= input_address;
                last_instruction <= input_address;
            end
        end
    end

endmodule
