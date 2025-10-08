module mem_test (
	input	logic 		clk,
	input	logic [7:0] 	data_out,
	output	logic [4:0]	addr,
	output	logic		read,
	output	logic		write,
	output	logic [7:0]	data_in
);

timeunit 1ns;
timeprecision 100ps;

bit debug = 1;
logic [7:0] rdata;

initial begin
	$timeformat (-9, 0, " ns", 9);
	#4000ns
	$display ("MEMORY TEST TIMEOUT TT__TT!!!");
	$finish;
end

task write_mem (
	input [4:0] waddr,
	input [7:0] wdata,
	input debug = 0
);
	@(negedge clk);
	write <= 1;
	read  <= 0;
	addr   <= waddr;
	data_in <= wdata;
	@(negedge clk);
	write <= 0;
	if (debug == 1)
		$display ("WRITE - Address: %h    DATA: %h",waddr, wdata);
endtask

task read_mem (
	input [4:0] raddr,
	output [7:0] rdata,
	input debug = 0
);
	@(negedge clk);
	write <= 0;
	read  <= 1;
	addr   <= raddr;
	@(negedge clk);
	read <= 0;
	rdata = data_out;
	if (debug == 1)
		$display ("READ - Address: %h    DATA: %h",raddr, rdata);
endtask

function int check (
	input [4:0] address,
	input [7:0] actual, expected
);

	static int error_status;
	if (actual != expected) begin
		$display("ERROR: Address: %h Data: %h Expected: %h", address, actual, expected);
		error_status++;
	end
	return (error_status);
endfunction: check

function void printstatus (input int status);
	if (status == 0)
		$display ("MEMORY TEST PASSED ^__^!!!");
	else
		$display ("MEMORY TEST FAILED TT__TT!!! with %d Errors", status);
endfunction

initial begin
int error_status;
	$display ("MEMORY TEST CLEAR");
	for (int i = 0; i < 32; i++)
		write_mem (i, 0, debug);
	for (int i = 0; i < 32; i++) begin
		read_mem (i, rdata, debug);
		error_status = check (i, rdata, 8'h00);
	end
	printstatus(error_status);
	////////////////////////////////////////////////
	$display ("MEMORY TEST DATA = ADDRESS");
	for (int i = 0; i < 32; i++)
		write_mem (i, i, debug);
	for (int i = 0; i < 32; i++) begin
		read_mem (i, rdata, debug);
		error_status = check (i, rdata, i);
	end
	printstatus(error_status);
	$finish;
end

endmodule
