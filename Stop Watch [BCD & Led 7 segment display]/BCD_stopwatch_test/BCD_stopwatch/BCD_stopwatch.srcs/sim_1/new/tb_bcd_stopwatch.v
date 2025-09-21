`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2025 11:16:14 PM
// Design Name: 
// Module Name: tb_bcd_stopwatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_bcd_stopwatch;

  // clock & reset
  reg clk;
  reg rst_n;

  // control inputs
  reg start, stop, lap, clr, load;

  // load data
  reg [3:0] load_ms_hr, load_ls_hr;
  reg [3:0] load_ms_min, load_ls_min;

  // outputs
  wire [2:0] FSM_state;
  wire [3:0] cnt_ms_hr, cnt_ls_hr;
  wire [3:0] cnt_ms_min, cnt_ls_min;
  wire [3:0] lap_ms_hr, lap_ls_hr;
  wire [3:0] lap_ms_min, lap_ls_min;

  // clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100 MHz
  end

  // DUT instantiation
  bcd_stopwatch dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .stop(stop),
    .lap(lap),
    .clr(clr),
    .load(load),
    .load_ms_hr(load_ms_hr),
    .load_ls_hr(load_ls_hr),
    .load_ms_min(load_ms_min),
    .load_ls_min(load_ls_min),
    .FSM_state(FSM_state),
    .cnt_ms_hr(cnt_ms_hr),
    .cnt_ls_hr(cnt_ls_hr),
    .cnt_ms_min(cnt_ms_min),
    .cnt_ls_min(cnt_ls_min),
    .lap_ms_hr(lap_ms_hr),
    .lap_ls_hr(lap_ls_hr),
    .lap_ms_min(lap_ms_min),
    .lap_ls_min(lap_ls_min)
  );

  // stimulus
  initial begin
    // init
    rst_n = 0;
    start = 0; stop = 0; lap = 0; clr = 0; load = 0;
    load_ms_hr = 4'd0; load_ls_hr = 4'd0;
    load_ms_min = 4'd0; load_ls_min = 4'd0;

    #20 rst_n = 1;
    $display("=== RESET release ===");

    // START
    #20 start = 1; #10 start = 0;
    $display("=== START stopwatch ===");
    #50;

    // LAP
    #10 lap = 1; #10 lap = 0;
    $display("=== LAP triggered ===");
    #50;

    // STOP
    #10 stop = 1; #10 stop = 0;
    $display("=== STOP stopwatch ===");
    #50;

    // START again
    #10 start = 1; #10 start = 0;
    $display("=== START again ===");
    #50;

    // CLR
    #10 clr = 1; #10 clr = 0;
    $display("=== CLEAR stopwatch ===");
    #50;

    // LOAD value 12:58
    load_ms_hr = 4'd1; load_ls_hr = 4'd2;
    load_ms_min = 4'd5; load_ls_min = 4'd8;
    #10 load = 1; #10 load = 0;
    $display("=== LOAD value 12:58 ===");
    #50;

    $display("=== SIMULATION END ===");
    $finish;
  end

  initial begin
    $monitor("t=%0t | state=%0d | cnt=%d%d:%d%d | lap=%d%d:%d%d",
      $time, FSM_state,
      cnt_ms_hr, cnt_ls_hr, cnt_ms_min, cnt_ls_min,
      lap_ms_hr, lap_ls_hr, lap_ms_min, lap_ls_min);
  end

endmodule
