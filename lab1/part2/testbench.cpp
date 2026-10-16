#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Valu.h"
#include <stdlib.h>
#include <cassert>
#include <iostream>
#include <bitset>
#include <time.h>
using namespace std;

// Create the ALU model and waveform recorder.
Valu *top = new Valu;
vluint64_t sim_time = 0;
VerilatedVcdC *m_trace = new VerilatedVcdC;

// Four-bit fields: A/B are operands, C is expected, Y is actual.
typedef struct{
    unsigned int A : 4;
    unsigned int B : 4;
    unsigned int C : 4;
    unsigned int Y : 4;
}ABC;

void test(){
    ABC abc;
    // Generate 1000 random operand/control combinations.
    for(int i=0; i<1000; i++){
        abc.A = rand() & 0xf;
        abc.B = rand() & 0xf;
        top->a = abc.A;
        top->b = abc.B;
        top->s = rand() & 0x7;
        int x = top->s;
        // Compute the reference result; the four-bit C field keeps the low bits.
        switch(top->s) {
            case 0:
                abc.C = abc.A + abc.B;
                break;
            case 1:
                abc.C = abc.A - abc.B;
                break;
            case 2:
                abc.C = ~abc.A;
                break;
            case 3:
                abc.C = abc.A & abc.B;
                break;
            case 4:
                abc.C = abc.A | abc.B;
                break;
            case 5:
                abc.C = abc.A ^ abc.B;
                break;
            case 6:
                abc.C = abc.A > abc.B ? 1 : 0;
                break;
            case 7:
                abc.C = abc.A == abc.B ? 1 : 0;
                break;
            default:
                abc.C = 0;
                break;
        }

        // Evaluate, record, and compare the ALU result with the reference.
        top->eval();
        m_trace->dump(sim_time);
        sim_time++;
        abc.Y = top->y;
        assert(abc.Y == abc.C);
    }
    cout<<endl;
    cout<<"============================"<<endl;
    cout<<"\033[32m\033[1mPASS: 1000 randomized ALU cases\033[0m\n";
}

int main() {
    time_t start, end;
    // Use a fixed random seed, enable tracing, and run the test.
    srand(465);
    Verilated::traceEverOn(true);
    top->trace(m_trace, 99);
    m_trace->open("part2_waveform.vcd");
    start = clock();
    test();
    end = clock();
    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    m_trace->close();
    cout<<"cpu_time_used : "<<cpu_time_used<<endl;
    cout<<"============================"<<endl;
    delete top;
    return 0;
}