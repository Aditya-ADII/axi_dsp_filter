import os

print("--- Compiling AXI DSP Filter... ---")
# ADDED -g2012 flag here:
os.system("iverilog -g2012 -o dsp_sim.out rtl.sv tb.sv")

print("--- Running Simulation... ---")
os.system("vvp dsp_sim.out")