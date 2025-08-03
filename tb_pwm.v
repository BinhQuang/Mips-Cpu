`timescale 1ns/100ps

module tb_pwm;

    reg         clk;
    reg         rst;
    reg         bSel;
    reg         bWrite;
    reg  [31:0] bWData;
    wire [31:0] bRData;
    wire        pwmOutput;

  
    pwm uut (
        .clk(clk),
        .rst(rst),
        .bSel(bSel),
        .bWrite(bWrite),
        .bWData(bWData),
        .bRData(bRData),
        .pwmOutput(pwmOutput)
    );

    
    always #5 clk = ~clk;

    initial begin
        // Init
        clk = 0;
        rst = 1;
        bSel = 0;
        bWrite = 0;
        bWData = 0;

        // Reset
        #20 rst = 0;

        // Ghi giá trị comp = 50 (0x32)
        #10 bSel = 1;
            bWrite = 1;
            bWData = 32'h00000032;  
        #10 bWrite = 0;
            bSel = 0;

        // Đọc lại comp
        #10 bSel = 1;
        #10 $display("Read COMP: %h (expect 32)", bRData[7:0]);
        #10 bSel = 0;

        
        #3000;

        $stop;
    end

endmodule
