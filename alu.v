module alu (
    input  [31:0] srcA,
    input  [31:0] srcB,
    input  [3:0]  oper,
    input  [4:0]  shift,
    output reg        zero,
    output reg [31:0] result
);

always @(*) begin
    case (oper)
		  default: result = srcA + srcB;                     // Default
        4'b0000: result = ~srcA;                           // NOT 
        4'b0001: result = srcA & srcB;                     // AND
        4'b0010: result = srcA ^ srcB;                     // XOR
        4'b0011: result = srcA | srcB;                     // OR
        4'b0100: result = srcA - 1;                        // Dec
        4'b0101: result = srcA + srcB;                     // ADD
        4'b0110: result = srcA - srcB;                     // SUB
        4'b0111: result = srcA + 1;                        // Inc
        4'b1000: result = (srcA < srcB) ? 32'd1 : 32'd0;   // SLT
        4'b1010: result = srcB << shift;                   //  shift left 
        4'b1011: result = srcB >> shift;                   // shift right 
        4'b1100: result = srcB << 16;                      // Shift left 16 bits
    endcase
			 zero = (result == 0); 
end


endmodule	