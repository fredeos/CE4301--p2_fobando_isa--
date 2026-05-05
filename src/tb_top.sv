module tb_top ();
    logic x, y, z;
    top _top (.A(x), .B(y), .C(z));

    initial begin
        $dumpfile("./output/wave.vcd");
        $dumpvars(0, tb_top);
        x = 0; y = 0;
        #10;
        x = 1;
        #10;
        y = 1;
        #10;
        x = 0;
        #10;
        $display("Hello World!");
        $finish;
    end
endmodule