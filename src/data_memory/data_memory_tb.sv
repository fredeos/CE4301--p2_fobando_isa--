`timescale 1ns/1ps

module data_memory_tb();

    parameter MEM_SIZE_KB = 64;
    parameter CLK_PERIOD = 10;

    logic        CLK, RST;
    logic [31:0] A, WD, RD;
    logic [3:0]  WE, ASM;

    data_memory #(.MEM_SIZE_KB(MEM_SIZE_KB)) uut (
        .CLK(CLK), .RST(RST), .A(A), .WE(WE), .ASM(ASM), .WD(WD), .RD(RD)
    );

    always #(CLK_PERIOD/2) CLK = ~CLK;

    initial begin
        // --- 1. Inicialización ---
        CLK = 0; RST = 1; A = 0; WE = 0; ASM = 0; WD = 0;
        #(CLK_PERIOD*5); RST = 0; #(CLK_PERIOD*2);

        $display("\n=== LABORATORIO DE MEMORIA: TEST DE ALINEACION ===");
        
        // --- 2. PRUEBA DE CARGA DE PALABRA (LW) ---
        // Asumiendo que cargaste 04030201 en la dirección 0x0
        A = 32'h00000000; ASM = 4'b0000; 
        #(CLK_PERIOD);
        $display("[LW]  Dir 0x00: %h (Esperado: 04030201)", RD);

        // --- 3. PRUEBA DE BYTES (LB) EN CADENA ---
        $display("\n--- Test de desplazamiento de Bytes (LB) ---");
        for (int i = 0; i < 4; i++) begin
            A = 32'h00000000 + i;
            ASM = 4'b0001; // Modo Byte
            #(CLK_PERIOD);
            $display("[LB]  Dir 0x%0h: %h (Esperado: %02h)", A, RD, i+1);
        end

        // --- 4. PRUEBA DE MEDIAS PALABRAS (LH) ---
        $display("\n--- Test de Medias Palabras (LH) ---");
        // Parte baja (Bytes 0 y 1)
        A = 32'h00000000; ASM = 4'b0010; 
        #(CLK_PERIOD);
        $display("[LH]  Dir 0x00: %h (Esperado: 00000201)", RD);
        
        // Parte alta (Bytes 2 y 3)
        A = 32'h00000002; ASM = 4'b0010; 
        #(CLK_PERIOD);
        $display("[LH]  Dir 0x02: %h (Esperado: 00000403)", RD);

        // --- 5. TEST DE "VANDALISMO" CONTROLADO ---
        $display("\n--- Escribiendo 0xFF en el Byte 2 de 0x00 ---");
        // Queremos que 04030201 pase a ser 04FF0201
        EscribirUnByte(32'h00000002, 8'hFF, 4'b0100); 
        
        A = 32'h00000000; ASM = 4'b0000; // Volver a leer palabra completa
        #(CLK_PERIOD);
        $display("[LW]  Resultado Final: %h (Esperado: 04ff0201)", RD);

        #(CLK_PERIOD*5);

        // --- 6. GUARDAR RESULTADOS ---
        $display("\n[SISTEMA] Guardando volcado de memoria final...");
        // Asegúrate de que la carpeta ./src/output/ exista físicamente
        $writememh("./src/output/bedrock_mod.hex", uut.RAM);
        
        $display("[SISTEMA] Archivo generado exitosamente.");

        $finish;
    end

    // Tarea de escritura reutilizada
    task EscribirUnByte(input [31:0] addr, input [7:0] data, input [3:0] byte_en);
        begin
            @(posedge CLK); #2;
            A = addr; WE = byte_en; WD = {data, data, data, data};
            @(posedge CLK); #2;
            WE = 0;
        end
    endtask

endmodule