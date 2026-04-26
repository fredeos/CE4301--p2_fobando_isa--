# --- Makefile ---

build:
	iverilog -g2012 -o ./src/output/sim.out ./src/instruction_memory/instruction_memory.sv ./src/instruction_memory/instruction_memory_tb.sv

run:
	vvp ./src/output/sim.out
	gtkwave ./src/output/instruction_memory_tb.vcd

clean:
	rm -rf ./src/output/*