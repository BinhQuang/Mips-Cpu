module register_we_8 ( // pwm
    input        clk,
    input        rst,          
    input        we,
    input  [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else if (we)
            q <= d;
    end
endmodule
