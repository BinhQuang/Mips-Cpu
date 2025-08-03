module ram (
    input   clk,     
    input  [31:0] a,        
    input   we,       
    input  [31:0] wd,       
    output [31:0] rd        
);

    reg [31:0] ram [0:63];
  
    assign rd = ram[a[31:2]];
  
    always @(posedge clk) begin
        if (we)
            ram[a[31:2]] <= wd;
    end

endmodule