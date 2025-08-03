`timescale 1ns / 100ps

module soc_tb;

    
    reg clk;
    reg rst;

   
    reg  [15:0] gpioInput;

    wire [15:0] gpioOutput;
    wire        pwmOut;

   
    wire [31:0] pc;
    wire [31:0] dmAddr;
    wire [31:0] dmWData;
    wire        memWrite;


    soc dut (
        .clk(clk),
        .rst(rst),
        .gpioInput(gpioInput),
        .gpioOutput(gpioOutput),
        .pwmOut(pwmOut)
    );

    
    assign pc        = dut.cpu_inst.pc;
    assign dmAddr    = dut.cpu_inst.dmAddr;
    assign dmWData   = dut.cpu_inst.dmWData;
    assign memWrite  = dut.cpu_inst.memWrite;

  
    always #5 clk = ~clk;

    initial begin
        
        clk = 0;
        rst = 1;
        gpioInput = 16'h0000;

       
        #20 rst = 0;

        //  GPIO Input 
        
        #50 gpioInput = 16'h55AA;
        #100 gpioInput = 16'hF0F0;
        #50 gpioInput = 16'hAAAA;

        
        #3000;

       
        $display("GPIO Output = %h ", gpioOutput);
        $display("PWM Output  = %b ", pwmOut);
        $display("Last PC     = %h", pc);
        $display("Last Addr   = %h", dmAddr);
        $display("Last Write  = %h ", dmWData);
        $display("memWrite    = %b", memWrite);
        $stop;
    end

endmodule
