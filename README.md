#  MIPS 5-Stage Pipeline CPU

##  Giới thiệu
Dự án này hiện thực một **CPU MIPS 5 giai đoạn pipeline** sử dụng ngôn ngữ mô tả phần cứng (HDL).  
Mục tiêu chính:  
- Giúp người học nắm vững nguyên lý **pipeline trong vi xử lý**.  
- Hiểu cách xử lý **Instruction Fetch → Decode → Execute → Memory → Write Back**.  
- Làm nền tảng cho các môn học **Computer Architecture**, **Digital IC Design**, **SoC Design**.  

##  Mục tiêu dự án
- Xây dựng CPU pipeline 5 stage theo kiến trúc **MIPS**.  
- Thực thi các lệnh cơ bản: **R-type, I-type, J-type**.  
- Hiện thực cơ chế **Forwarding** để tránh *data hazard*.  
- Thêm **Hazard Detection Unit** để xử lý *stall* khi cần.  
- Hỗ trợ xử lý **branch hazard** (pipeline flush).  
- Tạo **testbench** để mô phỏng và kiểm chứng hoạt động CPU.  


##  Kiến trúc Pipeline (5 giai đoạn)

1. **IF (Instruction Fetch)**  
   - Lấy lệnh từ **Instruction Memory** theo **PC (Program Counter)**.  
   - Cập nhật giá trị **PC + 4**.  

2. **ID (Instruction Decode & Register Fetch)**  
   - Giải mã lệnh.  
   - Đọc giá trị từ **Register File**.  
   - Sinh tín hiệu điều khiển.  

3. **EX (Execute / ALU)**  
   - Thực hiện các phép tính số học, logic.  
   - Tính địa chỉ bộ nhớ cho load/store.  
   - Xử lý nhảy (branch/jump).  

4. **MEM (Memory Access)**  
   - Đọc/ghi dữ liệu từ **Data Memory**.  

5. **WB (Write Back)**  
   - Ghi kết quả tính toán hoặc dữ liệu đọc về **Register File**.  


##  Tính năng
-  Thực hiện được các lệnh **ADD, SUB, AND, OR, SLT, LW, SW, BEQ, JUMP**.  
-  Hỗ trợ **pipeline 5 giai đoạn** đầy đủ.  
-  **Forwarding Unit** để giảm số chu kỳ chờ.  
-  **Hazard Detection Unit** để xử lý *data hazard*.  
-  **Branch prediction đơn giản** (hoặc flush pipeline khi nhảy).  
-  Có **testbench mô phỏng** để kiểm chứng kết quả.  

