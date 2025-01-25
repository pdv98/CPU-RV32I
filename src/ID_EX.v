module ID_EX (
    input wire        CLK,              // <- external
    input wire        nRST,
    input wire        CLR,              // <- Hazard_Unit
    input wire        RegWrite_i,       // <- Ctrl_Unit
    input wire [ 1:0] ResultSrc_i,      // <- Ctrl_Unit
    input wire [ 3:0] MemRead_i,
    input wire [ 3:0] MemWrite_i,       // <- Ctrl_Unit
    input wire        Jump_i,           // <- Ctrl_Unit
    input wire        Jalr_i,           // <- Ctrl_Unit
    input wire        Branch_i,         // <- Ctrl_Unit
    input wire [ 3:0] ALUCtrl_i,        // <- Ctrl_Unit
    input wire        ALUSrc_i,         // <- Ctrl_Unit
    input wire        imm_ui_i,         // <- Ctrl_Unit

    input wire [31:0] RS_data_i,        // <- Register
    input wire [31:0] RT_data_i,        // <- Register
    input wire [31:0] pc_i,             // <- IF_ID
    input wire [ 4:0] RS_addr_i,        // <- IF_ID
    input wire [ 4:0] RT_addr_i,        // <- IF_ID
    input wire [ 4:0] RD_addr_i,        // <- IF_ID
    input wire [31:0] imm_extd_i,       // <- IF_ID
    input wire [31:0] pc_incr_i,        // <- IF_ID

    output reg        RegWrite_o,       // -> EX_MEM
    output reg [ 1:0] ResultSrc_o,      // -> EX_MEM
    output reg [ 3:0] MemRead_o,        // -> EX_MEM
    output reg [ 3:0] MemWrite_o,       // -> EX_MEM
    output reg        Jump_o,           // -> EX_MEM
    output reg        Jalr_o,           // -> EX_MEM
    output reg        Branch_o,         // -> EX_MEM
    output reg [ 3:0] ALUCtrl_o,        // -> ALU
    output reg        ALUSrc_o,         // -> ALU
    output reg        imm_ui_o,         // -> EX_MEM

    output reg [31:0] RS_data_o,        // -> Mux_Fwd1
    output reg [31:0] RT_data_o,        // -> Mux_Fwd2
    output reg [31:0] pc_o,             // -> Add_E
    output reg [ 4:0] RS_addr_o,        // -> Hazard_Unit
    output reg [ 4:0] RT_addr_o,        // -> Hazard_Unit
    output reg [ 4:0] RD_addr_o,        // -> Hazard_Unit, EX_MEM
    output reg [31:0] imm_extd_o,       // -> Add_E
    output reg [31:0] pc_incr_o         // -> EX_MEM
    );

    always @(posedge CLK)
    begin
        if ((~nRST) | CLR)
        begin
            RegWrite_o      <= 1'b0;
            ResultSrc_o     <= 2'b0;
            MemRead_o       <= 4'b0;
            MemWrite_o      <= 4'b0;
            Jump_o          <= 1'b0;
            Jalr_o          <= 1'b0;
            Branch_o        <= 1'b0;
            ALUCtrl_o       <= 4'b0;
            ALUSrc_o        <= 1'b0;
            imm_ui_o        <= 1'b0;
            RS_data_o       <= 32'b0;
            RT_data_o       <= 32'b0;
            pc_o            <= 32'b0;
            RS_addr_o       <= 5'b0;
            RT_addr_o       <= 5'b0;
            RD_addr_o       <= 5'b0;
            imm_extd_o      <= 32'b0;
            pc_incr_o       <= 32'b0;
        end
        else
        begin
            RegWrite_o      <= RegWrite_i;
            ResultSrc_o     <= ResultSrc_i;
            MemRead_o       <= MemRead_i;
            MemWrite_o      <= MemWrite_i;
            Jump_o          <= Jump_i;
            Jalr_o          <= Jalr_i;
            Branch_o        <= Branch_i;
            ALUCtrl_o       <= ALUCtrl_i;
            ALUSrc_o        <= ALUSrc_i;
            imm_ui_o        <= imm_ui_i;
            RS_data_o       <= RS_data_i;
            RT_data_o       <= RT_data_i;
            pc_o            <= pc_i;
            RS_addr_o       <= RS_addr_i;
            RT_addr_o       <= RT_addr_i;
            RD_addr_o       <= RD_addr_i;
            imm_extd_o      <= imm_extd_i;
            pc_incr_o       <= pc_incr_i;
        end
    end

endmodule
