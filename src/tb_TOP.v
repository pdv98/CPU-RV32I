module tb_TOP ();

    reg CLK;
    reg nRST;

    TOP uTOP(
        .CLK(CLK), 
        .nRST(nRST)
    );

    always #10 CLK = ~CLK;

    initial 
    begin
        #10
        nRST = 1'b1;
        CLK = 1'b0;
        #10
        nRST = 1'b0;
        #25
        nRST = 1'b1;
    end
    initial 
    begin
        $dumpvars;
        #10000
        $dumpflush;
        $finish;
    end

endmodule