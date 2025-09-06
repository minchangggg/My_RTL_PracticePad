module led7seg_stopwatch (
  input wire clk, rst_n, load,
  input wire start, lap, stop, clr,
  // load time inputs (hh:mm)
  input wire [3:0] load_hr_tens,  // hour tens (0..2)
  input wire [3:0] load_hr_ones,  // hour ones (0..9)
  input wire [3:0] load_min_tens, // minute tens (0..5)
  input wire [3:0] load_min_ones, // minute ones (0..9)
  // counter display (hh:mm)
  output [6:0] seg_cnt_min_ones, seg_cnt_min_tens,
  output [6:0] seg_cnt_hr_ones,  seg_cnt_hr_tens,
  // lap display (hh:mm)
  output [6:0] seg_lap_min_ones, seg_lap_min_tens,
  output [6:0] seg_lap_hr_ones,  seg_lap_hr_tens
);

  wire [3:0] cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones;
  wire [3:0] lap_hr_tens, lap_hr_ones, lap_min_tens, lap_min_ones;
  wire [2:0] FSM_state;

  // Stopwatch core
  bcd_stopwatch core (
    .clk(clk), .rst_n(rst_n), .load(load),
    .start(start), .lap(lap), .stop(stop), .clr(clr),
    .load_hr_tens(load_hr_tens), .load_hr_ones(load_hr_ones),
    .load_min_tens(load_min_tens), .load_min_ones(load_min_ones),
    .FSM_state(FSM_state),
    .cnt_hr_tens(cnt_hr_tens), .cnt_hr_ones(cnt_hr_ones),
    .cnt_min_tens(cnt_min_tens), .cnt_min_ones(cnt_min_ones),
    .lap_hr_tens(lap_hr_tens), .lap_hr_ones(lap_hr_ones),
    .lap_min_tens(lap_min_tens), .lap_min_ones(lap_min_ones)
  );

  // Decode Counter
  seg7_decoder u_cnt_min_ones (.bcd(cnt_min_ones), .seg(seg_cnt_min_ones));
  seg7_decoder u_cnt_min_tens (.bcd(cnt_min_tens), .seg(seg_cnt_min_tens));
  seg7_decoder u_cnt_hr_ones  (.bcd(cnt_hr_ones),  .seg(seg_cnt_hr_ones));
  seg7_decoder u_cnt_hr_tens  (.bcd(cnt_hr_tens),  .seg(seg_cnt_hr_tens));

  // Decode Lap
  seg7_decoder u_lap_min_ones (.bcd(lap_min_ones), .seg(seg_lap_min_ones));
  seg7_decoder u_lap_min_tens (.bcd(lap_min_tens), .seg(seg_lap_min_tens));
  seg7_decoder u_lap_hr_ones  (.bcd(lap_hr_ones),  .seg(seg_lap_hr_ones));
  seg7_decoder u_lap_hr_tens  (.bcd(lap_hr_tens),  .seg(seg_lap_hr_tens));

endmodule

