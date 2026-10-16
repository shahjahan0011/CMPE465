module alu(
    input [3:0] a,
    input [3:0] b,
    input [2:0] s,
    output reg [3:0] y
);

    // Shared ADD/SUB inputs: SUB uses inverted b and an initial carry of 1.
    wire subtract = (s == 3'b001);
    wire [3:0] b_for_adder = b ^ {4{subtract}};
    wire [3:0] sum;
    wire [3:0] carry;

    // Discard the fifth result bit; keep only the four-bit result.
    /* verilator lint_off UNUSEDSIGNAL */
    wire final_carry;
    /* verilator lint_on UNUSEDSIGNAL */
    
    // Ripple carry from bit 0 through bit 3 using the Part 1 full adder.
    assign carry[0] = subtract;
    
    fullAdder fa0(.cin(carry[0]), .a(a[0]), .b(b_for_adder[0]),
                .s(sum[0]), .cout(carry[1]));
    fullAdder fa1(.cin(carry[1]), .a(a[1]), .b(b_for_adder[1]),
                .s(sum[1]), .cout(carry[2]));
    fullAdder fa2(.cin(carry[2]), .a(a[2]), .b(b_for_adder[2]),
                .s(sum[2]), .cout(carry[3]));
    fullAdder fa3(.cin(carry[3]), .a(a[3]), .b(b_for_adder[3]),
                .s(sum[3]), .cout(final_carry));

    // Select the result combinationally; every branch assigns y.
    always @(*) begin
        case (s)
            3'b000: y = sum; // ADD
            3'b001: y = sum; // SUB
            3'b010: y = ~a; // NOT
            3'b011: y = a & b; // AND
            3'b100: y = a | b; // OR
            3'b101: y = a ^ b; // XOR
            3'b110: y = (a > b) ? 4'b0001 : 4'b0; // GTU
            3'b111: y = (a == b) ? 4'b0001 : 4'b0; // EQ
            default: y = 4'b0;
        endcase
    end
endmodule
