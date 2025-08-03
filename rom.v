module rom (
    input wire [5:0] imAddr,
    output wire [31:0] imData
);

    reg [31:0] rom [64-1:0];

    initial begin
       $readmemh("program.hex", rom);
		 //$readmemh("soc.hex", rom);
    end

    assign imData = rom[imAddr];  

endmodule
