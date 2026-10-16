# CMPE 465 Labs

Verilog hardware designs, C++ testbenches, and RISC-V assembly exercises for CMPE 465.

| Lab | Contents |
| --- | --- |
| [Lab 0](lab0/) | AND-gate design and exhaustive environment-check testbench |
| [Lab 1, Part 1](lab1/part1/) | One-bit full adder and exhaustive testbench |
| [Lab 1, Part 2](lab1/part2/) | Four-bit ALU using the full adder, with randomized tests |
| [Lab 2](lab2/) | RARS exercises, 32-bit ALU, and a single-cycle RV32I subset CPU with a regression program |

## Run the simulations

Install Verilator, GNU Make, and a C++ compiler. Run each lab from its own directory so the testbenches and CPU can find their input files:

```sh
make -C lab0
make -C lab1
make -C lab2
```

Lab 1 and Lab 2 also support `part1` and `part2` targets:

```sh
make -C lab1 part1
make -C lab1 part2
make -C lab2 part1
make -C lab2 part2
```

Lab 2's CPU supports `add`, `sub`, `and`, `or`, `slt`, `addi`, `andi`, `ori`, `slti`, `lw`, `sw`, and `beq`. It loads `lab2/program.hex`; the corresponding assembly is in `lab2/program.S`.

Simulations generate VCD waveform files in their lab directory. Build outputs and waveforms are ignored by Git and can be removed with each lab's `clean` target.

## RARS exercises

The included `rars.jar` is the RARS simulator. With Java installed, launch it from the repository root:

```sh
java -jar rars.jar
```

Open `lab2/rars_arithmetic.S` or `lab2/rars_memeory.S` to run the standalone RARS exercises. The filename `rars_memeory.S` is preserved as supplied.
