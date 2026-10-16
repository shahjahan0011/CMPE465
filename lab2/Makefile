# Run commands from the lab2 directory. Every recipe line starts with a TAB.
VERILATOR ?= verilator
FLAGS := --build -cc --trace -Wall -Wno-UNUSEDSIGNAL
RTL := ALU.v SingleCycleCPU.v
.PHONY: all part1 part2 lint clean
all: part1 part2

# Part 1: same ALU concepts as Lab 1, now 32-bit.
part1:
		$(VERILATOR) $(FLAGS) --Mdir obj_dir_alu --top-module ALU \
		ALU.v --exe alu_testbench.cpp
		./obj_dir_alu/VALU

# Check CPU wiring before running the complete program.
lint:
		$(VERILATOR) --lint-only -Wall -Wno-UNUSEDSIGNAL \
		--top-module SingleCycleCPU $(RTL)

# Part 2: execute all 12 supported RV32I instructions.
part2: lint
		$(VERILATOR) $(FLAGS) --Mdir obj_dir_cpu \
		--top-module SingleCycleCPU $(RTL) --exe cpu_testbench.cpp
		./obj_dir_cpu/VSingleCycleCPU

# Remove only generated files, not the student's source.
clean:
		rm -rf obj_dir_alu obj_dir_cpu
		rm -f alu_waveform.vcd cpu_waveform.vcd
