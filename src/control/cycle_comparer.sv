module cycle_count #(parameter width = 32)(
    input  logic clk, en, rst, clr,
    input  logic [width-1:0] tol,
    output logic state
);

logic [width-1:0] cycles;

always_ff @(posedge clk, posedge rst) begin
    if (rst || clr) cycles <= 0;
    else if (en) cycles <= cycles + 1;
end

assign state = (cycles > tol);

endmodule