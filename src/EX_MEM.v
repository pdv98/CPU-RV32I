module EX_MEM (
    input  wire        CLK,
    input wire         nRST,
    input  wire        RegWrite_i,
    input  wire [ 1:0] ResultSrc_i,
    input  wire [ 3:0] MemRead_i,
    input  wire [ 3:0] MemWrite_i,
    input  wire [31:0] ALUResult_i,
    input  wire [31:0] WriteData_i,
    input  wire [ 4:0] RD_addr_i,
    input  wire [31:0] pc_incr_i,
    input  wire [31:0] pc_target_i,
    input  wire        imm_ui_i,         // <- Ctrl_Unit
    input  wire [31:0] imm_extd_i,

    output reg         RegWrite_o,
    output reg  [ 1:0] ResultSrc_o,
    output reg  [ 3:0] MemRead_o,
    output reg  [ 3:0] MemWrite_o,
    output reg  [31:0] ALUResult_o,
    output reg  [31:0] WriteData_o,
    output reg  [ 4:0] RD_addr_o,
    output reg  [31:0] pc_incr_o,
    output reg  [31:0] pc_target_o,
    output reg         imm_ui_o,         // -> EX_MEM    
    output reg  [31:0] imm_extd_o
    );

    always @(posedge CLK)
    begin
        if (~nRST)
        begin
            RegWrite_o      <= 1'b0;
            ResultSrc_o     <= 2'b0;
            MemRead_o       <= 4'b0;
            MemWrite_o      <= 4'b0;
            ALUResult_o     <= 32'b0;
            WriteData_o     <= 32'b0;
            RD_addr_o       <= 5'b0;
            pc_incr_o       <= 32'b0;
            pc_target_o     <= 32'b0;
            imm_ui_o        <= 1'b0;
            imm_extd_o      <= 32'b0;
        end
        else
        begin
            RegWrite_o      <= RegWrite_i;
            ResultSrc_o     <= ResultSrc_i;
            MemRead_o       <= MemRead_i;
            MemWrite_o      <= MemWrite_i;
            ALUResult_o     <= ALUResult_i;
            WriteData_o     <= WriteData_i;
            RD_addr_o       <= RD_addr_i;
            pc_incr_o       <= pc_incr_i;
            pc_target_o     <= pc_target_i;
            imm_ui_o        <= imm_ui_i;
            imm_extd_o      <= imm_extd_i;
        end
    end

endmodule