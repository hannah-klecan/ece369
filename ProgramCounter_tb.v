`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ProgramCounter_tb
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter_tb;
    reg Clk;
    reg Reset;

    reg [31:0] input_address;         
    wire [31:0] output_address;       
    

    // Instantiate the ProgramCounter module
    ProgramCounter uut (
        .Clk(Clk),
        .Reset(Reset),
        .input_address(input_address),
        .output_address(output_address)
    );
    
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk; 
    end

    // Test stimulus
    initial begin
        // Initial reset
        Reset = 1;
        input_address = 32'h00000000;
        #10 Reset = 0;               // Release reset after 10 ns
        #10;

        // Observe output address after release of reset
        #50;

        // Load a new address
        input_address = 32'h00000010; 
        #10;

        // Activate reset in the middle of operation
        Reset = 1;
        #10 Reset = 0;               // Deactivate reset

        // Observe output address again
        #50;
        
        // End the simulation
        $stop;
    end

    // Monitor the PC value at each clock edge
    initial begin
        $monitor("Time: %0t | Reset=%b | input_address=%h | output_address=%h", $time, Reset, input_address, output_address);
    end

endmodule
