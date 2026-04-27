# --- Makefile ---

build:
	iverilog -g2012 -o ./src/output/sim.out ./src/data_memory/data_memory.sv ./src/data_memory/data_memory_tb.sv

run:
	vvp ./src/output/sim.out
	gtkwave ./src/output/data_memory_tb.vcd

clean:
	rm -rf ./src/output/*