module tb_control_unit ();
    localparam N = 2;
    logic [31:0] instructions [N-1:0];
    logic [31:0] instr;

    logic [7:0] MemBytes;
    logic [4:0] Branch, ALUControl;
    logic [2:0] ImmSel;
    logic [1:0] MemToReg, RegWrite, MemWrite, Session, ALUSrcA, RSel;
    logic JalSel, ALUOut, ALUSrcB, RegSrc, SecSrc;

    logic clk;
    always #5 clk = ~clk;

    control_unit _control_unit (
        .opcode(instr[5:1]),
        .func4(instr[9:6]),
        .source(instr[31:10]),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite), .MemBytes(MemBytes),
        .JalSel(JalSel), .Branch(Branch),
        .Session(Session),
        .ALUOut(ALUOut), .ALUControl(ALUControl), .ALUSrcB(ALUSrcB), .ALUSrcA(ALUSrcA), 
        .RSel(RSel),
        .ImmSel(ImmSel),
        .RegSrc(RegSrc),
        .SecSrc(SecSrc)
    );

    // Testbench
    initial begin 
        $dumpfile("./output/wave.vcd");
        $dumpvars(0, tb_control_unit);

        clk = 0;
        // Configurar instrucciones en la memoria
        instructions[0] = 32'h01181480; // add p0, r2, r3
        instructions[1] = 32'h00000000;

        // Iteracion sobre las instrucciones
        $display("[Inicio del testbench]");
        for (integer i = 0; i < 1; i++) begin
            instr = instructions[i];
            #10;
            $display("-----------------------[INSTR:0x%h]-----------------------", instr);
            $display("MemToReg(WB mux) = %b", MemToReg);
            $display("RegFile WE = %b", RegWrite[1]);
            $display("SecMem WE = %b", RegWrite[0]);
            $display("Data Memory: WE = %b, Bytes = %b", MemWrite[1], MemBytes[7:4]);
            $display("Vault: WE = %b, Bytes = %b", MemWrite[0], MemBytes[3:0]);
            $display("JalSel WB (PC+4 mux) = %b", JalSel);
            $display("Branch: cond = %b, pcmod = %b, binstr = %b", Branch[4:2], Branch[1], Branch[0]);
            $display("Session: login = %b, logout = %b", Session[0], Session[1]);
            $display("ALU selection: %b", ALUOut);
            $display("Primary ALU operation: %b", ALUControl[3:0]);
            $display("Secondary ALU operation: %b", ALUControl[4]);
            $display("ALUSrcA = %b, ALUSrcB = %b", ALUSrcA, ALUSrcB);
            $display("R1Sel = %b, R2Sel = %b", RSel[0], RSel[1]);
            $display("RegSrc (rm/rd swap mux) = %b", RegSrc);
            $display("SecSec (sm/sd swap mux) = %b", SecSrc);
            $display("Imm Ext op = %b", ImmSel);
        end
        $display("[Final del testbench]");
        $finish;
    end

endmodule