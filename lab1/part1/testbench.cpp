#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VfullAdder.h"
#include <stdlib.h>
#include <cassert>
#include <iostream>
#include <bitset>
#include <time.h>
using namespace std;

// Create the hardware model and waveform recorder.
VfullAdder *top = new VfullAdder;
vluint64_t sim_time = 0;
VerilatedVcdC *m_trace = new VerilatedVcdC;

void test(){
    // Generate all eight combinations of a, b, and cin.
    for(int i=0; i<8; i++){
        int input[3] = {0};
        int tmp = i;
        for (int i = 2; i >= 0; i--){
            input[i] = tmp % 2;
            tmp /= 2;
        }
        top->cin = input[2];
        top->b = input[1];
        top->a = input[0];
        // Evaluate the driven inputs and record one waveform sample.
        top->eval();
        m_trace->dump(sim_time);
        sim_time++;
        // Check sum and carry against an independent arithmetic result.
        int ans = (top->a + top->b + top->cin);
        assert(top->cout == ans / 2);
        assert(top->s == ans % 2);
    }
    cout<<endl;
    cout<<"============================"<<endl;
    cout<<"\033[32m\033[1mPASS: all 8 full-adder input combinations\033[0m\n";
}

int main() {
    time_t start, end;
    // Configure tracing, run the test, and report CPU time.
    srand(1111);
    Verilated::traceEverOn(true);
    top->trace(m_trace, 99);
    m_trace->open("part1_waveform.vcd");
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