`timescale 1ns/1ps

module tb_led7seg_stopwatch;

  reg clk, rst_n, load;
  reg start, lap, stop, clr;
  reg [3:0] load_hr_tens, load_hr_ones, load_min_tens, load_min_ones;

  wire [6:0] seg_cnt_min_ones, seg_cnt_min_tens;
  wire [6:0] seg_cnt_hr_ones,  seg_cnt_hr_tens;
  wire [6:0] seg_lap_min_ones, seg_lap_min_tens;
  wire [6:0] seg_lap_hr_ones,  seg_lap_hr_tens;

  // internal wires (monitor)
  wire [2:0] FSM_state;
  wire [3:0] cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones;
  wire [3:0] lap_hr_tens, lap_hr_ones, lap_min_tens, lap_min_ones;

  // DUT
  led7seg_stopwatch dut (
    .clk(clk), .rst_n(rst_n), .load(load),
    .start(start), .lap(lap), .stop(stop), .clr(clr),
    .load_hr_tens(load_hr_tens), .load_hr_ones(load_hr_ones),
    .load_min_tens(load_min_tens), .load_min_ones(load_min_ones),
    .seg_cnt_min_ones(seg_cnt_min_ones), .seg_cnt_min_tens(seg_cnt_min_tens),
    .seg_cnt_hr_ones(seg_cnt_hr_ones),   .seg_cnt_hr_tens(seg_cnt_hr_tens),
    .seg_lap_min_ones(seg_lap_min_ones), .seg_lap_min_tens(seg_lap_min_tens),
    .seg_lap_hr_ones(seg_lap_hr_ones),   .seg_lap_hr_tens(seg_lap_hr_tens)
  );

  // Map internal signals
  assign FSM_state     = dut.core.FSM_state;
  assign cnt_hr_tens   = dut.core.cnt_hr_tens;
  assign cnt_hr_ones   = dut.core.cnt_hr_ones;
  assign cnt_min_tens  = dut.core.cnt_min_tens;
  assign cnt_min_ones  = dut.core.cnt_min_ones;
  assign lap_hr_tens   = dut.core.lap_hr_tens;
  assign lap_hr_ones   = dut.core.lap_hr_ones;
  assign lap_min_tens  = dut.core.lap_min_tens;
  assign lap_min_ones  = dut.core.lap_min_ones;

  // clock
  always #5 clk = ~clk;

  initial begin
    clk = 0; rst_n = 0; load = 0;
    start = 0; lap = 0; stop = 0; clr = 0;
    load_hr_tens = 0; load_hr_ones = 0;
    load_min_tens = 0; load_min_ones = 0;

    // reset
    #20 rst_n = 1;

    // load initial 12:58
    #10 load_hr_tens = 1; load_hr_ones = 2;
        load_min_tens = 5; load_min_ones = 8;
        load = 1; 
    $display(">> LOAD time = %0d%0d:%0d%0d", load_hr_tens, load_hr_ones, load_min_tens, load_min_ones);
    #10 load = 0;

    // start
    #10 start = 1; $display(">> START pressed"); #10 start = 0;

    // run for 20 cycles
    repeat(20) @(posedge clk);

    // lap
    #10 lap = 1; $display(">> LAP pressed"); #10 lap = 0;
    repeat(10) @(posedge clk);

    // stop
    #10 stop = 1; $display(">> STOP pressed"); #10 stop = 0;
    repeat(10) @(posedge clk);

    // clear
    #10 clr = 1; $display(">> CLEAR pressed"); #10 clr = 0;
    repeat(10) @(posedge clk);

    // reset again before start
    #10 rst_n = 0; $display(">> RESET pressed");
    #20 rst_n = 1;

    // start again
    #10 start = 1; $display(">> START pressed again"); #10 start = 0;
    repeat(15) @(posedge clk);

    $finish;
  end

  // Monitor
  initial begin
    $display("time | state | counter (hh:mm) | lap (hh:mm)");
    $monitor("t=%0t | state=%0d | cnt=%0d%0d:%0d%0d | lap=%0d%0d:%0d%0d",
             $time, FSM_state,
             cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones,
             lap_hr_tens, lap_hr_ones, lap_min_tens, lap_min_ones);
  end

endmodule