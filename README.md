# AXI4-Stream Moving Average Filter

## Overview
This project implements a **4-Tap Finite Impulse Response (FIR) Filter** compliant with the **AMBA AXI4-Stream Protocol**. The core is designed for real-time signal processing applications where flow control and backpressure handling are critical.

The filter acts as a noise reduction block, computing the sliding window average of an 8-bit input stream.

## Architecture
### AXI4-Stream Interface
* **Handshake Protocol:** Implements `tvalid` and `tready` logic to manage data flow.
* **Backpressure Handling:** The pipeline automatically stalls if the downstream module deasserts `tready`, ensuring zero data loss during system congestion.



### Datapath Optimization
* **Pipeline:** 4-stage shift register for input samples.
* **Arithmetic:** Division by 4 is implemented via a hardware-efficient **Right Bit-Shift (`>> 2`)**, eliminating the need for complex divider logic and reducing critical path delay.

## Simulation & Verification
The verification environment simulates a noisy input signal and checks for pipeline stability and handshake compliance.

### Tools Used
* **Language:** SystemVerilog (IEEE 1800-2012)
* **Simulator:** Icarus Verilog (`iverilog`)

### How to Run
1.  Ensure **Icarus Verilog** is installed.
2.  Run the automation script:
    ```bash
    python run.py
    ```

## Results
The testbench injects a burst of data, pauses the stream, and verifies the filter settles to the correct average value.

![DSP Filter Simulation Output](results/simulation_pass.png)
*(Fig 1. Console output confirming filter convergence and protocol compliance)*

## File Structure
* `rtl.sv`: Source code for the AXI-Stream filter.
* `tb.sv`: Testbench generating AXI traffic and verifying output.
* `run.py`: Build and run script.
