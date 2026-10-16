//Part 2B: cover every required RV32I instruction and both BEQ outcomes.
#include "VSingleCycleCPU.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <cassert>
#include <cstdint>
#include <iostream>
int main(int argc, char** argv) {
VerilatedContext context;
context.commandArgs(argc, argv);
context.traceEverOn(true);
VSingleCycleCPU top{&context};
VerilatedVcdC trace;
top.trace(&trace, 99);
trace.open("cpu_waveform.vcd");
auto step = [&](int clock) {
top.clk = clock; top.eval();
trace.dump(context.time()); context.timeInc(1);
};
top.start = 1; step(0);
top.start = 0; step(0);
top.start = 1; step(0);
for (int cycle = 0; cycle < 40; ++cycle) {
step(0); step(1);
}
const uint32_t expected[][2] = {
{0,0}, {1,5}, {2,0xfffffffdu}, {3,2}, {4,8},
{5,5}, {6,4}, {7,0xfffffffdu}, {8,13},
{9,1}, {10,1}, {11,8}, {12,42}, {13,7}, {14,0}
};
for (const auto& item : expected) {
std::cout << "x" << item[0] << " = " << top.r[item[0]]
<< " (expected " << item[1] << ")\n";
assert(top.r[item[0]] == item[1]);
}
std::cout << "PASS: Lab 2 Part 2 all RV32I instructions\n";
top.final(); trace.close();
return 0;
}
