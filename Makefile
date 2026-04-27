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
	rm -f ./output/*
# --- Directorios de unidades de control ---
dirCONTROL = ./src/control
dirCONTROLtb = ${dirCONTROL}/tests

control_unit = ${dirCONTROL}/control_unit.sv ${dirCONTROL}/branch_decoder.sv ${dirCONTROL}/main_decoder.sv ${dirCONTROL}/alu_decoder.sv # unidad de control
admin_unit = ${dirCONTROL}/admin_unit.sv ${dirCONTROL}/cycle_comparer.sv	# unidad de administrador (sessiones de hardware seguro)
cond_unit = ${dirCONTROL}/cond_unit.sv	# unidad de condicionales y saltos (cambios al PC)
ssu = ${dirCONTROL}/ssu.sv				# unidad de seleccion segura (instrucciones @)
# --- Makefile ---

build:
	iverilog -g2012 -o ./src/output/sim.out ./src/instruction_memory/instruction_memory.sv ./src/instruction_memory/instruction_memory_tb.sv

ControlUnit:
	iverilog -g2012 -o ./output/sim.out ${control_unit} ${dirCONTROLtb}/tb_control_unit.sv

CondUnit:
	iverilog -g2012 -o ./output/sim.out ${cond_unit} ${dirCONTROLtb}/tb_cond_unit.sv

AdminUnit:
	iverilog -g2012 -o ./output/sim.out ${admin_unit} ${dirCONTROLtb}/tb_admin_unit.sv

SSU:
	iverilog -g2012 -o ./output/sim.out ${ssu} ${dirCONTROLtb}/tb_ssu.sv
run:
	vvp ./src/output/sim.out
	gtkwave ./src/output/instruction_memory_tb.vcd

clean:
	rm ./output/*.out ./output/*.vcd
