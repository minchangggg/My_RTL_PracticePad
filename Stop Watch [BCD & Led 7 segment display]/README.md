# STOPWATCH
## Overview
* The **Digital Stopwatch** is implemented in Verilog HDL, providing accurate timekeeping and intuitive interaction via a **7-segment LED display**.
* Operation is managed by a **5-state FSM**: IDLE, RUN, LAP, STOP, CLEAR.
* Supports **start, stop, lap, and clear** controls with smooth transitions between states.
* Time is stored in **BCD format (hh\:mm)**, automatically rolling over at `23:59 → 00:00`.
* **Lap mode** captures split times while the main counter continues to run.
* **Clear mode** resets all values, preparing for a new session.
* Provides **real-time feedback** on both count and lap values through the LED display.

To simplify verification and development, the project is split into two parts:

* **Part 1 – BCD_stopwatch_test (Vivado simulation):** Includes the full FSM and counting logic, with outputs shown directly in BCD decimal format. This makes functional testing and debugging easier in simulation.
* **Part 2 – Led7Seg_stopwatch_test (Quartus implementation):** Builds on Part 1 by adding 7-segment LED decoding, while keeping the same FSM and counter structure. Synthesized and tested on FPGA hardware using Quartus, it provides a complete stopwatch system with user-friendly display.

