SRC_DIR = src
TB_DIR  = tb
SIM_DIR = sim

.PHONY: all test clean \
        alu registers decoder cpu \
        test-alu test-registers test-decoder test-cpu

all: alu registers decoder cpu

# --- build ---

alu: $(SIM_DIR)/alu_sim
registers: $(SIM_DIR)/registers_sim
decoder: $(SIM_DIR)/decoder_sim
cpu: $(SIM_DIR)/cpu_sim

$(SIM_DIR)/alu_sim: $(SRC_DIR)/alu.v $(TB_DIR)/alu_tb.v | $(SIM_DIR)
	iverilog -o $@ $^

$(SIM_DIR)/registers_sim: $(SRC_DIR)/registers.v $(TB_DIR)/registers_tb.v | $(SIM_DIR)
	iverilog -o $@ $^

$(SIM_DIR)/decoder_sim: $(SRC_DIR)/decoder.v $(TB_DIR)/decoder_tb.v | $(SIM_DIR)
	iverilog -o $@ $^

$(SIM_DIR)/cpu_sim: $(SRC_DIR)/cpu.v $(SRC_DIR)/decoder.v $(SRC_DIR)/registers.v $(SRC_DIR)/alu.v $(TB_DIR)/cpu_tb.v | $(SIM_DIR)
	iverilog -o $@ $^

$(SIM_DIR):
	mkdir -p $(SIM_DIR)

# --- build + run ---

test-alu: alu
	vvp $(SIM_DIR)/alu_sim

test-registers: registers
	vvp $(SIM_DIR)/registers_sim

test-decoder: decoder
	vvp $(SIM_DIR)/decoder_sim

test-cpu: cpu
	vvp $(SIM_DIR)/cpu_sim

test: test-alu test-registers test-decoder test-cpu

clean:
	rm -f $(SIM_DIR)/*_sim $(SIM_DIR)/*.vcd
