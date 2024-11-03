module SignExtension(in, out);

 /* A 16-Bit input word */
    input [15:0] in;
    
 /* A 32-Bit output word */
    output reg [31:0] out;
    
    always @ (in)begin
        if(in[15])begin
            out  <= {16'b1, in};
        end
        else begin
            out <= {16'b0, in};
        end
    end

endmodule
