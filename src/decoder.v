module decoder(
  input [31:0] instr,         // 32-bit instruction
  output [6:0] opcode,        // Operation code
  output [4:0] rd,            // Destination register
  output [4:0] rs1,           // Source register 1
  output [4:0] rs2,           // Source register 2
  output [2:0] funct3,        // Function selector (3-bit)
  output [6:0] funct7,        // Function selector (7-bit)
  output [31:0] imm_i,        // I-type immediate (signed, 12-bit extended to 32)
  output [31:0] imm_s,        // S-type immediate (for store)
  output [31:0] imm_b,        // B-type immediate (for branch)
  output [31:0] imm_u,        // U-type immediate (for upper immediate)
  output [31:0] imm_j         // J-type immediate (for jump)
);

// Extract fields from instruction
assign opcode = instr[6:0];
assign rd     = instr[11:7];
assign funct3 = instr[14:12];
assign rs1    = instr[19:15];
assign rs2    = instr[24:20];
assign funct7 = instr[31:25];

// Decode immediates (sign-extended)
// I-type: bits[31:20] sign-extended to 32 bits
assign imm_i = {{20{instr[31]}}, instr[31:20]};

// S-type: bits[31:25] and bits[11:7] concatenated and sign-extended
assign imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};

// B-type: bits[31], bits[7], bits[30:25], bits[11:8] shifted left 1
assign imm_b = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};

// U-type: bits[31:12] shifted left 12
assign imm_u = {instr[31:12], 12'b0};

// J-type: bits[31], bits[19:12], bits[20], bits[30:21] shifted left 1
assign imm_j = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

endmodule