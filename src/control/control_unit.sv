module control_unit (
    input  logic  [4:0] opcode,
    input  logic  [3:0] func4,
    input  logic  [21:0] source,
    // Señales de control de salida en WB
    output logic  [1:0] MemToReg,
    // Señales de control de escritura en WB
    output logic  [1:0] RegWrite, // write enable = [0]: secure memory, [1]: register file
    // Señales de control en MEM
    output logic  [1:0] MemWrite, // write enable = [0]: vault, [1]: data memory
    output logic  [7:0] MemBytes, // seleccion de bytes para lectura o escritura = [3:0] vault, [7:4] data memory
    // Señales de control saltos y branch
    output logic        JalSel,   // seleccion de PC+4 para instrucciones J
    output logic  [4:0] Branch,   // condiciones de salto para instrucciones J, B
    // Señales de control de session
    output logic  [1:0] Session,  // [0]: login, [1]: logout (quit)
    // Señales de control para EX
    output logic        ALUOut,    // salida de ALU (pALU | sALU)
    output logic  [4:0] ALUControl,// operaciones de ALU = [3:0]: pALU, [4]: sALU
    output logic        ALUSrcB,   // selección de operando B para pALU
    output logic  [1:0] ALUSrcA,   // selección de operando A para pALU
    // Señales de control para ID
    output logic  [1:0] RSel,     // selección de registros = [0]: (rn | sn), [1]: ((rm | rd) | (sm | sd))
    output logic  [2:0] ImmSel,   // selección de extensión de inmediatos
    output logic        RegSrc,   // selección de registro 2 (rm | rd)
    output logic        SecSrc    // seleccion de registro 2 (sm | sd)
);
    // Senales internas de la unidad de control
    logic [4:0] rd, rn, rm;
    logic [2:0] sd, sn, sm, sf, func3;
    logic [6:0] func7;

    assign rd = source[4:0];
    assign rn = source[9:5];
    assign rm = source[14:10];
    
    assign sd = source[2:0];
    assign sn = source[5:3];
    assign sm = source[8:6];
    assign sf = source[11:9];
    assign func3 = source[14:12];

    assign func7 = source[21:15];

    // Instanciar decodificadores de control

endmodule