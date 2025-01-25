module ALU (
    input wire  [ 3:0] ALU_Ctrl,
    input wire  [31:0] data1_i,
    input wire  [31:0] data2_i,
    output reg  [31:0] result,
    output reg         ALU_Br
    );

    parameter ADD  = 4'h0; // ADDI, Load, Store
    parameter SUB  = 4'h1;
	parameter XOR  = 4'h2; // XORI 
	parameter OR   = 4'h3; // ORI  
	parameter AND  = 4'h4; // ANDI 
    parameter SLL  = 4'h5; // SLLI 
    parameter SRL  = 4'h6; // SRLI 
    parameter SRA  = 4'h7; // SRAI 
    parameter SLT  = 4'h8; // SLTI 
    parameter SLTU = 4'h9; // SLTIU
    parameter BEQ  = 4'hA;
    parameter BNE  = 4'hB;
    parameter BLT  = 4'hC;
    parameter BGE  = 4'hD;
    parameter BLTU = 4'hE;
    parameter BGEU = 4'hF;

    always @(*)
    begin
        case (ALU_Ctrl)
            ADD : result = data1_i + data2_i;
            SUB : result = data1_i - data2_i;
            XOR : result = data1_i ^ data2_i;
            OR  : result = data1_i | data2_i;
            AND : result = data1_i & data2_i;
            SLL : result = data1_i << data2_i[4:0];
            SRL : result = data1_i >> data2_i[4:0];
            SRA : result = $signed(data1_i) >>> data2_i[4:0];
            SLT : result = ($signed(data1_i) < $signed(data2_i)) ? 32'b1 : 32'b0;
            SLTU: result = (data1_i < data2_i) ? 32'b1 : 32'b0;
            default : result = 32'b0;
        endcase
    end

    always @(*) 
    begin
        case (ALU_Ctrl)
            BEQ : ALU_Br =  (data1_i == data2_i);
            BNE : ALU_Br =  (data1_i != data2_i);
            BLT : ALU_Br =  ($signed(data1_i) <  $signed(data2_i));
            BGE : ALU_Br = ~($signed(data1_i) <  $signed(data2_i));
            BLTU: ALU_Br =  (data1_i <  data2_i);
            BGEU: ALU_Br = ~(data1_i <  data2_i);
            default: ALU_Br = 1'b0;
        endcase
    end

endmodule