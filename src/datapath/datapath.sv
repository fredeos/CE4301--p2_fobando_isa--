module datapath ( // Pipeline de 5 etapas para arquitectura RISC: F32IS
    input logic clk, rst
);
    localparam MEM_SIZE_KB = 64;
    // --- Señales para interconexiones de módulos y pipes ---
    // + Valores default
    logic [31:0] nop, password, lifetime, timeout, max;

    assign nop = 32'h00000080; // Valor por defecto para omitir instrucciones
    assign password = 32'h000A9C1F; // Contraseña para accesos al hardware seguro
    assign lifetime = 32'd5000; // tiempo de vida de session segura
    assign timeout = 32'd10000; // tiempo de espera al acceder limit de intenos
    assign max = 32'd4; // limite de intentos para iniciar session segura
    
    // + Señales del pipeline
    logic [31:0] PC, PCplus4, PC_new, PCnext;

    logic [31:0] INSTR, IF_INSTR;

    logic [31:0] ID_INSTR, ID_Imm32, ID_PCplus4;
    logic [31:0] ID_Op1, ID_Op2, ID_RegRD1, ID_RegRD2, ID_SecRD1, ID_SecRD2, ID_SecRD3;
    logic [4:0]  ID_OPCODE, ID_Rd, ID_Rn, ID_Rm, Rm;
    logic [3:0]  ID_FUNC4;
    logic [2:0]  ID_Sd, ID_Sn, ID_Sm, ID_Sf, Sm;

    logic [31:0] EX_INSTR, pALU_Out, sALU_Out, pSrcA, pSrcB, sSrcB, ALU_Out;
    logic [31:0] EX_Op1, EX_Op2, EX_Op3, EX_Imm32, ImmSLL, EX_PCBranch, EX_PCplus4;
    logic [3:0]  EX_ALUFlags;
    logic [4:0]  EX_RWB;

    logic [31:0] MEM_INSTR, MEM_ALUOut, MEM_VaultOut, MEM_MemOut;
    logic [31:0] MEM_PCplus4, MEM_PCBranch, MEM_Op2;
    logic [3:0]  MEM_ALUFlags;
    logic [4:0]  MEM_RWB;
    logic [1:0]  MEM_PCSrc;

    logic [31:0] WB_INSTR, WB_ALUOut, WB_VaultOut, WB_MemOut, WB_PCplus4;
    logic [31:0] WB_DataOut, WB_WriteData;
    logic [4:0]  WB_RWB;
    logic WB_PCSrc;

    // + Señales de control
    logic Login, Ignore;

    logic [1:0] ID_MemToReg, ID_RegWrite, ID_MemWrite, ID_Session, ID_ALUSrcA, ID_RSel;
    logic [7:0] ID_MemBytes;
    logic [4:0] ID_Branch, ID_ALUControl;
    logic [2:0] ID_ImmSel;
    logic ID_JalSel, ID_ALUOut, ID_ALUSrcB, ID_RegSrc, ID_SecSrc;

    logic [1:0] EX_MemToReg, EX_RegWrite, EX_MemWrite, EX_Session, EX_ALUSrcA;
    logic [7:0] EX_MemBytes;
    logic [4:0] EX_Branch, EX_ALUControl;
    logic EX_JalSel, EX_ALUOut, EX_ALUSrcB;

    logic [1:0] MEM_MemToReg, MEM_RegWrite, MEM_MemWrite, MEM_Session;
    logic [7:0] MEM_MemBytes;
    logic [4:0] MEM_Branch;
    logic MEM_JalSel;

    logic [1:0] WB_MemToReg, WB_RegWrite;
    logic WB_JalSel;

    // + Señales de hazard unit

    // --- 0. Selección del PC  ---
    assign PCnext = (WB_PCSrc) ? PC_new : ( (MEM_PCSrc[0]) ? MEM_PCBranch : PCplus4);

    // --- 1. Instruction Fetch (IF) ---
    // >> Flip-Flop para pipe IF
    always_ff @(posedge clk, posedge rst) begin
        if (rst) PC <= 32'b0;
        else PC <= PCnext;
    end

    assign PCplus4 = PC + 32'd4;
    // >> Memoria de instrucciones
    instruction_memory #(.MEM_SIZE_KB(64)) _rom (
        .A(PC),
        .RD(INSTR)
    );

    // >> Secure Selection Unit (SSU)
    ssu _ssu (
        .login(Login), .P(INSTR[0]),
        .opcode(INSTR[5:1]),
        .ignore(Ignore)
    );

    assign IF_INSTR = (Ignore) nop : INSTR;

    // --- 2. Instruction Decode (ID) ---
    // >> Flip-Flop para pipe ID
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin 
            ID_INSTR <= '0;
            ID_PCplus4 <= '0;
        end else begin 
            ID_INSTR <= IF_INSTR;
            ID_PCplus4 <= PCplus4;
        end
    end

    assign ID_OPCODE = ID_INSTR[5:1];
    assign ID_FUNC4  = ID_INSTR[9:6];

    assign ID_Rd = ID_INSTR[14:10];
    assign ID_Rn = ID_INSTR[19:15];
    assign ID_Rm = ID_INSTR[24:20];
    
    assign ID_Sd = ID_INSTR[12:10];
    assign ID_Sn = ID_INSTR[15:13];
    assign ID_Sm = ID_INSTR[18:16];
    assign ID_Sf = ID_INSTR[21:19];
    // >> Unidad de control 
    control_unit _control_unit (
        .opcode(ID_OPCODE),
        .func4(ID_FUNC4),
        .source(ID_INSTR[31:10]),
        .MemToReg(ID_MemToReg),
        .RegWrite(ID_RegWrite),
        .MemWrite(ID_MemWrite), .MemBytes(ID_MemBytes),
        .JalSel(ID_JalSel), .Branch(ID_Branch),
        .Session(ID_Session),
        .ALUOut(ID_ALUOut), .ALUControl(ID_ALUControl), .ALUSrcB(ID_ALUSrcB), .ALUSrcA(ID_ALUSrcA), 
        .RSel(ID_RSel),
        .ImmSel(ID_ImmSel),
        .RegSrc(ID_RegSrc),
        .SecSrc(ID_SecSrc)
    );

    assign Rm = (ID_RegSrc) ? ID_Rd : ID_Rm;
    assign Sm = (ID_SecSrc) ? ID_Sd : ID_Sm;
    // >> Banco seguro de registros (Secure memory)
    secure_memory #(.DATA_WIDTH(32), .ADDR_WIDTH(3)) _secure_memory (
        .clk(clk), .rst_n(~rst),
        .we(WB_RegWrite[0]),
        .ra1(ID_Sn), .ra2(Sm), .ra3(ID_Sf),
        .wa(WB_RWB[2:0]),
        .wd(WB_WriteData),
        .rd1(ID_SecRD1), .rd2(ID_SecRD2), .rd3(ID_SecRD3)
    );

    // >> Banco de registros (Register File)
    register_file #(.DATA_WIDTH(32), .ADDR_WIDTH(5)) _register_file (
        .clk(clk), .reset(rst),
        .we(WB_RegWrite[1]),
        .ra1(ID_Rn), .ra2(Rm),
        .wa(WB_RWB),
        .wd(WB_WriteData),
        .pc_in(ID_PCplus4), .lr_in({ 31'b0, Login}),
        .rd1(ID_RegRD1), .rd2(ID_RegRD2),
        .pc_out(PC_new)
    );

    assign ID_Op1 = (ID_RSel[0]) ID_RegRD1 : ID_SecRD1;
    assign ID_Op2 = (ID_RSel[1]) ID_RegRD2 : ID_SecRD2;
    // >> Unidad de extension de inmediatos
    imm_ext32 _imm_ext (
        .source(ID_INSTR[31:6]),
        .sel(ID_ImmSel),
        .ext(ID_Imm32)
    );

    // --- 3. Execute (EX) ---
    // >> Flip-Flop para pipe EX
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin 
            EX_INSTR <= '0;
            EX_PCplus4 <= '0;
            EX_Op1 <= '0;
            EX_Op2 <= '0;
            EX_Op3 <= '0;
            EX_Imm32 <= '0;
            EX_RWB <= '0;

            EX_ALUControl <= '0;
            EX_ALUSrcA <= '0;
            EX_ALUSrcB <= '0;
            EX_ALUOut <=  '0;
            EX_Session <= '0;
            EX_Branch <= '0;
            EX_JalSel <= '0;
            EX_MemWrite <= '0;
            EX_MemBytes <= '0;
            EX_RegWrite <= '0;
            EX_MemToReg <= '0;
        end else begin 
            EX_INSTR <= ID_INSTR;
            EX_PCplus4 <= ID_PCplus4;
            EX_Op1 <= ID_Op1;
            EX_Op2 <= ID_Op2;
            EX_Op3 <= ID_SecRD3;
            EX_Imm32 <= ID_Imm32;
            EX_RWB <= ID_Rd;

            EX_ALUControl <= ID_ALUControl;
            EX_ALUSrcA <= ID_ALUSrcA;
            EX_ALUSrcB <= ID_ALUSrcB;
            EX_ALUOut <= ID_ALUOut;
            EX_Session <= ID_Session;
            EX_Branch <= ID_Branch;
            EX_JalSel <= ID_JalSel;
            EX_MemWrite <= ID_MemWrite;
            EX_MemBytes <= ID_MemBytes;
            EX_RegWrite <= ID_RegWrite;
            EX_MemToReg <= ID_MemToReg;
        end
    end

    // >> ALU primaria
    pALU #(.WIDTH(32)) _pALU (
        .A(pSrcA), .B(pSrcB),
        .op(EX_ALUControl[3:0]),
        .Y(pALU_Out),
        .flags(EX_ALUFlags)
    );

    // >> ALU secundaria
    sALU #(.WIDTH(32)) _sALU (
        .A(pALU_Out), .B(sSrcB),
        .op(EX_ALUControl[4]),
        .Y(sALU_Out)
    );

    assign ALU_Out = (EX_ALUOut) ? pALU_Out : sALU_Out;
    // >> Calculo de saltos
    assign ImmSLL = EX_Imm32 << 2;
    assign EX_PCBranch = EX_PCplus4 + ImmSLL;

    // --- 4. Memory access (MEM) ---
    // >> Flip-Flop para pipe MEM
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin 
            MEM_RWB <= '0;
            MEM_ALUFlags <= '0;
            MEM_ALUOut <= '0;
            MEM_PCplus4 <= '0;
            MEM_PCBranch <= '0;
        
            MEM_Session <= '0;
            MEM_Branch <= '0;
            MEM_JalSel <= '0;
            MEM_MemWrite <= '0;
            MEM_MemBytes <= '0;
            MEM_RegWrite <= '0;
            MEM_MemToReg <= '0;
        end else begin 
            MEM_RWB <= EX_RWB;
            MEM_ALUFlags <= EX_ALUFlags;
            MEM_ALUOut <= ALU_Out;
            MEM_PCplus4 <= EX_PCplus4;
            MEM_PCBranch <= EX_PCBranch;

            MEM_Session <= EX_Session;
            MEM_Branch <= EX_Branch;
            MEM_JalSel <= EX_JalSel;
            MEM_MemWrite <= EX_MemWrite;
            MEM_MemBytes <= EX_MemBytes;
            MEM_RegWrite <= EX_RegWrite;
            MEM_MemToReg <= EX_MemToReg;
        end
    end

    // >> Unidad de administrador
    admin_unit #(.width(32)) _admin_unit (
        .clk(clk), .rst(rst),
        .logout(MEM_Session[1]), .signal(MEM_ALUFlags[3]), .login(MEM_Session[0]),
        .tSes(lifetime), .tOut(timeout), .max(max),
        .session(Login)
    );

    // >> Unidad de condicionales
    cond_unit _cond_unit (
        .Branch(MEM_Branch),
        .flags(MEM_ALUFlags),
        .PCSrc(MEM_PCSrc)
    );


    // >> Boveda (Vault)
    vault #(.NUM_WORDS(16)) _vault (
        .CLK(clk), .RST(rst),
        .A(MEM_ALUOut),
        .WE(MEM_MemWrite[0]),
        .ASM(MEM_MemBytes[3:0]),
        .WD(MEM_Op2),
        .RD(MEM_VaultOut)
    );

    // >> Memoria de datos
    data_memory #(.MEM_SIZE_KB(MEM_SIZE_KB)) _ram (
        .CLK(clk), .RST(rst),
        .A(MEM_ALUOut),
        .WE(MEM_MemWrite[1]),
        .ASM(MEM_MemBytes[7:4]),
        .WD(MEM_Op2),
        .RD(MEM_MemOut)
    );

    // --- 5. Writeback (WB) ---
    // Flip-Flop para pipe WB
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin 
            WB_ALUOut <= '0;
            WB_MemOut <= '0;
            WB_VaultOut <= '0;
            WB_RWB <= '0;
            WB_PCplus4 <= '0;

            WB_PCSrc <= '0;
            WB_MemToReg <= '0;
            WB_RegWrite <= '0;
            WB_JalSel <= '0;
        end else begin 
            WB_ALUOut <= MEM_ALUOut;
            WB_MemOut <= MEM_MemOut;
            WB_VaultOut <= MEM_VaultOut;
            WB_RWB <= MEM_RWB;
            WB_PCplus4 <= MEM_PCplus4;

            WB_PCSrc <= MEM_PCSrc[1];
            WB_MemToReg <= MEM_MemToReg;
            WB_RegWrite <= MEM_RegWrite;
            WB_JalSel <= MEM_JalSel;
        end
    end

    // Seleccionar señales de salida
    assign WB_DataOut = (WB_MemToReg[1]) ? ( (WB_MemToReg[0]) 32'b0 : WB_MemOut) : ( (WB_MemToReg[0]) ? WB_ALUOut : WB_ALUOut);
    assign WB_WriteData = (WB_JalSel) WB_PCplus4 : WB_DataOut;

    // --- 6. Unidad de Riesgos (Hazard Unit) ---
    hazard_unit #(.INSTR_WIDTH(32)) _hazard_unit (
        .IDInstr(ID_INSTR),
        .EXInstr(EX_INSTR),
        .MEMInstr(),
        .WBInstr(),
        .branch_taken(),
        .mem_busy(),
        .wb_busy(),
        .StallIF(), .FlushIF(),
        .StallID(), .FlushID(),
        .FlushEX(),
        .StallMEM(),
        .StallWB(),
        .RD1SrcEX(),
        .RD2SrcEX(),
        .RD3SrcEX()
    );
endmodule