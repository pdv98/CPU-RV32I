module PC #(parameter WIDTH = 32)(
    input  wire             CLK, 
    input  wire             nRST,
    input  wire             nEN,
    input  wire [WIDTH-1:0] PCnext,
    output reg  [WIDTH-1:0] PC
    );

    always @(posedge CLK)
    begin
        if (~nRST) 
            PC <= 32'b0;    // reset
        else if (~nEN)
            PC <= PCnext;   // default
        else
            PC <= PC;       // stall
    end

endmodule
