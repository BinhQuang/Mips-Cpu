// === Testbench for 5-Stage MIPS Pipeline CPU ===
`timescale 1ns / 100ps

module cpu_pl_tb;
    reg clk;
    reg rst;
    wire [31:0] instr;
    wire [31:0] pc;
    wire [31:0] pcNext;
    wire [31:0] aluResult;
    wire aluZero;

    // Instantiate the CPU
    CPU_pl dut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .pc(pc),
        .pcNext(pcNext),
        .aluResult(aluResult),
        .aluZero(aluZero)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period


    // Test sequence
    initial begin
        $display("Starting CPU Pipeline Testbench...");
        rst = 1;
        #10;
        rst = 0;
			#10

        // Run long enough to process all instructions
        #500;

        $display("Testbench completed.");
        $stop;
    end

endmodule
