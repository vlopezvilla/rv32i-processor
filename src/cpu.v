module cpu(
  input clk,
  input rst,
  input [31:0] instr,
  output [31:0] pc,
  output [31:0] alu_result,
  output [31:0] reg_write_data
);

localparam OPCODE_OP_IMM = 7'b0010011; // ADDI, ANDI, ORI, XORI, SLTI...
localparam OPCODE_OP     = 7'b0110011; // ADD, SUB, AND, OR, XOR, SLT...

// Program counter: increments by 4 each cycle, resets to 0
reg [31:0] pc_reg;
assign pc = pc_reg;

always @(posedge clk) begin
  if (rst)
    pc_reg <= 32'b0;
  else
    pc_reg <= pc_reg + 4;
end

// Decode
wire [6:0] opcode;
wire [4:0] rd, rs1, rs2;
wire [2:0] funct3;
wire [6:0] funct7;
wire [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

decoder dec(
  .instr(instr),
  .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2),
  .funct3(funct3), .funct7(funct7),
  .imm_i(imm_i), .imm_s(imm_s), .imm_b(imm_b), .imm_u(imm_u), .imm_j(imm_j)
);

// Control: which ALU op does this instruction need?
// (funct3 encoding matches RV32I for both R-type and I-type ALU instructions)
reg [3:0] alu_op;
always @(*) begin
  case (funct3)
    3'b000:  alu_op = (opcode == OPCODE_OP && funct7 == 7'b0100000) ? 4'b0001  // SUB
                                                                     : 4'b0000; // ADD/ADDI
    3'b010:  alu_op = 4'b0101; // SLT/SLTI
    3'b100:  alu_op = 4'b0100; // XOR/XORI
    3'b110:  alu_op = 4'b0011; // OR/ORI
    3'b111:  alu_op = 4'b0010; // AND/ANDI
    default: alu_op = 4'b0000;
  endcase
end

// Register file
wire [31:0] reg_data1, reg_data2;
wire reg_we = (opcode == OPCODE_OP_IMM) || (opcode == OPCODE_OP);

registers regfile(
  .clk(clk),
  .rs1(rs1), .rs2(rs2), .rd(rd),
  .write_data(reg_write_data),
  .we(reg_we),
  .reg_data1(reg_data1), .reg_data2(reg_data2)
);

// ALU operand B: immediate for I-type ALU ops, rs2 data for R-type
wire [31:0] alu_b = (opcode == OPCODE_OP_IMM) ? imm_i : reg_data2;

alu alu_inst(
  .a(reg_data1), .b(alu_b), .op(alu_op), .result(alu_result)
);

assign reg_write_data = alu_result;

endmodule
