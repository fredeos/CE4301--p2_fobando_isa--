module tb_datapath ();
    logic clk, rst;

    localparam cycles = 500;
    always #5 clk = ~clk;

    datapath _cpu (
        .clk(clk), 
        .rst(rst)
    );

    initial begin 
        $dumpfile("./output/wave.vcd");
        $dumpvars(0, tb_datapath);
        $display("[Inicio del testbench]");

        // Inicializar el procesdor
        clk = 0;
        rst = 1;
        #5; rst = 0; #5;

        // Ejecutar cantidad de ciclos deseada
        for (int i = 1; i < cycles; i++) begin 
            #10;
            $display("Ciclo [%0d]", i);
        end

        // --- Volcado final de las memorias ---
        $display("\n[SISTEMA] Generando archivos de salida corregidos...");

        $writememh("./output/data_mem_exit.hex", _cpu._ram.RAM);
        $display("[SISTEMA] Archivo para memoria de datos generado exitosamente.");

        $writememh("./output/vault_exit.hex", _cpu._vault.RAM);
        $display("[SISTEMA] Archivo para boveda generado exitosamente.");

        $writememh("./output/regfile_exit.hex", _cpu._register_file.regfile_mem);
        $display("[SISTEMA] Archivo para banco de registros generado exitosamente.");

        $writememh("./output/secmem_exit.hex", _cpu._secure_memory.mem);
        $display("[SISTEMA] Archivo para memoria segura generado exitosamente.");

        $display("[Final del testbench]");
        $finish;
    end
endmodule