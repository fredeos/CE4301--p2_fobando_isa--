module register_file #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 5,
    parameter int DEPTH      = 1 << ADDR_WIDTH
)(
    input  logic clk,   // Reloj del sistema
    input  logic reset, // Reset síncrono
    input  logic we,    // Enable de escritura

    input  logic [ADDR_WIDTH-1:0] ra1,   // Dirección de lectura 1
    input  logic [ADDR_WIDTH-1:0] ra2,   // Dirección de lectura 2
    input  logic [ADDR_WIDTH-1:0] wa,    // Dirección de escritura

    input  logic [DATA_WIDTH-1:0] wd,    // Dato de escritura
    input  logic [DATA_WIDTH-1:0] pc_in, // Valor actual del PC

    output logic [DATA_WIDTH-1:0] rd1,   // Dato leído 1
    output logic [DATA_WIDTH-1:0] rd2,   // Dato leído 2
    output logic [DATA_WIDTH-1:0] pc_out // Salida del PC
);

    logic [DATA_WIDTH-1:0] regfile_mem [0:DEPTH-1]; // Banco de registros
    integer i;                                      // Índice de reset

    localparam logic [DATA_WIDTH-1:0] DELTA_CONST   = 32'h9E3779B9; // Constante TEA
    localparam logic [DATA_WIDTH-1:0] GABRIEL_CONST = 32'hFFFFFFFF; // Constante fija

    always_ff @(posedge clk) begin
        if (reset) begin
            // Limpia todos los registros internos
            for (i = 0; i < DEPTH; i = i + 1) begin
                regfile_mem[i] <= '0;
            end
        end
        else if (we) begin
            // Bloquea escritura en registros especiales
            if ((wa != 5'd0) &&
                (wa != 5'd3) &&
                (wa != 5'd30) &&
                (wa != 5'd31)) begin
                regfile_mem[wa] <= wd;
            end
        end
    end

    always_comb begin
        // Lectura del primer operando
        unique case (ra1)
            5'd0:  rd1 = 32'h00000000;  // gabo
            5'd3:  rd1 = pc_in;         // pc
            5'd30: rd1 = DELTA_CONST;   // delta
            5'd31: rd1 = GABRIEL_CONST; // gabriel
            default: rd1 = regfile_mem[ra1];
        endcase

        // Lectura del segundo operando
        unique case (ra2)
            5'd0:  rd2 = 32'h00000000;  // gabo
            5'd3:  rd2 = pc_in;         // pc
            5'd30: rd2 = DELTA_CONST;   // delta
            5'd31: rd2 = GABRIEL_CONST; // gabriel
            default: rd2 = regfile_mem[ra2];
        endcase
    end

    assign pc_out = pc_in; // Refleja el PC externo

endmodule