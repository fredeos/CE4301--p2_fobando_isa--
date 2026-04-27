module vault #(
    parameter int NUM_WORDS = 16  // 16 palabras por defecto
  )(input  logic        CLK,
    input  logic        RST,
    input  logic [31:0] A,    // 32-bit Address from ALUOut
    input  logic [3:0]  WE,   // Write Enable (Byte-strobe)
    input  logic [3:0]  ASM,  // Addressing Selection Mode
    // Data signals
    input  logic [31:0] WD,   // Write Data from RD2
    output logic [31:0] RD);    // Read Data (MemOut)


    // Calculo de los bits de direccionamiento para indexar el array
    localparam int ADDR_WIDTH = $clog2(NUM_WORDS);

    // --- Memory Storage ---
    // [31:0] is the PACKED dimension: defines the 32-bit width of each word (MSB to LSB).
    // [0:NUM_WORDS-1] is the UNPACKED dimension: defines the addressable range.
    // We use [0:N] instead of [N:0] so that the first line of the .hex file 
    // correctly maps to the lowest address (index 0) during $readmemh.
    logic [31:0] RAM [0:NUM_WORDS-1];

    // --- Address Mapping ---
    // Extract the word index using the calculated width
    // We still ignore A[1:0] for word alignment
    logic [ADDR_WIDTH-1:0] word_idx;
    assign word_idx = A[ADDR_WIDTH+1:2];

    // Byte selection within the word
    logic [1:0] byte_offset;
    assign byte_offset = A[1:0];

    // --- Initialization ---
    initial begin
        for (int i = 0; i < NUM_WORDS; i++) begin
            RAM[i] = 32'h0;
        end
        $readmemh("./src/vault/vault_mem.hex", RAM);
    end

    // --- Synchronous Write (Store) ---
    always_ff @(posedge CLK) begin
        if (RST) begin
            // Reset logic
        end else begin
            if (WE[0]) RAM[word_idx][7:0]   <= WD[7:0];
            if (WE[1]) RAM[word_idx][15:8]  <= WD[15:8];
            if (WE[2]) RAM[word_idx][23:16] <= WD[23:16];
            if (WE[3]) RAM[word_idx][31:24] <= WD[31:24];
        end
    end

    // --- Asynchronous Read (Load) ---
    logic [31:0] raw_word;
    assign raw_word = RAM[word_idx];

    always_comb begin
        case(ASM)
            4'b0000: RD = raw_word; // LW
            
            4'b0001: begin // LB / LBU selection
                case(byte_offset)
                    2'b00: RD = {24'b0, raw_word[7:0]};
                    2'b01: RD = {24'b0, raw_word[15:8]};
                    2'b10: RD = {24'b0, raw_word[23:16]};
                    2'b11: RD = {24'b0, raw_word[31:24]};
                endcase
            end
            
            4'b0010: begin // LH / LHU selection
                case(byte_offset[1])
                    1'b0: RD = {16'b0, raw_word[15:0]};
                    1'b1: RD = {16'b0, raw_word[31:16]};
                endcase
            end

            default: RD = raw_word;
        endcase
    end

endmodule


