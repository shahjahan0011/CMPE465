// Single-cycle CPU: fetch, decode, execute, memory, and write-back.
module SingleCycleCPU (
    input wire clk,
    input wire start, // Active-low reset: 0=reset, 1=run
    output wire [31:0] r [0:31], // Expose x0-x31 to the testbench
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instruction,
    output wire debug_branch_taken
);
    reg [31:0] pc;
    reg [31:0] regs [0:31];
    reg [31:0] imem [0:63]; // Up to 64 instructions
    reg [31:0] dmem [0:63]; // 64 32-bit data words
    integer i, j;

// FETCH: PC is a byte address, so word index = PC / 4.
    wire [31:0] insn = (pc < 32'd256 && pc[1:0] == 2'b00)
              ? imem[pc[7:2]] : 32'h00000013;
    wire [6:0] opcode = insn[6:0];
    wire [4:0] rd = insn[11:7];
    wire [2:0] funct3 = insn[14:12];
    wire [4:0] rs1 = insn[19:15];
    wire [4:0] rs2 = insn[24:20];
    wire [6:0] funct7 = insn[31:25];
    wire [31:0] a = regs[rs1];
    wire [31:0] b = regs[rs2];

// DECODE: reconstruct immediates and choose the ALU operation.
    reg [31:0] imm;
    reg reg_write, mem_write, alu_src, mem_to_reg, branch;
    reg [2:0] alu_control;
    always @(*) begin
    imm = 0;
    reg_write = 0; mem_write = 0; alu_src = 0;
    mem_to_reg = 0; branch = 0; alu_control = 0;
    case (opcode)
        7'b0110011: begin // R-type: add/sub/and/or/slt
            case (funct3)
                3'b000: if (funct7 == 7'b0) begin
                    reg_write = 1; alu_control = 0; // ADD
                end else if (funct7 == 7'b0100000) begin
                    reg_write = 1; alu_control = 1; // SUB
                end
                3'b111: if (funct7 == 7'b0) begin
                    reg_write = 1; alu_control = 2; // AND
                end
                3'b110: if (funct7 == 7'b0) begin
                    reg_write = 1; alu_control = 3; // OR
                end
                3'b010: if (funct7 == 7'b0) begin
                    reg_write = 1; alu_control = 4; // SLT
                end
                default: begin end
            endcase
        end

    7'b0010011: begin // I-type: addi/andi/ori/slti
        imm = {{20{insn[31]}}, insn[31:20]};
        alu_src = 1;
        case (funct3)
            3'b000: begin reg_write = 1; alu_control = 0; end
            3'b111: begin reg_write = 1; alu_control = 2; end
            3'b110: begin reg_write = 1; alu_control = 3; end
            3'b010: begin reg_write = 1; alu_control = 4; end
            default: begin end
        endcase
    end

    7'b0000011: if (funct3 == 3'b010) begin // LW
        imm = {{20{insn[31]}}, insn[31:20]};
        reg_write = 1; alu_src = 1; mem_to_reg = 1;
    end
    7'b0100011: if (funct3 == 3'b010) begin // SW
        imm = {{20{insn[31]}}, insn[31:25], insn[11:7]};
        mem_write = 1; alu_src = 1;
    end
    7'b1100011: if (funct3 == 3'b000) begin // BEQ
        imm = {{19{insn[31]}}, insn[31], insn[7],
            insn[30:25], insn[11:8], 1'b0};
        branch = 1; alu_control = 1; // SUB; zero means equal
        end
default: begin end // Unknown instruction = no state change
endcase
end
// EXECUTE: 32-bit ALU built from the Lab 1 arithmetic idea.
wire [31:0] operand_b = alu_src ? imm : b;
wire [31:0] alu_result;
wire zero;
ALU alu(.a(a), .b(operand_b), .control(alu_control),
.result(alu_result), .zero(zero));
// MEMORY: this small lab supports aligned word loads/stores only.
wire valid_addr = (alu_result <= 32'd252) &&
(alu_result[1:0] == 2'b00);
wire [31:0] load_data = valid_addr ? dmem[alu_result[7:2]] : 0;
wire [31:0] write_data = mem_to_reg ? load_data : alu_result;
wire take_branch = branch && zero;
wire [31:0] next_pc = take_branch ? pc + imm : pc + 32'd4;
// COMMIT: the complete instruction finishes on each rising edge.
always @(posedge clk or negedge start) begin
if (!start) begin
pc <= 0;
for (i = 0; i < 32; i = i + 1) regs[i] <= 0;
for (i = 0; i < 64; i = i + 1) dmem[i] <= 0;
end else begin
pc <= next_pc;
if (mem_write && valid_addr) dmem[alu_result[7:2]] <= b;
if (reg_write && rd != 0) regs[rd] <= write_data;
regs[0] <= 0; // RISC-V x0 stays zero
end
end
// LOAD IMAGE: one 32-bit hex instruction per text line.
initial begin
for (j = 0; j < 64; j = j + 1) imem[j] = 32'h00000013;
$readmemh("program.hex", imem);
end
genvar k;
generate
for (k = 0; k < 32; k = k + 1) begin : exposed
assign r[k] = regs[k];
end
endgenerate
assign debug_pc = pc;
assign debug_instruction = insn;
assign debug_branch_taken = take_branch;
endmodule
