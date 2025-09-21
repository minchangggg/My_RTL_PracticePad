`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2025 11:15:31 PM
// Design Name: 
// Module Name: bcd_stopwatch
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


module bcd_stopwatch (
  input wire       clk, rst_n, load,      // clock, reset active low, load enable
  input wire       start, lap, stop, clr, // control buttons
  input wire [3:0] load_ms_hr,load_ls_hr,load_ms_min,load_ls_min, // load time: hour + min
  output reg [2:0] FSM_state,             // current FSM state (for debug/monitoring)
  output reg [3:0] cnt_ms_hr, cnt_ls_hr, cnt_ms_min, cnt_ls_min,  // stopwatch count
  output reg [3:0] lap_ms_hr, lap_ls_hr, lap_ms_min, lap_ls_min   // lap time storage
);

  reg [2:0] cur_state, next_state;

  // FSM states
  parameter IDLE_STATE  = 3'b000; // reset/init
  parameter RUN_STATE   = 3'b001; // counting
  parameter LAP_STATE   = 3'b010; // store lap, still counting
  parameter STOP_STATE  = 3'b011; // pause counter
  parameter CLEAR_STATE = 3'b100; // clear counter, keep lap

  // /*
  initial begin
    cur_state = IDLE_STATE; next_state = IDLE_STATE;
    FSM_state = IDLE_STATE;
    cnt_ms_hr = 4'd0; cnt_ls_hr = 4'd0; cnt_ms_min = 4'd0; cnt_ls_min = 4'd0;
    lap_ms_hr = 4'd0; lap_ls_hr = 4'd0; lap_ms_min = 4'd0; lap_ls_min = 4'd0;
  end
  // */

  // -------------------------
  // FSM state register (sequential)
  // -------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cur_state <= IDLE_STATE;
    else        cur_state <= next_state;
  end

  // -------------------------
  // FSM next-state logic (combinational)
  // -------------------------
  always @(*) begin
    next_state = cur_state;
    case (cur_state)
      IDLE_STATE: next_state = (start) ? RUN_STATE : IDLE_STATE;
      RUN_STATE: begin
        if      (start) next_state = RUN_STATE;
        else if (lap)   next_state = LAP_STATE;
        else if (stop)  next_state = STOP_STATE;
        else if (clr)   next_state = CLEAR_STATE;
        else            next_state = RUN_STATE;
      end
      LAP_STATE: begin
        if      (start) next_state = RUN_STATE;
        else if (lap)   next_state = LAP_STATE;
        else if (stop)  next_state = STOP_STATE;
        else if (clr)   next_state = CLEAR_STATE;
        else            next_state = RUN_STATE;
      end
      STOP_STATE: begin
        if      (start) next_state = RUN_STATE;  // Press start to resume counting
        else if (lap)   next_state = LAP_STATE;
        else if (stop)  next_state = STOP_STATE;
        else if (clr)   next_state = CLEAR_STATE;
        else            next_state = STOP_STATE; // hold
      end
      CLEAR_STATE: begin
        if      (start) next_state = RUN_STATE;  // restart counting
        else if (lap)  next_state = LAP_STATE;
        else if (stop) next_state = STOP_STATE;
        else if (clr)  next_state = CLEAR_STATE;
        else           next_state = RUN_STATE;   // restart counting
      end
      
      default: next_state = IDLE_STATE;
    endcase
  end

  // -------------------------
  // Counter + lap sequential logic (synchronous)
  // -------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset values
      cnt_ms_hr <= 4'd0; cnt_ls_hr <= 4'd0; cnt_ms_min <= 4'd0; cnt_ls_min <= 4'd0;
      lap_ms_hr <= 4'd0; lap_ls_hr <= 4'd0; lap_ms_min <= 4'd0; lap_ls_min <= 4'd0;
      FSM_state <= IDLE_STATE;
    end
    else begin
      // update external FSM_state output to reflect current state (synchronous)
      FSM_state <= cur_state; 
      
      case (cur_state)
        IDLE_STATE: begin
          // initialize counter = 0
          cnt_ms_hr <= 4'd0; cnt_ls_hr <= 4'd0; cnt_ms_min <= 4'd0; cnt_ls_min <= 4'd0;
        end
        RUN_STATE: begin
          if (load) begin
            // load value synchronously when load asserted
            {cnt_ms_hr, cnt_ls_hr, cnt_ms_min, cnt_ls_min} <= 
            {load_ms_hr, load_ls_hr, load_ms_min, load_ls_min};
          end else begin
            // increment BCD time 1 minute per call.
            {cnt_ms_hr, cnt_ls_hr, cnt_ms_min, cnt_ls_min} <= 
            bcd_increment({cnt_ms_hr, cnt_ls_hr, cnt_ms_min, cnt_ls_min});
          end
        end
        LAP_STATE: begin
          // capture lap (snapshot current counter) 
          lap_ms_hr <= cnt_ms_hr; lap_ls_hr <= cnt_ls_hr; 
          lap_ms_min <= cnt_ms_min; lap_ls_min <= cnt_ls_min;
          // still increment while in LAP state 
          {cnt_ms_hr, cnt_ls_hr, cnt_ms_min, cnt_ls_min} <= 
          bcd_increment({cnt_ms_hr, cnt_ls_hr, cnt_ms_min, cnt_ls_min});
        end
        STOP_STATE: begin
          // hold counter and lap unchanged (do nothing)
          cnt_ms_hr <= cnt_ms_hr; cnt_ls_hr <= cnt_ls_hr; 
          cnt_ms_min <= cnt_ms_min; cnt_ls_min <= cnt_ls_min;
          lap_ms_hr <= lap_ms_hr; lap_ls_hr <= lap_ls_hr; 
          lap_ms_min <= lap_ms_min; lap_ls_min <= lap_ls_min;
        end
        CLEAR_STATE: begin
          // clear counter and lap unchanged
          cnt_ms_hr <= 0; cnt_ls_hr <= 0; 
          cnt_ms_min <= 0; cnt_ls_min <= 0;
          lap_ms_hr <= lap_ms_hr; lap_ls_hr <= lap_ls_hr; 
          lap_ms_min <= lap_ms_min; lap_ls_min <= lap_ls_min;
        end
        default: begin
          // keep current values
          cnt_ms_hr <= cnt_ms_hr; cnt_ls_hr <= cnt_ls_hr; 
          cnt_ms_min <= cnt_ms_min; cnt_ls_min <= cnt_ls_min;
          lap_ms_hr <= lap_ms_hr; lap_ls_hr <= lap_ls_hr; 
          lap_ms_min <= lap_ms_min; lap_ls_min <= lap_ls_min;
        end
      endcase
    end
  end

  // -------------------------
  // BCD increment function (combinational)
  // Input:  16-bit BCD {ms_hr, ls_hr, ms_min, ls_min}
  // Output: +1 minute (with wrap at 23:59 -> 00:00)
  // -------------------------
  function [15:0] bcd_increment(
    input [15:0] tmr_cur // {ms_hr, ls_hr, ms_min, ls_min}
  );
    reg [3:0] update_ms_hr, update_ls_hr, update_ms_min, update_ls_min;
    begin
      
      {update_ms_hr, update_ls_hr, update_ms_min, update_ls_min} = tmr_cur;

      // ==== Case 1: 23:59 -> 00:00 ====
      if (update_ms_hr==4'd2 && update_ls_hr==4'd3 && update_ms_min==4'd5 && update_ls_min==4'd9) begin
        update_ms_hr=0; update_ls_hr=0; update_ms_min=0; update_ls_min=0;
      end
      
      // ==== Case 2: minute = 59 -> reset minutes, increment hour ====
      else if (update_ms_min==4'd5 && update_ls_min==4'd9) begin
        update_ms_min=0; update_ls_min=0;
        if (update_ls_hr==4'd9) begin
          update_ls_hr=0;
          update_ms_hr=(update_ms_hr==4'd2)?4'd0:update_ms_hr+1;
        end else 
          update_ls_hr=(update_ms_hr==4'd2 && update_ls_hr==4'd3)?4'd0:update_ls_hr+1;
      end

      // ==== Case 3: unit minute = 9 -> carry to tens of minutes ====
      else if (update_ls_min==4'd9) begin
        update_ls_min=0;
        update_ms_min=update_ms_min+1;
      end

      // ==== Case 4: normal increment ====
      else begin
        update_ls_min=update_ls_min+1;
      end

      bcd_increment = {update_ms_hr, update_ls_hr, update_ms_min, update_ls_min};
    end
  endfunction

endmodule
