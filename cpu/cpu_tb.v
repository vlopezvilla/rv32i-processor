module cpu_tb;
  reg clk, rst;
  reg [31:0] instr;
  wire [31:0] pc, alu_result, reg_write_data;
  
  cpu uut(.clk(clk), .rst(rst), .instr(instr), .pc(pc), 
          .alu_result(alu_result), .reg_write_data(reg_write_data));
  
  initial begin
    clk = 0;
    rst = 1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    rst = 0;
    
    // Test 1: ADDI x1, x0, 5
    $display("=== Test 1: ADDI x1, x0, 5 ===");
    instr = 32'b0000000000101_00000_000_00001_0010011;
    #10 clk = ~clk;
    #10 clk = ~clk;
    $display("ALU result: %d (expected 5)", alu_result);
    $display("Register write data: %d (expected 5)", reg_write_data);
    
    // Test 2: ADD x3, x1, x2 (but x1=5 from above, x2=0, so result=5)
    $display("\n=== Test 2: ADD x3, x1, x2 ===");
    instr = 32'b0000000_00010_00001_000_00011_0110011;
    #10 clk = ~clk;
    #10 clk = ~clk;
    $display("ALU result: %d (expected 5, since x1=5 and x2=0)", alu_result);
    
    $finish;
  end
endmodule