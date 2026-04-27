module sALU #(parameter WIDTH = 32)
            (input logic [WIDTH-1:0] A, B,
             input logic op, // solo son dos ops
             output logic [WIDTH-1:0] Y);

    /* Decodificacion de operaciones
    0 ADD
    1 OR*/
    logic [WIDTH-1:0] add_res, or_res;

    assign add_res = $signed(A) + $signed(B);
    assign or_res = A | B;

    assign Y = op ? or_res : add_res;

endmodule
