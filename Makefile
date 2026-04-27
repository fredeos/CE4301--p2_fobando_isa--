build_secure_memory:
	mkdir -p ./output
	iverilog -g2012 -o ./output/secure_memory.out ./src/secure_memory/secure_memory.sv ./src/secure_memory/tb_secure_memory.sv

run_secure_memory:
	vvp ./output/secure_memory.out
	gtkwave ./output/wave.vcd

build_top:
	mkdir -p ./output
	iverilog -g2012 -o ./output/top.out ./src/top.sv ./src/tb_top.sv

run_top:
	vvp ./output/top.out
	gtkwave ./output/wave.vcd

clean:
	rm -f ./output/*