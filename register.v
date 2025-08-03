module register(
    input wire clk, rst,
    input wire [31:0] d,
    output reg [31:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 32'h0;
        else
            q <= d;
    end
endmodule