build:
	mkdir -p ./output
	iverilog -g2012 -o ./output/sim.out ./src/top.sv ./src/tb_top.sv

run:
	vvp ./output/sim.out
	gtkwave ./output/wave.vcd

build_regfile:
	mkdir -p ./output
	iverilog -g2012 -o ./output/regfile.out ./src/register_file/register_file.sv ./src/register_file/tb_register_file.sv

run_regfile:
	vvp ./output/regfile.out
	gtkwave ./output/wave.vcd

clean:
	rm -f ./output/*