# Generate a C++ model, enable waveforms, and build the executable.
VERILATOR ?= verilator
VERILATOR_FLAGS := --build -cc --trace -Wall

# Phony targets still run when folders with the same names exist.
.PHONY: all
all: part1 part2

# Build and test the one-bit full adder.
.PHONY: part1
part1:
	rm -rf obj_dir_part1 part1_waveform.vcd
	$(VERILATOR) $(VERILATOR_FLAGS) --Mdir obj_dir_part1 \
		--top-module fullAdder ./part1/fullAdder.v --exe ./part1/testbench.cpp
	./obj_dir_part1/VfullAdder

# Reuse fullAdder.v in the ALU; keep generated files in a separate folder.
.PHONY: part2
part2:
	rm -rf obj_dir_part2 part2_waveform.vcd
	$(VERILATOR) $(VERILATOR_FLAGS) --Mdir obj_dir_part2 \
		--top-module alu ./part1/fullAdder.v ./part2/alu.v --exe ./part2/testbench.cpp
	./obj_dir_part2/Valu

# Remove generated files while retaining the source code.
.PHONY: clean
clean:
	rm -rf obj_dir obj_dir_part1 obj_dir_part2
	rm -f waveform.vcd part1_waveform.vcd part2_waveform.vcd