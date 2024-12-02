module SignExtension(in, out);

 /* A 16-Bit input word */
    input [15:0] in;
    
 /* A 32-Bit output word */
    output reg [31:0] out;
    
    always @ (in)begin
        if(in[15])begin
            out  <= {16'hFFFF, in};     //Changed to add FFFF to upper half instead of 0001
        end
        else begin
            out <= {16'h0000, in};      //Changed to use hex like above
        end
    end

endmodule
