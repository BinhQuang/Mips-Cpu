// === FINALIZED 5-STAGE MIPS PIPELINE CPU ===
module CPU_pl (
    input  clk,
    input  rst,
   // output aluZero,
  //  output [31:0] instr,
    output [31:0] pc
   // output [31:0] pcNext,
   // output [31:0] aluResult
);
    // Internal wires
    wire [31:0] pc_new, pcPlus4, pcBranch, pcJump, pcJr;
    wire [31:0] signImm;
    wire [4:0] a3;
    wire [31:0] rd1, rd2, wd3, srcA, srcB;
    wire [31:0] dmRData, dmWData, dmAddr;
    wire BranchCond;
    wire [5:0] imAddr;

    // Pipeline registers
    reg [31:0] IF_ID_pcPlus4, IF_ID_instr;
    reg [31:0] ID_EX_pcPlus4, ID_EX_rd1, ID_EX_rd2, ID_EX_signImm;
    reg [3:0]  ID_EX_ALUOp;
    reg [1:0]  ID_EX_memToReg, ID_EX_pcSrc;
    reg        ID_EX_aluSrc, ID_EX_regWrite, ID_EX_memWrite, ID_EX_Branch, ID_EX_condZero;
    reg [4:0]  ID_EX_rs, ID_EX_rt, ID_EX_a3;
    reg [31:0] EX_MEM_pcBranch, EX_MEM_aluResult;
    reg        EX_MEM_memWrite, EX_MEM_Branch, EX_MEM_condZero, EX_MEM_aluZero;
    reg [31:0] EX_MEM_rd2;
    reg [1:0]  EX_MEM_memToReg, EX_MEM_pcSrc;
    reg        EX_MEM_regWrite;
    reg [4:0]  EX_MEM_a3;
    reg [31:0] MEM_WB_aluResult, MEM_WB_dmRData;
    reg [1:0]  MEM_WB_memToReg;
    reg        MEM_WB_regWrite;
    reg [4:0]  MEM_WB_a3;

    // Hazard detection
    wire stall, flush;
    wire [1:0] forwardA, forwardB;
    wire lwStall, branchStall;

    // Control signals
    wire [5:0] opcode = IF_ID_instr[31:26];
    wire [5:0] funct  = IF_ID_instr[5:0];
    reg [3:0] ALUOp;
    reg [1:0] pcSrc, regDst, memToReg;
    reg aluSrc, regWrite, memWrite, Branch, condZero;

    // === Instruction Fetch ===
    register r_pc (.clk(clk), .rst(rst), .d(pc_new), .q(pc));
    assign imAddr = pc[7:2];
    assign pcPlus4 = pc + 4;
    rom instr_rom (.imAddr(imAddr), .imData(instr));

    always @(posedge clk) begin
        if (rst || flush) begin
            IF_ID_pcPlus4 <= 0;
            IF_ID_instr <= 0;
        end else if (!stall) begin
            IF_ID_pcPlus4 <= pcPlus4;
            IF_ID_instr <= instr;
        end
    end

    assign signImm = {{16{IF_ID_instr[15]}}, IF_ID_instr[15:0]};

    // === Instruction Decode & Control ===
    always @(*) begin
        regDst = 2'b00; regWrite = 0; Branch = 0; condZero = 0;
        aluSrc = 0; memWrite = 0; memToReg = 2'b00; pcSrc = 2'b00;
        ALUOp = 4'b0101;
        case (opcode)
            6'b000000: begin
                regDst = 2'b01; regWrite = 1; aluSrc = 0;
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
                    default: ALUOp = 4'b0101;
                endcase
            end
            6'b000100: begin ALUOp = 4'b0110; Branch = 1; condZero = 1; end
            6'b000101: begin ALUOp = 4'b0110; Branch = 1; condZero = 0; end
            6'b100011: begin ALUOp = 4'b0101; regWrite = 1; aluSrc = 1; memToReg = 2'b01; end
            6'b101011: begin ALUOp = 4'b0101; memWrite = 1; aluSrc = 1; end
            6'b000010: begin ALUOp = 4'b0110; pcSrc = 2'b01; end
            6'b000011: begin ALUOp = 4'b0110; regDst = 2'b10; regWrite = 1; pcSrc = 2'b01; memToReg = 2'b10; end
            6'b001001: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b0101; end
            6'b001100: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b0001; end
            6'b001101: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b0011; end
            6'b001011: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b1000; end
            6'b001111: begin regDst = 2'b00; regWrite = 1; aluSrc = 1; ALUOp = 4'b1100; end
            default: begin regDst = 2'b00; ALUOp = 4'b0101; end
        endcase
    end

    // === Register File Access ===
    assign a3 = (regDst == 2'b01) ? IF_ID_instr[15:11] : (regDst == 2'b10) ? 5'b11111 : IF_ID_instr[20:16];
    RF rf (.clk(clk), .a1(IF_ID_instr[25:21]), .a2(IF_ID_instr[20:16]), .a3(MEM_WB_a3), .wd3(wd3), .we3(MEM_WB_regWrite), .rd1(rd1), .rd2(rd2));

    // === Hazard Detection Unit ===
    assign lwStall = (ID_EX_memToReg == 2'b01) && ((ID_EX_rt == IF_ID_instr[25:21]) || (ID_EX_rt == IF_ID_instr[20:16]));
    assign branchStall = (Branch && ((regWrite && (a3 == IF_ID_instr[25:21] || a3 == IF_ID_instr[20:16])) ||
                          (ID_EX_regWrite && (ID_EX_a3 == IF_ID_instr[25:21] || ID_EX_a3 == IF_ID_instr[20:16]))));
    assign stall = lwStall || branchStall;
    assign flush = (EX_MEM_Branch && (EX_MEM_aluZero == EX_MEM_condZero)) || (EX_MEM_pcSrc != 2'b00);

    // === ID/EX Register Update ===
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_EX_pcPlus4 <= 0; ID_EX_rd1 <= 0; ID_EX_rd2 <= 0; ID_EX_signImm <= 0;
            ID_EX_ALUOp <= 0; ID_EX_memToReg <= 0; ID_EX_pcSrc <= 0; ID_EX_aluSrc <= 0;
            ID_EX_regWrite <= 0; ID_EX_memWrite <= 0; ID_EX_Branch <= 0; ID_EX_condZero <= 0;
            ID_EX_rs <= 0; ID_EX_rt <= 0; ID_EX_a3 <= 0;
        end else if (!stall) begin
            ID_EX_pcPlus4 <= IF_ID_pcPlus4; ID_EX_rd1 <= rd1; ID_EX_rd2 <= rd2; ID_EX_signImm <= signImm;
            ID_EX_ALUOp <= ALUOp; ID_EX_memToReg <= memToReg; ID_EX_pcSrc <= pcSrc; ID_EX_aluSrc <= aluSrc;
            ID_EX_regWrite <= regWrite; ID_EX_memWrite <= memWrite; ID_EX_Branch <= Branch; ID_EX_condZero <= condZero;
            ID_EX_rs <= IF_ID_instr[25:21]; ID_EX_rt <= IF_ID_instr[20:16]; ID_EX_a3 <= a3;
        end
    end

    // === Execute Stage ===
    assign forwardA = (EX_MEM_regWrite && (EX_MEM_a3 != 0) && (EX_MEM_a3 == ID_EX_rs)) ? 2'b01 :
                      (MEM_WB_regWrite && (MEM_WB_a3 != 0) && (MEM_WB_a3 == ID_EX_rs)) ? 2'b10 : 2'b00;
    assign forwardB = (EX_MEM_regWrite && (EX_MEM_a3 != 0) && (EX_MEM_a3 == ID_EX_rt)) ? 2'b01 :
                      (MEM_WB_regWrite && (MEM_WB_a3 != 0) && (MEM_WB_a3 == ID_EX_rt)) ? 2'b10 : 2'b00;

    assign srcA = (forwardA == 2'b00) ? ID_EX_rd1 : (forwardA == 2'b01) ? EX_MEM_aluResult : wd3;
    assign srcB = (forwardB == 2'b00) ? ID_EX_rd2 : (forwardB == 2'b01) ? EX_MEM_aluResult : wd3;

    alu alu_inst (.srcA(srcA), .srcB(ID_EX_aluSrc ? ID_EX_signImm : srcB), .oper(ID_EX_ALUOp), .shift(ID_EX_signImm[10:6]), .zero(aluZero), .result(aluResult));
    assign pcBranch = ID_EX_pcPlus4 + (ID_EX_signImm << 2);
    assign pcJump = {IF_ID_pcPlus4[31:28], IF_ID_instr[25:0], 2'b00};
    assign pcJr = srcA;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_MEM_pcBranch <= 0; EX_MEM_aluResult <= 0; EX_MEM_aluZero <= 0;
            EX_MEM_memWrite <= 0; EX_MEM_rd2 <= 0; EX_MEM_memToReg <= 0; EX_MEM_pcSrc <= 0;
            EX_MEM_regWrite <= 0; EX_MEM_a3 <= 0; EX_MEM_Branch <= 0; EX_MEM_condZero <= 0;
        end else begin
            EX_MEM_pcBranch <= pcBranch; EX_MEM_aluResult <= aluResult; EX_MEM_aluZero <= aluZero;
            EX_MEM_memWrite <= ID_EX_memWrite; EX_MEM_rd2 <= srcB; EX_MEM_memToReg <= ID_EX_memToReg;
            EX_MEM_pcSrc <= ID_EX_pcSrc; EX_MEM_regWrite <= ID_EX_regWrite; EX_MEM_a3 <= ID_EX_a3;
            EX_MEM_Branch <= ID_EX_Branch; EX_MEM_condZero <= ID_EX_condZero;
        end
    end

    // === Memory Stage ===
    assign dmAddr = EX_MEM_aluResult;
    assign dmWData = EX_MEM_rd2;
    ram data_ram (.clk(clk), .a(dmAddr[7:2]), .we(EX_MEM_memWrite), .wd(dmWData), .rd(dmRData));
    assign BranchCond = EX_MEM_Branch & (EX_MEM_aluZero == EX_MEM_condZero);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_WB_aluResult <= 0; MEM_WB_dmRData <= 0;
            MEM_WB_memToReg <= 0; MEM_WB_regWrite <= 0; MEM_WB_a3 <= 0;
        end else begin
            MEM_WB_aluResult <= EX_MEM_aluResult; MEM_WB_dmRData <= dmRData;
            MEM_WB_memToReg <= EX_MEM_memToReg; MEM_WB_regWrite <= EX_MEM_regWrite;
            MEM_WB_a3 <= EX_MEM_a3;
        end
    end

    // === Writeback Stage ===
    assign wd3 = (MEM_WB_memToReg == 2'b01) ? MEM_WB_dmRData : (MEM_WB_memToReg == 2'b10) ? (IF_ID_pcPlus4 + 4) : MEM_WB_aluResult;
    assign pc_new = (EX_MEM_pcSrc == 2'b01) ? pcJump : (EX_MEM_pcSrc == 2'b10) ? pcJr : (BranchCond) ? EX_MEM_pcBranch : pcPlus4;
    assign pcNext = pcPlus4;

endmodule
