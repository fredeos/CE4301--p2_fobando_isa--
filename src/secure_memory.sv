module secure_memory #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 3,
    parameter int DEPTH      = 1 << ADDR_WIDTH
)(
    input  logic clk,
    input  logic rst_n,
    input  logic we,

    input  logic [ADDR_WIDTH-1:0] ra1,
    input  logic [ADDR_WIDTH-1:0] ra2,
    input  logic [ADDR_WIDTH-1:0] ra3,
    input  logic [ADDR_WIDTH-1:0] wa,

    input  logic [DATA_WIDTH-1:0] wd,

    output logic [DATA_WIDTH-1:0] rd1,
    output logic [DATA_WIDTH-1:0] rd2,
    output logic [DATA_WIDTH-1:0] rd3
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    integer i;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= '0;
            end
        end else if (we) begin
            mem[wa] <= wd;
        end
    end

    always_comb begin
        rd1 = (we && (wa == ra1)) ? wd : mem[ra1];
        rd2 = (we && (wa == ra2)) ? wd : mem[ra2];
        rd3 = (we && (wa == ra3)) ? wd : mem[ra3];
    end

endmodule