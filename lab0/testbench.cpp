#include <verilated.h>
#include <verilated_vcd_c.h>
#include <cassert>
#include <iostream>
#include "Vhello.h"
int main(int argc, char **argv) {
	VerilatedContext context;
	context.commandArgs(argc, argv);
	context.traceEverOn(true);

	Vhello top{&context};
	VerilatedVcdC trace;
	top.trace(&trace, 5);
	trace.open("lab0_waveform.vcd");

	for (int a = 0; a <= 1; ++a) {
		for (int b = 0; b <= 1; ++b) {
			top.a = a;
			top.b = b;
			top.eval();
			trace.dump(context.time());
			context.timeInc(1);

			const int expected = a & b;
			std::cout << "a=" << a << " b=" << b
				<< " y=" << static_cast<int>(top.y)
				<< " expected=" << expected << '\n';
			assert(top.y == expected);
		}
	}

	top.final();
	trace.close();
	std::cout << "PASS: CMPE 465 Lab 0 environment check" << std::endl;
	return 0;
}
