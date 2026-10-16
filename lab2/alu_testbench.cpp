// Part 1: independent reference checks for the 32-bit ALU.
#include "VALU.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <cassert>
#include <cstdint>
#include <iostream>

int main(int argc, char** argv) {
    VerilatedContext context;
    context.commandArgs(argc, argv);
    context.traceEverOn(true);
    VALU top{&context};
    VerilatedVcdC trace;
    top.trace(&trace, 10);
    trace.open("alu_waveform.vcd");

    auto check = [&](uint32_t a, uint32_t b, uint8_t ctl, uint32_t expected) {
        top.a = a; top.b = b; top.control = ctl;
        top.eval();
        trace.dump(context.time()); context.timeInc(1);
        assert(top.result == expected); // Compare with reference
        assert(top.zero == (expected == 0)); // BEQ needs this flag
    };

    check(15, 1, 0, 16); // Lab 1: overflow past four bits
    check(3, 5, 1, 0xfffffffeu); // 3 - 5 = -2
    check(12, 10, 2, 8); // AND
    check(5, 8, 3, 13); // OR
    check(0xfffffffdu, 5, 4, 1); // Signed: -3 < 5
    check(5, 0xfffffffdu, 4, 0); // Signed: 5 < -3 is false
    check(7, 7, 1, 0); // Equality sets zero=1

    std::cout << "PASS: Lab 2 Part 1 ALU checks\n";
    top.final(); trace.close();
    return 0;
}
