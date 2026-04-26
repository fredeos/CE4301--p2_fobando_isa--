# --- Directorios de unidades de control ---
dirCONTROL = ./src/control
dirCONTROLtb = ${dirCONTROL}/tests

control_unit = ${dirCONTROL}/control_unit.sv ${dirCONTROL}/branch_decoder.sv ${dirCONTROL}/main_decoder.sv ${dirCONTROL}/alu_decoder.sv # unidad de control
admin_unit = ${dirCONTROL}/admin_unit.sv ${dirCONTROL}/cycle_comparer.sv	# unidad de administrador (sessiones de hardware seguro)
cond_unit = ${dirCONTROL}/cond_unit.sv	# unidad de condicionales y saltos (cambios al PC)
ssu = ${dirCONTROL}/ssu.sv				# unidad de seleccion segura (instrucciones @)

build:
	iverilog -g2012 -o ./output/sim.out ./src/top.sv ./src/tb_top.sv

ControlUnit:
	iverilog -g2012 -o ./output/sim.out ${control_unit} ${dirCONTROLtb}/tb_control_unit.sv

run:
	vvp ./output/sim.out
	gtkwave ./output/wave.vcd

clean:
	rm ./output/*.out ./output/*.vcd