module tb_datapath ();

    initial begin 
        $dumpfile("./output/wave.vcd");
        $dumpvars(0, tb_imm_ext);
        $display("[Inicio del testbench]");

        
        
        $display("[Final del testbench]");
        $finish;
    end
endmodule