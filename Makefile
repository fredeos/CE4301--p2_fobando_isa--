build_hazard:
	mkdir -p ./output
	iverilog -g2012 -o ./output/hazard_tb.out ./src/hazard_unit/hazard_unit.sv ./src/hazard_unit/tb_hazard_unit.sv

run_hazard:
	vvp ./output/hazard_tb.out
	gtkwave ./output/wave.vcd

build_top:
	mkdir -p ./output
	iverilog -g2012 -o ./output/sim.out ./src/top.sv ./src/tb_top.sv

run_top:
	vvp ./output/sim.out
	gtkwave ./output/wave.vcd

clean:
	rm -f ./output/*.out ./output/*.vcd