module control_unit (
    input  logic  [4:0] opcode,
    input  logic  [3:0] func4,
    input  logic [21:0] source,
    output logic  [1:0] MemToReg,
    output logic  [1:0] RegWrite,
    output logic  [1:0] MemWrite,
    output logic        BranchSel,
    output logic  [3:0] Branch,
    output logic  [1:0] Session,
    output logic        ALUOut,
    output logic  [4:0] ALUControl,
    output logic        ALUSrcB,
    output logic  [1:0] ALUSrcA,
    output logic  [1:0] RSel,
    output logic  [2:0] ImmSel,
    output logic        RegSrc,
    output logic        SecSrc
);
    // Senales internas de la unidad de control
    logic [28:0] control; // un buffer grande para la decodificacion de cada senal de control

    // --- Logica combinacionl ---
    // Revisar isa.md para comprender la encodifcacion para cada instruccion
    always_comb begin
        // 1. Decodificar segun el tipo de instruccion (opcode)
        case (opcode)
            5'b00000: begin // Tipo R: instrucciones aritmeticas o logicas registro-registro
                
            end

            5'b00001: begin // Tipo I: instrucciones aritmeticas o logicas registro-inmediato

            end

            5'b00010: begin // Tipo PR: instrucciones aritmeticas o logicas protegidas registro-registro

            end

            5'b00011: begin // Tipo PI: instrucciones aritmeticas o logicas protegidas registro-inmediato

            end

            5'b00100: begin // Tipo M: instrucciones de memoria

            end

            5'b00101: begin // Tipo V: instrucciones de acceso a boveda

            end

            5'b00110: begin // Tipo T: instrucciones de traslado de datos entre banco de registros y banco seguro

            end

            5'b01000: begin // Tipo B: instrucciones control de flujo(branches)

            end

            5'b01001: begin // Tipo F/J: instrucciones control de flujo(saltos largos relativos al PC)

            end

            default: begin
                control = 29'b00_00_00_0_0000_00_0_00000_000_00_000_00;
            end
        endcase

    end

endmodule