`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Module Name: SignExtension_tb
// Project Name: 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SignExtension_tb();

    reg	[15:0] in;
    wire [31:0]	out;

    SignExtension u0(
        .in(in), .out(out)
    );
        
    initial begin

			#100 in <= 16'h0004;
			#20 $display("in=%h, out=%h", in, out);

			#100 in <= 16'h7000;
			#20 $display("in=%h, out=%h", in, out);

			#100 in <= 16'h9000;
			#20 $display("in=%h, out=%h", in, out);
			
			#100 in <= 16'hF000;
			#20 $display("in=%h, out=%h", in, out);
			
	 end

endmodule
