module alu (
  input  logic [7:0] a_i,
  input  logic [7:0] b_i,
  input  logic [3:0] opcode_i,   // mở rộng opcode lên 4 bit
  output logic [7:0] alu_o
);

  // Enum for ALU operation codes
  localparam  OP_ADD   = 4'b0000; // Addition
  localparam  OP_SUB   = 4'b0001; // Subtraction
  localparam  OP_SLL   = 4'b0010; // Logical Shift Left
  localparam  OP_LSR   = 4'b0011; // Logical Shift Right
  localparam  OP_AND   = 4'b0100; // Logic AND
  localparam  OP_OR    = 4'b0101; // Logic OR
  localparam  OP_XOR   = 4'b0110; // Logic XOR
  localparam  OP_EQL   = 4'b0111; // Logic Equal
  localparam  OP_NAND  = 4'b1000; // Logic NAND
  localparam  OP_NOR   = 4'b1001; // Logic NOR
  localparam  OP_XNOR  = 4'b1010; // Logic XNOR
  localparam  OP_NOT_A = 4'b1011; // NOT A
  localparam  OP_INC_A = 4'b1100; // Increment A
  localparam  OP_DEC_A = 4'b1101; // Decrement A
  localparam  OP_PASS_B= 4'b1110; // Pass B as output
  localparam  OP_PASS_A= 4'b1111; // Pass A as output

  logic carry;

  always_comb begin
    alu_o = '0;
    carry = 1'b0;
    case (opcode_i)
      OP_ADD:   {carry, alu_o} = {1'b0, a_i} + {1'b0, b_i};
      OP_SUB:   alu_o = a_i - b_i;
      OP_SLL:   alu_o = a_i << b_i[2:0];
      OP_LSR:   alu_o = a_i >> b_i[2:0];
      OP_AND:   alu_o = a_i & b_i;
      OP_OR:    alu_o = a_i | b_i;
      OP_XOR:   alu_o = a_i ^ b_i;
      OP_EQL:   alu_o = {7'b0, a_i == b_i};
      OP_NAND:  alu_o = ~(a_i & b_i);
      OP_NOR:   alu_o = ~(a_i | b_i);
      OP_XNOR:  alu_o = ~(a_i ^ b_i);
      OP_NOT_A: alu_o = ~a_i;
      OP_INC_A: alu_o = a_i + 1;
      OP_DEC_A: alu_o = a_i - 1;
      OP_PASS_B:alu_o = b_i;
      OP_PASS_A:alu_o = a_i;
      default:  alu_o = 8'h00;
    endcase
  end

endmodule
