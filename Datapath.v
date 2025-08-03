module Datapath (
    input  clk,
    input  rst, 
   // output  aluZero,
   output [31:0] instr,
    output [31:0] pc
   // output [31:0] pcNext
   // output [31:0] aluResult
);
    // Internal signals
    wire [31:0] pc_new, pcBranch, pc_Branch;
    wire [31:0] signImm;
    wire BranchCond;
    wire [4:0] a3;
    wire [31:0] wd3, rd1, rd2, srcA, srcB;
    wire [31:0] dmRData, dmWData, dmAddr;
    wire [5:0] imAddr;

    // Control signals
    wire [5:0] opcode;
    wire [5:0] funct;
    reg [3:0] ALUOp;
    reg [1:0] pcSrc, regDst, memToReg;
    reg aluSrc, regWrite, memWrite, Branch, condZero;

    // ======================
    // 1. PC Register
    // ======================
    register r_pc (
        .clk(clk),
        .rst(rst), 
        .d(pc_new),
        .q(pc)
    );
    assign imAddr = pc >> 2;

    // ======================
    // 2. Instruction Memory
    // ======================
    rom instr_rom (
        .imAddr(imAddr),
        .imData(instr)
    ); 

    assign opcode = instr[31:26];
    assign funct  = instr[5:0];
    assign signImm = {{16{instr[15]}}, instr[15:0]};

    // ======================
    // 3. Control Unit 
    // ======================
    always @(*) begin
        regDst = 2'b00;
        regWrite = 0;
        Branch = 0;
        condZero = 0;
        aluSrc = 0;
        memWrite = 0;
        memToReg = 2'b00;
        pcSrc = 2'b00;
        ALUOp = 4'b0101;

        case (opcode)
            6'b000000: begin 
                regDst = 2'b01;
                regWrite = 1;
                aluSrc = 0;
                case (funct)
                    6'b100001: ALUOp = 4'b0101;
                    6'b100011: ALUOp = 4'b0110;
                    6'b100100: ALUOp = 4'b0001;
                    6'b100101: ALUOp = 4'b0011;
                    6'b100110: ALUOp = 4'b0010;
                    6'b101011: ALUOp = 4'b1000;
                    6'b000000: ALUOp = 4'b1010;
                    6'b000010: ALUOp = 4'b1011;
                    6'b001000: begin ALUOp = 4'b0110; regWrite = 0; pcSrc = 2'b10; end
                endcase
            end
            6'b000100: begin ALUOp = 4'b0110; Branch = 1; condZero = 1; aluSrc = 0; end 
            6'b000101: begin ALUOp = 4'b0110; Branch = 1; condZero = 0; aluSrc = 0; end 
            6'b100011: begin ALUOp = 4'b0101; regWrite = 1; aluSrc = 1; memToReg = 2'b01; end 
            6'b101011: begin ALUOp = 4'b0101; memWrite = 1; aluSrc = 1; end 
            6'b000010: begin ALUOp = 4'b0110; pcSrc = 2'b01; end 
            6'b000011: begin ALUOp = 4'b0110; regDst = 2'b10; regWrite = 1; pcSrc = 2'b01; memToReg = 2'b10; end 
            6'b001001: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b0101; end 
            6'b001000: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b0101; end 
            6'b001100: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b0001; end 
            6'b001101: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b0011; end 
            6'b001011: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b1000; end 
            6'b001111: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b1100; end 
        endcase
    end

    // ======================
    // 4. PC logic
    // ======================
    assign pcNext = pc + 32'd4;
    assign pcBranch = pcNext + (signImm<<2);  
    assign BranchCond = Branch & (aluZero == condZero);
    assign pc_Branch = BranchCond ? pcBranch : pcNext;

    assign pc_new = (pcSrc == 2'b01) ? {pc[31:28], instr[25:0], 2'b00} :
                    (pcSrc == 2'b10) ? aluResult : pc_Branch;

    // ======================
    // 5. Register File
    // ======================
    assign a3 = (regDst == 2'b01) ? instr[15:11] :
                (regDst == 2'b10) ? 5'b11111 :
                instr[20:16];

    RF rf (
        .clk(clk),
        .a1(instr[25:21]),
        .a2(instr[20:16]),
        .a3(a3),
        .wd3(wd3),
        .we3(regWrite),
        .rd1(rd1),
        .rd2(rd2)
    );

    assign srcB = (aluSrc == 1) ? signImm : rd2;
    assign srcA = rd1;

    // ======================
    // 6. ALU
    // ======================
    alu alu_inst (
        .srcA(srcA),
        .srcB(srcB),
        .oper(ALUOp),
        .shift(instr[10:6]),
        .zero(aluZero),
        .result(aluResult)
    );

    assign dmAddr = aluResult;
    assign dmWData = rd2;

    // ======================
    // 7. Data Memory
    // ======================
    ram data_ram (
        .clk(clk),
        .a(dmAddr),
        .we(memWrite),
        .wd(dmWData),
        .rd(dmRData)
    );

    // ======================
    // 8. Write-back Mux
    // ======================
    assign wd3 = (memToReg == 2'b01) ? dmRData :
                 (memToReg == 2'b10) ? pcNext :
                 aluResult;

endmodule
