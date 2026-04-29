module secure_memory #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 3,
    parameter int DEPTH      = 1 << ADDR_WIDTH
)(
    input  logic clk,   // Reloj del sistema
    input  logic rst_n, // Reset activo en bajo
    input  logic we,    // Enable de escritura

    input  logic [ADDR_WIDTH-1:0] ra1, // Dirección de lectura 1
    input  logic [ADDR_WIDTH-1:0] ra2, // Dirección de lectura 2
    input  logic [ADDR_WIDTH-1:0] ra3, // Dirección de lectura 3
    input  logic [ADDR_WIDTH-1:0] wa,  // Dirección de escritura

    input  logic [DATA_WIDTH-1:0] wd,  // Dato de escritura

    output logic [DATA_WIDTH-1:0] rd1, // Dato leído 1
    output logic [DATA_WIDTH-1:0] rd2, // Dato leído 2
    output logic [DATA_WIDTH-1:0] rd3  // Dato leído 3
);

    localparam logic [ADDR_WIDTH-1:0] AX_REG = '0;

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1]; // Registros seguros
    integer i;                              // Índice de reset

    // --- Logica secuencial (escritura) ---
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            // Limpia la memoria segura
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= '0;
            end
        end else if (we && (wa != AX_REG)) begin
            // Escribe dato seguro
            mem[wa] <= wd;
        end
    end

    // --- Logica combinacional (lectura) ---
    always_comb begin
        // Lectura write-first
        rd1 = (ra1 == AX_REG) ? '0 : ((we && (wa == ra1)) ? wd : mem[ra1]);
        rd2 = (ra2 == AX_REG) ? '0 : ((we && (wa == ra2)) ? wd : mem[ra2]);
        rd3 = (ra3 == AX_REG) ? '0 : ((we && (wa == ra3)) ? wd : mem[ra3]);
    end

endmodule
