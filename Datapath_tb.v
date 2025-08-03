`timescale 1ns/1ps

module Datapath_tb;
    reg clk = 0;
    reg rst = 1;

    wire [31:0] instr;
    wire [31:0] pc, pcNext, aluResult;
    wire aluZero;

    // Các tín hiệu debug thêm
    wire [31:0] rd1, rd2, srcA, srcB;
    wire [31:0] wd3;

    // Instantiate Datapath
    Datapath dut (
        .clk(clk),
        .rst(rst),
        .aluZero(aluZero),
        .instr(instr),
        .pc(pc),
        .pcNext(pcNext),
        .aluResult(aluResult)
    );

    // Clock generation
    always #5 clk = ~clk; // Toggle clock every 5ns

    initial begin
        $display("=== BAT DAU MO PHONG ===");
        $display("Thoi gian | PC       | Instr    | PCNext   | ALUZero | ALUResult | rd1      | rd2      | srcA     | srcB     | wd3      | regWrite | aluSrc | pcSrc");
        $display("----------|----------|----------|----------|---------|-----------|----------|----------|----------|----------|----------|----------|--------|--------");

        // Reset phase
        #10 rst = 0;

        // Run simulation for a few cycles
        #600 $stop;
    end

    always @(posedge clk) begin
        $display("%8t | %h | %h | %h |    %b    | %h | %h | %h | %h | %h | %h |     %b     |   %b   |  %b",
            $time, pc, instr, pcNext, aluZero, aluResult,
            dut.rd1, dut.rd2, dut.srcA, dut.srcB, dut.wd3,
            dut.regWrite, dut.aluSrc, dut.pcSrc);
    end
endmodule
