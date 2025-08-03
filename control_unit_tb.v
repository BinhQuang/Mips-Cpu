`timescale 1ns / 100ps

module control_unit_tb;

    // Inputs
    reg [5:0] opcode;
    reg [5:0] funct;

    // Outputs
    wire [3:0] ALU_Code;
    wire [1:0] regDst;
    wire regWrite;
    wire branch;
    wire condZero;
    wire aluSrc;
    wire memWrite;
    wire [1:0] memToReg;
    wire [1:0] pcSrc;

    // Instantiate the Unit Under Test (UUT)
    control_unit uut (
        .opcode(opcode),
        .funct(funct),
        .ALU_Code(ALU_Code),
        .regDst(regDst),
        .regWrite(regWrite),
        .branch(branch),
        .condZero(condZero),
        .aluSrc(aluSrc),
        .memWrite(memWrite),
        .memToReg(memToReg),
        .pcSrc(pcSrc)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        opcode = 6'b000000;
        funct = 6'b000000;
        #10;

        // Test R-type instructions
        // add (funct = 6'b100001)
        opcode = 6'b000000; funct = 6'b100001; #10;
        // sub (funct = 6'b100011)
        opcode = 6'b000000; funct = 6'b100011; #10;
        // and (funct = 6'b100100)
        opcode = 6'b000000; funct = 6'b100100; #10;
        // or (funct = 6'b100101)
        opcode = 6'b000000; funct = 6'b100101; #10;
        // xor (funct = 6'b100110)
        opcode = 6'b000000; funct = 6'b100110; #10;
        // sltu (funct = 6'b101011)
        opcode = 6'b000000; funct = 6'b101011; #10;
        // sll (funct = 6'b000000)
        opcode = 6'b000000; funct = 6'b000000; #10;
        // srl (funct = 6'b000010)
        opcode = 6'b000000; funct = 6'b000010; #10;
        // jr (funct = 6'b001000)
        opcode = 6'b000000; funct = 6'b001000; #10;

        // Test I-type instructions
        // addiu (opcode = 6'b001001)
        opcode = 6'b001001; funct = 6'bxxxxxx; #10;
        // andi (opcode = 6'b001100)
        opcode = 6'b001100; funct = 6'bxxxxxx; #10;
        // ori (opcode = 6'b001101)
        opcode = 6'b001101; funct = 6'bxxxxxx; #10;
        // sltiu (opcode = 6'b001011)
        opcode = 6'b001011; funct = 6'bxxxxxx; #10;
        // lui (opcode = 6'b001111)
        opcode = 6'b001111; funct = 6'bxxxxxx; #10;

        // Test branch instructions
        // beq (opcode = 6'b000100)
        opcode = 6'b000100; funct = 6'bxxxxxx; #10;
        // bne (opcode = 6'b000101)
        opcode = 6'b000101; funct = 6'bxxxxxx; #10;

        // Test load/store instructions
        // lw (opcode = 6'b100011)
        opcode = 6'b100011; funct = 6'bxxxxxx; #10;
        // sw (opcode = 6'b101011)
        opcode = 6'b101011; funct = 6'bxxxxxx; #10;

        // Test jump instructions
        // j (opcode = 6'b000010)
        opcode = 6'b000010; funct = 6'bxxxxxx; #10;
        // jal (opcode = 6'b000011)
        opcode = 6'b000011; funct = 6'bxxxxxx; #10;

        // Finish simulation
        #10 $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t opcode=%b funct=%b ALU_Code=%b regDst=%b regWrite=%b branch=%b condZero=%b aluSrc=%b memWrite=%b memToReg=%b pcSrc=%b",
                 $time, opcode, funct, ALU_Code, regDst, regWrite, branch, condZero, aluSrc, memWrite, memToReg, pcSrc);
    end

endmodule