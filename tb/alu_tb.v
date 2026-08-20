module alu_tb;
  reg [31:0] a, b;
  reg [3:0] op;
  wire [31:0] result;
  
  alu uut(.a(a), .b(b), .op(op), .result(result));
  
  initial begin
    // Test ADD: 5 + 3 = 8
    a = 32'd5; b = 32'd3; op = 4'b0000;
    #10 $display("ADD: %d + %d = %d (expected 8)", a, b, result);
    
    // Test SUB: 10 - 4 = 6
    a = 32'd10; b = 32'd4; op = 4'b0001;
    #10 $display("SUB: %d - %d = %d (expected 6)", a, b, result);
    
    // Test AND: 12 & 10 = 8 (binary: 1100 & 1010 = 1000)
    a = 32'd12; b = 32'd10; op = 4'b0010;
    #10 $display("AND: %d & %d = %d (expected 8)", a, b, result);
    
    // Test OR: 12 | 10 = 14 (binary: 1100 | 1010 = 1110)
    a = 32'd12; b = 32'd10; op = 4'b0011;
    #10 $display("OR: %d | %d = %d (expected 14)", a, b, result);
    
    // Test XOR: 12 ^ 10 = 6 (binary: 1100 ^ 1010 = 0110)
    a = 32'd12; b = 32'd10; op = 4'b0100;
    #10 $display("XOR: %d ^ %d = %d (expected 6)", a, b, result);
    
    // Test SLT: 5 < 10 = 1
    a = 32'd5; b = 32'd10; op = 4'b0101;
    #10 $display("SLT: %d < %d = %d (expected 1)", a, b, result);
    
    // Test SLT: 10 < 5 = 0
    a = 32'd10; b = 32'd5; op = 4'b0101;
    #10 $display("SLT: %d < %d = %d (expected 0)", a, b, result);
    
    $finish;
  end
endmodule