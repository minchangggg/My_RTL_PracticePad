## Part 1 – BCD_stopwatch_test
Includes the full FSM and counting logic, with outputs shown directly in BCD decimal format. This makes functional testing and debugging easier in simulation.
### EDA Playground Simulation 
> BCD_stopwatch_test: https://edaplayground.com/x/VZpP

            # run -all
            # t=0 | state=0 | cnt = 0 0: 0 0 | lap = 0 0: 0 0
            # === RESET release ===
            # === START stopwatch ===
            # t=55000 | state=1 | cnt = 0 0: 0 1 | lap = 0 0: 0 0
            # t=65000 | state=1 | cnt = 0 0: 0 2 | lap = 0 0: 0 0
            # t=75000 | state=1 | cnt = 0 0: 0 3 | lap = 0 0: 0 0
            # t=85000 | state=1 | cnt = 0 0: 0 4 | lap = 0 0: 0 0
            # t=95000 | state=1 | cnt = 0 0: 0 5 | lap = 0 0: 0 0
            # t=105000 | state=1 | cnt = 0 0: 0 6 | lap = 0 0: 0 0
            # t=115000 | state=1 | cnt = 0 0: 0 7 | lap = 0 0: 0 0
            # === LAP triggered ===
            # t=125000 | state=2 | cnt = 0 0: 0 8 | lap = 0 0: 0 7
            # t=135000 | state=1 | cnt = 0 0: 0 9 | lap = 0 0: 0 7
            # t=145000 | state=1 | cnt = 0 0: 1 0 | lap = 0 0: 0 7
            # t=155000 | state=1 | cnt = 0 0: 1 1 | lap = 0 0: 0 7
            # t=165000 | state=1 | cnt = 0 0: 1 2 | lap = 0 0: 0 7
            # t=175000 | state=1 | cnt = 0 0: 1 3 | lap = 0 0: 0 7
            # t=185000 | state=1 | cnt = 0 0: 1 4 | lap = 0 0: 0 7
            # === STOP stopwatch ===
            # t=195000 | state=3 | cnt = 0 0: 1 4 | lap = 0 0: 0 7
            # === START again ===
            # t=265000 | state=1 | cnt = 0 0: 1 5 | lap = 0 0: 0 7
            # t=275000 | state=1 | cnt = 0 0: 1 6 | lap = 0 0: 0 7
            # t=285000 | state=1 | cnt = 0 0: 1 7 | lap = 0 0: 0 7
            # t=295000 | state=1 | cnt = 0 0: 1 8 | lap = 0 0: 0 7
            # t=305000 | state=1 | cnt = 0 0: 1 9 | lap = 0 0: 0 7
            # t=315000 | state=1 | cnt = 0 0: 2 0 | lap = 0 0: 0 7
            # t=325000 | state=1 | cnt = 0 0: 2 1 | lap = 0 0: 0 7
            # === CLEAR stopwatch ===
            # t=335000 | state=4 | cnt = 0 0: 0 0 | lap = 0 0: 0 7
            # t=345000 | state=1 | cnt = 0 0: 0 1 | lap = 0 0: 0 7
            # t=355000 | state=1 | cnt = 0 0: 0 2 | lap = 0 0: 0 7
            # t=365000 | state=1 | cnt = 0 0: 0 3 | lap = 0 0: 0 7
            # t=375000 | state=1 | cnt = 0 0: 0 4 | lap = 0 0: 0 7
            # t=385000 | state=1 | cnt = 0 0: 0 5 | lap = 0 0: 0 7
            # t=395000 | state=1 | cnt = 1 2: 5 8 | lap = 0 0: 0 7
            # === LOAD value 12:58 ===
            # t=405000 | state=1 | cnt = 1 2: 5 9 | lap = 0 0: 0 7
            # t=415000 | state=1 | cnt = 1 3: 0 0 | lap = 0 0: 0 7
            # t=425000 | state=1 | cnt = 1 3: 0 1 | lap = 0 0: 0 7
            # t=435000 | state=1 | cnt = 1 3: 0 2 | lap = 0 0: 0 7
            # t=445000 | state=1 | cnt = 1 3: 0 3 | lap = 0 0: 0 7
            # === SIMULATION END ===
            # ** Note: $finish    : testbench.sv(96)
            #    Time: 450 ns  Iteration: 0  Instance: /tb_bcd_stopwatch
            # End time: 04:57:25 on Sep 06,2025, Elapsed time: 0:00:01
            # Errors: 0, Warnings: 0
            End time: 04:57:25 on Sep 06,2025, Elapsed time: 0:00:02
            *** Summary *********************************************
                qrun: Errors:   0, Warnings:   0
                vlog: Errors:   0, Warnings:   0
                vopt: Errors:   0, Warnings:   1
                vsim: Errors:   0, Warnings:   0
              Totals: Errors:   0, Warnings:   1

### Vivado Simulation 
<img width="1914" height="1015" alt="image" src="https://github.com/user-attachments/assets/27fd3f06-af4f-4aeb-966a-5653694ec193" />

<img width="1916" height="1014" alt="image" src="https://github.com/user-attachments/assets/12e15af9-cfe0-46e3-aa81-46ff21a1ab17" />
