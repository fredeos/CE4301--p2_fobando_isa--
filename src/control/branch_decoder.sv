module branch_decode (
    input  logic [4:0] opcode,
    input  logic [3:0] func4,
    output logic [3:0] Branch
);

// --- Logica combinacional ---
always_comb begin
    // 1. Decoficador para tipos de condiciones de salto
    // instrucciones Tipo B:
    case (func4)
        4'b0001: begin // BEQ
            
        end

        4'b0010: begin // BNE
            
        end

        4'b0011: begin // BGT
            
        end

        4'b0100: begin // BLT
            
        end

        4'b0101: begin // BGE
            
        end

        4'b0110: begin // BLE
            
        end

        default: begin // incondicional
            
        end
    endcase
end

endmodule