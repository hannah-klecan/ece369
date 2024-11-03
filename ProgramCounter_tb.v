`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ProgramCounter_tb
// 
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter_tb;
    reg Clk;
    reg Rst;
    reg load;
    reg [31:0] pc_in;
    wire [31:0] pc;

    ProgramCounter uut (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .load(load),
        .pc(pc)
    );

    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk; 
    end

    initial begin
        Rst = 1;    
        load = 0;
        pc_in = 32'h00000000;

        #10 Rst = 0;
        #10;
        
        #50;
        
        // Load a new PC value
        load = 1;
        pc_in = 32'h00000010; 
        #10 load = 0; // Deactivate load
        
        // Observe PC incrementing from the loaded value
        #50;

        // Activate reset in the middle of operation
        Rst = 1;
        #10 Rst = 0; // Deactivate reset
        
        // Observe PC incrementing again
        #50;
        
        // End the simulation
        $stop;
    end

    // Monitor PC value at each clock edge
    initial begin
        $monitor("Time: %0t | rst=%b | load=%b | pc_in=%h | pc=%h", $time, Rst, load, pc_in, pc);
    end

endmodule
