`timescale 1ns / 1ps

module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData); 

    input [31:0] Address; 	// Input Address 
    input [31:0] WriteData; // Data to be written into the address 
    input Clk;
    input [1:0] MemWrite; 		// Control signal for mem write 
    input [1:0] MemRead;        // Control signal for mem read 

    output reg[31:0] ReadData; // Contents of memory location at Address

    reg [31:0] memory[1023:0];
    integer i;
	
	initial begin
	   $readmemh("data_memory.mem", memory);
	end
	
	always @(posedge Clk) begin
        if (MemWrite == 1) begin // sw
            memory[Address[9:2]] <= WriteData;
        end 
        else if (MemWrite == 2) begin // sb
            if (Address[1:0] == 2'b00) begin
                memory[Address[9:2]][7:0] <= WriteData[7:0];
            end 
            else if (Address[1:0] == 2'b01) begin
                memory[Address[9:2]][15:8] <= WriteData[7:0];
            end 
            else if (Address[1:0] == 2'b10) begin
                memory[Address[9:2]][23:16] <= WriteData[7:0];
            end 
            else if (Address[1:0] == 2'b11) begin
                memory[Address[9:2]][31:24] <= WriteData[7:0];
            end
        end
        else if (MemWrite == 3) begin // sh
            if (Address[1:0] == 2'b00) begin
                memory[Address[9:2]][15:0] <= WriteData[15:0];
            end 
            else if (Address[1:0] == 2'b10) begin
                memory[Address[9:2]][31:16] <= WriteData[15:0];
            end
        end
    end

always @(MemRead)begin
    if (MemRead == 1) begin
        ReadData <= memory[Address[9:2]];
    end 
    else if(MemRead == 2)begin
        if (Address[1:0] == 2'b00) begin    //lb
                ReadData <= {24'd0, memory[Address[9:2]][7:0]};
            end 
            else if (Address[1:0] == 2'b01) begin
                ReadData <= {24'd0, memory[Address[9:2]][15:8]};
            end 
            else if (Address[1:0] == 2'b10) begin
                ReadData <= {24'd0, memory[Address[9:2]][23:16]};
            end 
            else if (Address[1:0] == 2'b11) begin
                ReadData <= {24'd0, memory[Address[9:2]][31:24]};
            end
    end
    else if (MemRead == 3) begin // lh
            if (Address[1:0] == 2'b00) begin
                ReadData <= {16'd0, memory[Address[9:2]][15:0]};
            end 
            else if (Address[1:0] == 2'b10) begin
                ReadData <= {16'd0, memory[Address[9:2]][31:16]};
            end
        end
    else begin
        ReadData <= 0;
    end
end

	
endmodule
