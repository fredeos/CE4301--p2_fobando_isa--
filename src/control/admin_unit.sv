module admin_unit #(parameter width = 32)(
    input  logic clk, rst,
    input  logic logout, signal, login,
    input  logic [width-1:0] tSes, tOut, max,
    output logic session
);

logic val, expired, timeout, valid, sesff_en, sesff_clr, logout_clr;
logic [width-1:0] attempts, inc;

assign val = (logout) ? 1'b1 : signal;
assign inc = {{width-1{1'b0}} , ~val};

// --- Flip-flop para cantidad de intentos ---
always_ff @(posedge clk, posedge rst) begin
    if (rst || timeout) attempts <= 0;
    else if (login) attempts <= attempts + inc;
end

assign valid = (attempts < max);

// 1. Comparador de ciclos para contar tiempo de espera despues de muchos intentos
cycle_comparer #(.width(width)) _timeout (.clk(clk), .en(~valid), .rst(rst), .clr(timeout), .tol(tOut), .state(timeout));

// --- Flip-flop para registro de session ---
always_ff @(posedge clk, posedge rst) begin
    if (rst || sesff_clr) session <= 0;
    else if (sesff_en) session <= val;
end

assign logout_clr = expired | logout;
// 2. Comparador de ciclos para contar tiempo de vida de una sesion con hardware seguro
cycle_comparer #(.width(width)) _logout (.clk(clk), .en(session), .rst(rst), .clr(logout_clr), .tol(tSes), .state(expired));

assign sesff_clr = logout | expired;
assign sesff_en  = login & valid;

endmodule