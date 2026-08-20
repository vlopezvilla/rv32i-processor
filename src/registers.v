module registers(
  input clk,
  input [4:0] rs1,          // Read register 1 (x0-x31)
  input [4:0] rs2,          // Read register 2 (x0-x31)
  input [4:0] rd,           // Write register (x0-x31)
  input [31:0] write_data,  // Data to write
  input we,                 // Write Enable (1 = write, 0 = don't write)
  output [31:0] reg_data1,  // Data from register rs1
  output [31:0] reg_data2   // Data from register rs2
);

// 32 registers, each 32 bits wide
reg [31:0] registers [0:31];
integer i;

// Read: combinational (immediate, no clock)
assign reg_data1 = registers[rs1];
assign reg_data2 = registers[rs2];

// Write: synchronous (happens on clock edge)
always @(posedge clk) begin
  if (we && rd != 5'b0)  // Write only if we=1 AND rd is not x0 (x0 is always 0)
    registers[rd] <= write_data;
end

// Initialize all registers to 0
initial begin
  for (i = 0; i < 32; i = i + 1)
    registers[i] = 32'b0;
end

endmodule