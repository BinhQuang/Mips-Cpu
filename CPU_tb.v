`timescale 1ns/100ps

module CPU_tb;

    reg clk = 0;
    reg rst = 1;
    
    wire [31:0] instr;
    wire [31:0] pc;
    wire aluZero;
    wire regWrite, branch, condZero, aluSrc, memWrite;
    wire [31:0] pcNext, aluResult;

    // Instantiate DUT (CPU)
    CPU dut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .pc(pc),
        .aluZero(aluZero),
        .regWrite(regWrite),
        .branch(branch),
        .condZero(condZero),
        .aluSrc(aluSrc),
        .memWrite(memWrite),
        .pcNext(pcNext),
        .aluResult(aluResult)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Time | PC        | Instr     | PCNext    | ALUResult | Zero | regWrite | Branch | aluSrc | memWrite");
        $monitor("%4t | %8h | %8h | %8h | %8h |   %b  |    %b     |   %b   |   %b    |    %b", 
                 $time, pc, instr, pcNext, aluResult, aluZero, regWrite, branch, aluSrc, memWrite);

        // Release reset after some time
        #12 rst = 0;

        // Stop after some cycles
        #200 $stop;
    end

endmodule
