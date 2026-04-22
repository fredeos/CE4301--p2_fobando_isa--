build:
	iverilog -g2012 -o ./output/sim.out ./src/top.sv ./src/tb_top.sv

run:
	vvp ./output/sim.out
	gtkwave ./output/wave.vcd

clean:
	rm ./output/**