// module declaration: alu
module alu(
  input  [31:0] a,                  // 32-bit Input a
  input  [31:0] b,                  // 32-bit Input b
  input  [3:0]  op,                 // 4-bit Operation select
  output reg [31:0] result          // 32-bit Output
);

// setup: a, b => two 32 bit numbers to operate on

// local parameters are a constant value used only within this module
localparam ALU_ADD = 4'b0000;   // 0 
localparam ALU_SUB = 4'b0001;   // 1
localparam ALU_AND = 4'b0010;   // 2
localparam ALU_OR  = 4'b0011;   // 3
localparam ALU_XOR = 4'b0100;   // 4
localparam ALU_SLT = 4'b0101;   // 5


always @(*) begin
  case (op)
    ALU_ADD: result = a + b;
    ALU_SUB: result = a - b;
    ALU_AND: result = a & b;
    ALU_OR:  result = a | b;
    ALU_XOR: result = a ^ b;
    ALU_SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
    default: result = 32'd0;
  endcase
end

endmodule
