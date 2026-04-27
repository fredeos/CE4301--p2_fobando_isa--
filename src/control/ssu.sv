module ssu (
    input  logic       login, P,
    input  logic [4:0] opcode,
    output logic       ignore
);

// --- Logica combinacional ---
always_comb begin
    // 1. Decodificar tipo de instruccion
    case (opcode)
        5'b00010: begin // Tipo PR: instrucciones aritmeticas o logicas protegidas registro-registro
            ignore = login;
        end

        5'b00011: begin // Tipo PI: instrucciones aritmeticas o logicas protegidas registro-inmediato
            ignore = login;
        end

        5'b00110: begin // Tipo V: lectura de boveda
            ignore = login;
        end

        5'b00111: begin // Tipo V: escritura a boveda
            ignore = login;
        end

        5'b10000: begin // Tipo T: instrucciones de traslado de datos entre banco de registros y banco seguro
            ignore = login;
        end
        
        default: begin
            ignore = ~(P & ~login);
        end
    endcase
end

endmodule