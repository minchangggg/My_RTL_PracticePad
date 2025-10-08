module scale_mux_test;
timeunit 1ns;
timeprecision 100ps;

localparam WIDTH = 16;

logic [WIDTH-1:0] out;
logic [WIDTH-1:0] in_a;
logic [WIDTH-1:0] in_b;
logic		  sel_a;

scale_mux #(WIDTH) dut (
	.out	(out),
	.in_a 	(in_a),
	.in_b	(in_b),
	.sel_a	(sel_a)
);

// Monitor result
initial begin
	$timeformat (-9, 1, " ns", 9);
	$monitor ("time = %t in_a = %h in_b = %h sel_a = %b out = %h",$time, in_a, in_b, sel_a, out);
end

// Verify result
task expect_test (
	input [WIDTH-1:0] expects
);
	if (out != expects) begin
		$display ("out = %h, expected data %h", out, expects);
		$display ("MUX TEST FAILED");
	end
endtask

initial begin
	in_a='0; in_b='0; sel_a=0; #1ns expect_test('0);
	in_a='0; in_b='0; sel_a=1; #1ns expect_test('0);
	in_a='0; in_b='1; sel_a=0; #1ns expect_test('1);
	in_a='0; in_b='1; sel_a=1; #1ns expect_test('0);
	in_a='1; in_b='0; sel_a=0; #1ns expect_test('0);
	in_a='1; in_b='0; sel_a=1; #1ns expect_test('1);
	in_a='1; in_b='1; sel_a=0; #1ns expect_test('1);
	in_a='1; in_b='1; sel_a=1; #1ns expect_test('1);
	$display ("MUX TEST PASSED");
	$finish;
end

endmodule
