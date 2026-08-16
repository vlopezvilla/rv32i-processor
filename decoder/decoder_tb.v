module decoder_tb;
  reg [31:0] instr;
  wire [6:0] opcode;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] funct3;
  wire [6:0] funct7;
  wire [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

  decoder uut(
    .instr(instr),
    .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2),
    .funct3(funct3), .funct7(funct7),
    .imm_i(imm_i), .imm_s(imm_s), .imm_b(imm_b), .imm_u(imm_u), .imm_j(imm_j)
  );

  task check(input [63:0] name, input signed [31:0] got, input signed [31:0] expected);
    begin
      $display("  %-8s got=%-12d expected=%-12d %s",
                name, got, expected, (got === expected) ? "PASS" : "FAIL");
    end
  endtask

  initial begin
    // addi x1, x0, 5  (I-type)
    instr = 32'h00500093;
    #10;
    $display("[ADDI x1, x0, 5]  (I-type)");
    check("opcode", opcode, 7'b0010011);
    check("rd",     rd,     1);
    check("rs1",    rs1,    0);
    check("funct3", funct3, 3'b000);
    check("imm_i",  imm_i,  5);

    // addi x5, x0, -1  (I-type, checks sign extension)
    instr = 32'hFFF00293;
    #10;
    $display("[ADDI x5, x0, -1]  (I-type, sign extension)");
    check("rd",     rd,          5);
    check("imm_i",  $signed(imm_i), -1);

    // add x3, x1, x2  (R-type)
    instr = 32'h002081B3;
    #10;
    $display("[ADD x3, x1, x2]  (R-type)");
    check("opcode", opcode, 7'b0110011);
    check("rd",     rd,     3);
    check("rs1",    rs1,    1);
    check("rs2",    rs2,    2);
    check("funct3", funct3, 3'b000);
    check("funct7", funct7, 7'b0000000);

    // sw x2, 8(x1)  (S-type)
    instr = 32'h0020A423;
    #10;
    $display("[SW x2, 8(x1)]  (S-type)");
    check("rs1",    rs1,   1);
    check("rs2",    rs2,   2);
    check("imm_s",  imm_s, 8);

    // beq x1, x2, +8  (B-type)
    instr = 32'h00208463;
    #10;
    $display("[BEQ x1, x2, +8]  (B-type)");
    check("rs1",    rs1,   1);
    check("rs2",    rs2,   2);
    check("imm_b",  imm_b, 8);

    // lui x1, 0x12345  (U-type)
    instr = 32'h123450B7;
    #10;
    $display("[LUI x1, 0x12345]  (U-type)");
    check("rd",     rd,    1);
    check("imm_u",  imm_u, 32'h12345000);

    // jal x1, +16  (J-type)
    instr = 32'h010000EF;
    #10;
    $display("[JAL x1, +16]  (J-type)");
    check("rd",     rd,    1);
    check("imm_j",  imm_j, 16);

    $finish;
  end
endmodule