module bcd_stopwatch (
  input wire       clk, rst_n, load,      // clock, reset active low, load enable
  input wire       start, lap, stop, clr, // control buttons
  input wire [3:0] load_hr_tens, load_hr_ones, load_min_tens, load_min_ones, // load time
  output reg [2:0] FSM_state,             // current FSM state (for debug/monitoring)
  output reg [3:0] cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones,  // stopwatch count
  output reg [3:0] lap_hr_tens, lap_hr_ones, lap_min_tens, lap_min_ones   // lap time storage
);

  reg [2:0] cur_state, next_state;

  // FSM states
  parameter IDLE_STATE  = 3'b000;
  parameter RUN_STATE   = 3'b001;
  parameter LAP_STATE   = 3'b010;
  parameter STOP_STATE  = 3'b011;
  parameter CLEAR_STATE = 3'b100;

  initial begin
    cur_state = IDLE_STATE; next_state = IDLE_STATE;
    FSM_state = IDLE_STATE;
    cnt_hr_tens = 0; cnt_hr_ones = 0; cnt_min_tens = 0; cnt_min_ones = 0;
    lap_hr_tens = 0; lap_hr_ones = 0; lap_min_tens = 0; lap_min_ones = 0;
  end

  // FSM state register
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cur_state <= IDLE_STATE;
    else        cur_state <= next_state;
  end

  // FSM next-state logic
  always @(*) begin
    next_state = cur_state;
    case (cur_state)
      IDLE_STATE:  next_state = (start) ? RUN_STATE : IDLE_STATE;
      RUN_STATE:   if(lap) next_state = LAP_STATE; else if(stop) next_state = STOP_STATE; else if(clr) next_state = CLEAR_STATE;
      LAP_STATE:   if(start) next_state = RUN_STATE; else if(stop) next_state = STOP_STATE; else if(clr) next_state = CLEAR_STATE;
      STOP_STATE:  if(start) next_state = RUN_STATE; else if(lap) next_state = LAP_STATE; else if(clr) next_state = CLEAR_STATE;
      CLEAR_STATE: if(start) next_state = RUN_STATE; else if(lap) next_state = LAP_STATE; else if(stop) next_state = STOP_STATE; else next_state = RUN_STATE;
    endcase
  end

  // Counter + Lap logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_hr_tens <= 0; cnt_hr_ones <= 0; cnt_min_tens <= 0; cnt_min_ones <= 0;
      lap_hr_tens <= 0; lap_hr_ones <= 0; lap_min_tens <= 0; lap_min_ones <= 0;
      FSM_state   <= IDLE_STATE;
    end else begin
      FSM_state <= cur_state;
      case (cur_state)
        IDLE_STATE: begin
          cnt_hr_tens <= 0; cnt_hr_ones <= 0; cnt_min_tens <= 0; cnt_min_ones <= 0;
        end
        RUN_STATE: begin
          if (load)
            {cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones} <= {load_hr_tens, load_hr_ones, load_min_tens, load_min_ones};
          else
            {cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones} <= 
              bcd_increment({cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones});
        end
        LAP_STATE: begin
          lap_hr_tens <= cnt_hr_tens; lap_hr_ones <= cnt_hr_ones;
          lap_min_tens <= cnt_min_tens; lap_min_ones <= cnt_min_ones;
          {cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones} <= 
              bcd_increment({cnt_hr_tens, cnt_hr_ones, cnt_min_tens, cnt_min_ones});
        end
        STOP_STATE: begin end
        CLEAR_STATE: begin
          cnt_hr_tens <= 0; cnt_hr_ones <= 0; cnt_min_tens <= 0; cnt_min_ones <= 0;
        end
      endcase
    end
  end

  // BCD increment function
  function [15:0] bcd_increment(input [15:0] tmr_cur);
    reg [3:0] hr_tens, hr_ones, min_tens, min_ones;
    begin
      {hr_tens, hr_ones, min_tens, min_ones} = tmr_cur;

      if (hr_tens==2 && hr_ones==3 && min_tens==5 && min_ones==9)
        {hr_tens, hr_ones, min_tens, min_ones} = 16'd0;
      else if (min_tens==5 && min_ones==9) begin
        min_tens=0; min_ones=0;
        if (hr_ones==9) begin hr_ones=0; hr_tens=(hr_tens==2)?0:hr_tens+1; end
        else hr_ones=(hr_tens==2 && hr_ones==3)?0:hr_ones+1;
      end
      else if (min_ones==9) begin min_ones=0; min_tens=min_tens+1; end
      else min_ones=min_ones+1;

      bcd_increment = {hr_tens, hr_ones, min_tens, min_ones};
    end
  endfunction
endmodule

// 7-seg decoder (common anode)
module seg7_decoder(
  input wire [3:0] bcd, 
  output reg [6:0] seg
);
  always @(*) begin
    case (bcd)
      4'd0: seg = 7'b0000001; 
      4'd1: seg = 7'b1001111;
      4'd2: seg = 7'b0010010; 
      4'd3: seg = 7'b0000110;
      4'd4: seg = 7'b1001100;
      4'd5: seg = 7'b0100100;
      4'd6: seg = 7'b0100000;
      4'd7: seg = 7'b0001111;
      4'd8: seg = 7'b0000000;
      4'd9: seg = 7'b0000100;
      default: seg=7'b1111111;
    endcase
  end
endmodule

/*
// 7-seg decoder (common cathode)
module seg7_decoder(
  input wire [3:0] bcd, 
  output reg [6:0] seg
);
  always @(*) begin
    case (bcd)
      4'd0: seg=7'b1111110; 
      4'd1: seg=7'b0110000; 
      4'd2: seg=7'b1101101;
      4'd3: seg=7'b1111001; 
      4'd4: seg=7'b0110011; 
      4'd5: seg=7'b1011011;
      4'd6: seg=7'b1011111; 
      4'd7: seg=7'b1110000; 
      4'd8: seg=7'b1111111;
      4'd9: seg=7'b1111011; 
      default: seg=7'b000000;
    endcase
  end
endmodule
*/
