module pwm (
    input         clk,
    input         rst,              // Reset mức cao
    input         bSel,             // Tín hiệu chọn PWM từ decoder
    input         bWrite,           // Tín hiệu ghi
    input  [31:0] bWData,           // Dữ liệu ghi từ CPU
    output [31:0] bRData,           // Dữ liệu đọc về CPU (comp)
    output        pwmOutput         // Tín hiệu PWM ra ngoài
);

    wire  [7:0] comp;               // Giá trị so sánh
    wire  [7:0] count;              // Bộ đếm
    wire  [7:0] countNext;          // Bộ đếm tăng
    wire        compWe;            // Cho phép ghi vào thanh ghi compare

    assign countNext = count + 1;
    assign compWe    = bSel & bWrite;
    assign bRData    = {24'b0, comp};        // chỉ đọc thanh ghi comp
    assign pwmOutput = (count > comp);       // xuất PWM khi count > comp

    // Thanh ghi compare (có ghi)
    register_we_8 r_Compare (
        .clk(clk),
        .rst(rst),
        .we(compWe),
        .d(bWData[7:0]),
        .q(comp)
    );

    // Thanh ghi counter (tự tăng)
    register_we_8 r_Counter (
        .clk(clk),
        .rst(rst),
        .we(1'b1),
        .d(countNext),
        .q(count)
    );

endmodule
