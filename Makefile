
DIRCONTROL = ./src/control
CONTROL_U = ${DIRCONTROL}/control_unit.sv ${DIRCONTROL}/branch_decoder.sv ${DIRCONTROL}/main_decoder.sv ${DIRCONTROL}/alu_decoder.sv

build:
	mkdir output
	iverilog -g2012 -o ./output/sim.out ./src/top.sv ./src/tb_top.sv

control_unit:
	iverilog -g2012 -o ./output/sim.out ${CONTROL_U} ${DIRCONTROL}/tb_control_unit.sv

run:
	vvp ./output/sim.out
	gtkwave ./output/wave.vcd

clean:
	rm ./output/**