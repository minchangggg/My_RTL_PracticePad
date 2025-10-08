// Simple ALU TB

module tb_alu;
  logic [7:0] a_i;
  logic [7:0] b_i;
  logic [3:0] opcode_i;
  logic [7:0] alu_o;

  // Instantiate ALU
  alu dut (.*);

  /*
  initial begin
    for (int j =0; j<3; j++) begin
      for (int i =0; i<7; i++) begin
        a_i = $urandom_range(0, 8'hFF);
        b_i = $urandom_range(0, 8'hFF);
        opcode_i = 3'(i);
        #5;
      end
    end
  end
  */

  initial begin
    $display("Time | Opcode | A        | B        | ALU Output");
    $display("-----------------------------------------------");

    for (int i = 0; i < 16; i++) begin
      opcode_i = i;
      a_i = $urandom_range(0, 8'hFF);
      b_i = $urandom_range(0, 8'hFF);
      #5;  // wait for combinational logic
      $display("%4t | %b   | %b | %b | %b", $time, opcode_i, a_i, b_i, alu_o);
    end
  end

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, tb_alu);
  end
endmodule
