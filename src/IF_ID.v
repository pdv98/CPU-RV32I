module IF_ID (
    input wire        nEN,
    input wire        nRST,
    input wire        CLK,
    input wire        CLR,
    input wire [31:0] PC_F,
    input wire [31:0] PC_Plus4F,
    input wire [31:0] Instr_F,
    output reg [31:0] PC_D,
    output reg [31:0] PC_Plus4D,
    output reg [31:0] Instr_D
    );

    always @(posedge CLK)
    begin
        if ((~nRST) | CLR)    // flush
        begin
            PC_D        <= 32'b0;
            PC_Plus4D   <= 32'b0;
            Instr_D     <= 32'b0;
        end
        else
        begin    
            if (~nEN)   // default
            begin
                PC_D        <=  PC_F;
                PC_Plus4D   <=  PC_Plus4F;
                Instr_D     <=  Instr_F;
            end
            else
            begin   // stall
                PC_D        <=  PC_D;
                PC_Plus4D   <=  PC_Plus4D;
                Instr_D     <=  Instr_D;
            end
        end
    end 

endmodule