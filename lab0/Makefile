PHONY: all build run clean

all: clean build run

build:
	verilator --build -cc --trace -Wall \
		--top-module hello hello.v --exe testbench.cpp

run:
	./obj_dir/Vhello

clean:
	rm -rf obj_dir lab0_waveform.vcd
