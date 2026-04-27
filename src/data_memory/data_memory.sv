module data_memory #(
    parameter int MEM_SIZE_KB = 64  // Default size: 64 KB
)(
    // Global signals
    input  logic        CLK,
    input  logic        RST,
    // Control signals
    input  logic [31:0] A,    // 32-bit Address from ALUOut
    input  logic WE,          // Write Enable (Byte-strobe)
    input  logic [3:0]  ASM,  // Addressing Selection Mode
    // Data signals
    input  logic [31:0] WD,   // Write Data from RD2
    output logic [31:0] RD    // Read Data (MemOut)
);

    // --- Dynamic Parameter Calculation ---
    // 1. Calculate total words: (KB * 1024 bytes) / 4 bytes per word
    localparam int NUM_WORDS = (MEM_SIZE_KB * 1024) / 4;
    
    // 2. Calculate address bits needed for the array index: log2(NUM_WORDS)
    // $clog2 is a system function that computes the ceiling of the log base 2
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
        for (int i = 0; i < NUM_WORDS-1; i++) begin
            RAM[i] = 32'h0;
        end
        $readmemh("./src/memories/data_mem.hex", RAM);
    end

    // --- Synchronous Write (Store) ---
    always_ff @(posedge CLK) begin
        if (RST) begin
            // Reset logic
        end else begin
            if  (WE == 1) begin
                if (ASM[0]) RAM[word_idx][7:0]   <= WD[7:0];
                if (ASM[1]) RAM[word_idx][15:8]  <= WD[15:8];
                if (ASM[2]) RAM[word_idx][23:16] <= WD[23:16];
                if (ASM[3]) RAM[word_idx][31:24] <= WD[31:24];
            end
        end
    end

    // --- Asynchronous Read (Load) ---

    wire bit0 = ASM[0];
    wire bit1 = ASM[1];
    wire bit2 = ASM[2];
    wire bit3 = ASM[3];

    wire RAM_first_word_byte = RAM[word_idx][7:0];
    wire RAM_second_word_byte = RAM[word_idx][15:8];
    wire RAM_third_word_byte = RAM[word_idx][23:16];
    wire RAM_fourth_word_byte = RAM[word_idx][31:24];

    always_comb begin
        RD = 32'b0;
        if (bit0) begin
            RD[7:0] = RAM_first_word_byte;
        end
        if (bit1) begin
            RD[15:8] = RAM_second_word_byte;
        end
        if (bit2) begin
            RD[23:16] = RAM_third_word_byte;
        end
        if (bit3) begin
            RD[31:24] = RAM_fourth_word_byte;
        end

    end

endmodule