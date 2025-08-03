module CPU (
    input clk,
    input rst,
    output [31:0] instr,
    output [31:0] pc,
    output aluZero,
    output wire regWrite, branch, condZero, aluSrc, memWrite,
    // Optional DEBUG output from Datapath for testing
    output [31:0] pcNext,
    output [31:0] aluResult
);

    wire [5:0] opcode;
    wire [5:0] funct;
    wire [3:0] aluOp;
    wire [1:0] regDst, memToReg, pcSrc;

    wire [31:0] instr_internal;

    control_unit CU (
        .opcode(opcode),
        .funct(funct),
        .ALU_Code(aluOp),
        .regDst(regDst),
        .regWrite(regWrite),
        .branch(branch),
        .condZero(condZero),
        .aluSrc(aluSrc),
        .memWrite(memWrite),
        .memToReg(memToReg),
        .pcSrc(pcSrc)
    );

    Datapath DP (
        .clk(clk),
        .rst(rst),
        .condZero(condZero),
        .pcSrc(pcSrc),
        .regDst(regDst),
        .memToReg(memToReg),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .memWrite(memWrite),
        .Branch(branch),
        .ALUOp(aluOp),
        .aluZero(aluZero),
        .instr(instr_internal),
        .pc(pc),
        .pcNext(pcNext),
        .aluResult(aluResult)
    );

    assign instr = instr_internal;
    assign opcode = instr_internal[31:26];
    assign funct  = instr_internal[5:0];

endmodule
