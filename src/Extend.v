module Extend (
    input wire [31:7] Instr,    // <- IF_ID
    input wire [ 2:0] src,      // <- Ctrl_Unit
    output reg [31:0] imm_extd  // -> ID_EX
    );

    always @(*)
    begin
        casex (src)
//            3'b000: imm_extd = 32'b0;
            3'b001: imm_extd = {{20{Instr[31]}}, Instr[31:20]};                                 // I-type
            3'b010: imm_extd = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};                    // S-type
            3'b011: imm_extd = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};    // B-type
            3'b100: imm_extd = {Instr[31:12], 12'b0};                                           // U-type
            3'b101: imm_extd = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};  // J-type
            3'b110: imm_extd = {27'b0, Instr[24:20]};                                           // I-type (SLLI, SRLI, SRAI)
            default: imm_extd = 32'bx;
        endcase
    end

endmodule
