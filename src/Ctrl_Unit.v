module Ctrl_Unit (
    input  wire [6:0] opcode_i,
    input  wire [2:0] func3_i,
    output reg        RegWrite_o,
    output reg  [1:0] ResultSrc_o,
    output reg  [3:0] MemWrite_o,
    output reg  [3:0] MemRead_o,
    output reg        Jump_o,
    output reg        Jalr_o,
    output reg        Branch_o,
    output reg        ALUsrc_o,
    output reg  [1:0] ALUop_o,
    output reg  [2:0] ImmSrc_o,
    output reg        ImmUI_o
    );
    
    initial
    begin
        RegWrite_o  = 1'b0;
        ResultSrc_o = 2'b0;
        MemWrite_o  = 4'b0;
        MemRead_o   = 4'b0;
        Jump_o      = 1'b0;
        Jalr_o      = 1'b0;
        Branch_o    = 1'b0;
        ALUsrc_o    = 1'b0;
        ALUop_o     = 2'b0;
        ImmSrc_o    = 3'b0;
        ImmUI_o     = 1'b0;
    end

    always @(*)
    begin
        casex(opcode_i)
            7'b011_0011:    // R-Type
            begin
                RegWrite_o  = 1'b1;
                ResultSrc_o = 2'b00;
                MemWrite_o  = 4'b0000;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'b0;
                ALUop_o     = 2'b10;
                ImmSrc_o    = 3'bx;
                ImmUI_o     = 1'bx;
            end
            7'b001_0011:    // I-type (-i)
            begin
                RegWrite_o  = 1'b1;
                ResultSrc_o = 2'b00;
                MemWrite_o  = 4'b0000;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'b1;
                ALUop_o     = 2'b10;
                ImmUI_o     = 1'bx;
                case(func3_i)
                    3'b001: ImmSrc_o    = 3'b110;    // SLLI
                    3'b101: ImmSrc_o    = 3'b110;    // SRLI, SRAI
                    default: ImmSrc_o   = 3'b001;    // common I-type
                endcase
            end
            7'b000_0011:    // I-type (load)
            begin
                RegWrite_o  = 1'b1;
                ResultSrc_o = 2'b01;
                MemWrite_o  = 4'b0000;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'b1;
                ALUop_o     = 2'b00;
                ImmSrc_o    = 3'b001;
                ImmUI_o     = 1'bx;
                case(func3_i)
                    3'b000: MemRead_o   = 4'b0001;  // LB
                    3'b001: MemRead_o   = 4'b0010;  // LH
                    3'b010: MemRead_o   = 4'b1000;  // LW
                    3'b100: MemRead_o   = 4'b1001;  // LBU
                    3'b101: MemRead_o   = 4'b1010;  // LHU
                    default: MemRead_o  = 4'b0000;
                endcase
            end
            7'b010_0011:    // S-type
            begin
                RegWrite_o  = 1'b0;
                ResultSrc_o = 2'bxx;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'b1;
                ALUop_o     = 2'b00;
                ImmSrc_o    = 3'b010;
                ImmUI_o     = 1'bx;
                case(func3_i)
                    3'b000: MemWrite_o  = 4'b0001;  // SB
                    3'b001: MemWrite_o  = 4'b0010;  // SH
                    3'b010: MemWrite_o  = 4'b1000;  // SW
                    default: MemWrite_o = 4'b0000;  
                endcase
            end
            7'b110_0011:    // B-type
            begin
                RegWrite_o  = 1'b0;
                ResultSrc_o = 2'bxx;
                MemWrite_o  = 4'b0000;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b1;
                ALUsrc_o    = 1'b0;
                ALUop_o     = 2'b01;
                ImmSrc_o    = 3'b011;
                ImmUI_o     = 1'bx;
            end
            7'b110_1111:    // J-type
            begin
                RegWrite_o  = 1'b1;
                ResultSrc_o = 2'b10;
                MemWrite_o  = 4'b0000;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b1;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'bx;
                ALUop_o     = 2'bxx;
                ImmSrc_o    = 3'b101;
                ImmUI_o     = 1'bx;
            end
            7'b110_0111:    // I-type (jalr)
            begin
                RegWrite_o  = 1'b1;
                ResultSrc_o = 2'b10;
                MemWrite_o  = 4'b0000;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b1;
                Jalr_o      = 1'b1;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'bx;
                ALUop_o     = 2'bxx;
                ImmSrc_o    = 3'b001;
                ImmUI_o     = 1'bx;
            end
            7'b011_0111:    // U-type (lui)
            begin
                RegWrite_o  = 1'b1;
                ResultSrc_o = 2'b11;
                MemWrite_o  = 4'b0000;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'bx;
                ALUop_o     = 2'bxx;
                ImmSrc_o    = 3'b100;
                ImmUI_o     = 1'b1;
            end
            7'b001_0111:    // U-type (auipc)
            begin
                RegWrite_o  = 1'b1;
                ResultSrc_o = 2'b11;
                MemWrite_o  = 4'b0000;
                MemRead_o   = 4'b0000;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'bx;
                ALUop_o     = 2'bxx;
                ImmSrc_o    = 3'b100;
                ImmUI_o     = 1'b0;
            end
            default:
            begin
                RegWrite_o  = 1'b0;
                ResultSrc_o = 2'b0;
                MemWrite_o  = 4'b0;
                MemRead_o   = 4'b0;
                Jump_o      = 1'b0;
                Jalr_o      = 1'b0;
                Branch_o    = 1'b0;
                ALUsrc_o    = 1'b0;
                ALUop_o     = 2'b0;
                ImmSrc_o    = 3'b0;
                ImmUI_o     = 1'b0;
            end
        endcase
    end
endmodule