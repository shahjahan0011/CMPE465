// Lab 2: 32-bit ALU. The arithmetic ideas come from Lab 1.
module ALU (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [2:0] control,
    output reg [31:0] result,
    output wire zero
);
// Lab 1 used 4-bit operands; RV32I uses 32-bit registers.
always @(*) begin
            case (control)
                3'b000: result = a + b; // ADD
                3'b001: result = a - b; // SUB (two's complement)
                3'b010: result = a & b; // AND
                3'b011: result = a | b; // OR
                3'b100: result = ($signed(a) < $signed(b))
                ? 32'd1 : 32'd0; // SLT (signed)
                default: result = 32'd0; // Safe default
            endcase
        end
    assign zero = (result == 32'd0); // Used by BEQ
endmodule
