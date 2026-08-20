module registers_tb;
  reg clk, we;
  reg [4:0] rs1, rs2, rd;
  reg [31:0] write_data;
  wire [31:0] reg_data1, reg_data2;
  
  registers uut(
    .clk(clk), .rs1(rs1), .rs2(rs2), .rd(rd),
    .write_data(write_data), .we(we),
    .reg_data1(reg_data1), .reg_data2(reg_data2)
  );
  
  initial begin
    clk = 0;
    
    // Test 1: Write 100 to register x1
    $display("=== Test 1: Write to registers ===");
    rd = 5'd1; write_data = 32'd100; we = 1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    
    // Test 2: Write 200 to register x2
    rd = 5'd2; write_data = 32'd200; we = 1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    
    // Test 3: Read x1 and x2
    $display("=== Test 2: Read from registers ===");
    we = 0;  // Disable write
    rs1 = 5'd1; rs2 = 5'd2;
    #5 $display("x1 = %d (expected 100), x2 = %d (expected 200)", reg_data1, reg_data2);
    
    // Test 4: Verify x0 is always 0 (can't write to it)
    $display("=== Test 3: Verify x0 is read-only ===");
    rd = 5'd0; write_data = 32'd999; we = 1;  // Try to write to x0
    #10 clk = ~clk;
    #10 clk = ~clk;
    rs1 = 5'd0; rs2 = 5'd0;
    #5 $display("x0 = %d (expected 0, even though we tried to write 999)", reg_data1);
    
    // Test 5: Write to x5, then read it
    $display("=== Test 4: Write and read different registers ===");
    rd = 5'd5; write_data = 32'd555; we = 1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    we = 0;
    rs1 = 5'd5;
    #5 $display("x5 = %d (expected 555)", reg_data1);
    
    $finish;
  end
endmodule