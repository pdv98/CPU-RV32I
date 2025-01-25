/************************************************************************************************

[ALUop]

2'b00:
op[5]=0: I-type (LB, LH, LW, LBU, LHU)
op[5]=1: S-type (SB, SH, SW)

2'b01:
B-type (BEQ, BNE, BLT, BGE, BLTU, BGEU)

2'b10:
op[5]=0: I-type (ADDI,          XORI,   ORI,    ANDI,   SLLI,   SRLI,   SRAI,   SLTI,   SLTIU)
op[5]=1: R-type (ADD,    SUB,   XOR,    OR,     AND,    SLL,    SRL,    SRA,    SLT,    SLTU)

************************************************************************************************/

module ALUctrl (
    input  wire [1:0] ALUop_i,
    input  wire [2:0] func3_i,
    input  wire       func7_i,      // func7[5]
    input  wire       opcode_i,     // opcode[5]
    output reg  [3:0] ALUctrl_o 
    );

    always @(*)
    begin
        casex(ALUop_i)
            2'b00:  // Load, Store 
            begin 
                casex({opcode_i, func3_i})
                    4'b0_000: ALUctrl_o = 4'h0;  // LB
                    4'b0_001: ALUctrl_o = 4'h0;  // LH
                    4'b0_010: ALUctrl_o = 4'h0;  // LW
                    4'b0_100: ALUctrl_o = 4'h0;  // LBU
                    4'b0_101: ALUctrl_o = 4'h0;  // LHU

                    4'b1_000: ALUctrl_o = 4'h0;  // SB
                    4'b1_001: ALUctrl_o = 4'h0;  // SH
                    4'b1_010: ALUctrl_o = 4'h0;  // SW
                    default:  ALUctrl_o = 4'bxxxx;  // Invalid
                endcase
            end

            2'b01:  // B-type
            begin 
                casex(func3_i)
                    3'b000: ALUctrl_o = 4'hA;  // BEQ 
                    3'b001: ALUctrl_o = 4'hB;  // BNE 
                    3'b100: ALUctrl_o = 4'hC;  // BLT 
                    3'b101: ALUctrl_o = 4'hD;  // BGE 
                    3'b110: ALUctrl_o = 4'hE;  // BLTU
                    3'b111: ALUctrl_o = 4'hF;  // BGEU
                    default: ALUctrl_o = 4'bxxxx;   // Invalid
                endcase
            end

            2'b10:  // R-type, I-type
            begin 
                casex({opcode_i, func3_i, func7_i})
                    5'b1_000_0: ALUctrl_o = 4'h0;  // ADD
                    5'b1_000_1: ALUctrl_o = 4'h1;  // SUB *
                    5'b1_100_0: ALUctrl_o = 4'h2;  // XOR
                    5'b1_110_0: ALUctrl_o = 4'h3;  // OR
                    5'b1_111_0: ALUctrl_o = 4'h4;  // AND
                    5'b1_001_0: ALUctrl_o = 4'h5;  // SLL
                    5'b1_101_0: ALUctrl_o = 4'h6;  // SRL
                    5'b1_101_1: ALUctrl_o = 4'h7;  // SRA *
                    5'b1_010_0: ALUctrl_o = 4'h8;  // SLT
                    5'b1_011_0: ALUctrl_o = 4'h9;  // SLIU

                    5'b0_000_x: ALUctrl_o = 4'h0;  // ADDI
                    5'b0_100_x: ALUctrl_o = 4'h2;  // XORI 
                    5'b0_110_x: ALUctrl_o = 4'h3;  // ORI  
                    5'b0_111_x: ALUctrl_o = 4'h4;  // ANDI 
                    5'b0_001_0: ALUctrl_o = 4'h5;  // SLLI 
                    5'b0_101_0: ALUctrl_o = 4'h6;  // SRLI 
                    5'b0_101_1: ALUctrl_o = 4'h7;  // SRAI *
                    5'b0_010_x: ALUctrl_o = 4'h8;  // SLTI 
                    5'b0_011_x: ALUctrl_o = 4'h9;  // SLTIU
                    default: ALUctrl_o = 4'bxxxx; // Invalid
                endcase
            end

            default: ALUctrl_o = 4'bxxxx; // Invalid ALUop_i
        endcase
    end

endmodule