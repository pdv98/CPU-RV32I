// logic
`include "And2_1b.v"
`include "Or2_1b.v"
`include "Add2_32b.v"
`include "Mux2_32b.v"
`include "Mux3_32b.v"
`include "Mux4_32b.v"
// IF
`include "PC.v"
`include "Instr_Mem.v"
`include "IF_ID.v"
// ID
`include "RegFile.v"
`include "Extend.v"
`include "ID_EX.v"
// EX
`include "ALU.v"
`include "EX_MEM.v"
// MEM
`include "Data_Mem.v"
`include "MEM_WB.v"
// WB

// Hazard
`include "Hazard_Unit.v"

// Control
`include "Ctrl_Unit.v"
`include "ALUctrl.v"

/* ------------------------------ I/O Ports ------------------------------ */

module TOP (
    input wire CLK,
    input wire nRST
    );


/* ------------------------------ Wire & Reg (Fetch) ------------------------------ */

wire [31:0] Instr_F;
wire [31:0] PC_F;
wire [31:0] PC_Plus4_F;
wire [31:0] PC_next;
wire        Stall_F;

/* ------------------------------ Wire & Reg (Decode) ------------------------------ */

wire [ 3:0] ALUCtrl_D;
wire        ALUSrc_D;
wire        Branch_D;
wire        Flush_D;
wire [ 2:0] ImmSrc_D;
wire [31:0] ImmExt_D;
wire        Imm_ui_D;
wire [31:0] Instr_D;
wire        Jump_D;
wire        Jalr_D;
wire [ 3:0] MemRead_D;
wire [ 3:0] MemWrite_D;
wire [31:0] PC_D;
wire [31:0] PC_Plus4_D;
wire [31:0] RD1_D;
wire [31:0] RD2_D;
wire        RegWrite_D;
wire [ 1:0] ResultSrc_D;
wire [ 4:0] Rs1_D;
wire [ 4:0] Rs2_D;
wire [ 4:0] Rd_D;
wire        Stall_D;

wire [31:0] X0;
wire [31:0] X1;
wire [31:0] X2;
wire [31:0] X3;
wire [31:0] X4;
wire [31:0] X5;
wire [31:0] X6;
wire [31:0] X7;
wire [31:0] X8;
wire [31:0] X9;
wire [31:0] X10;
wire [31:0] X11;
wire [31:0] X12;
wire [31:0] X13;
wire [31:0] X14;
wire [31:0] X15;
wire [31:0] X16;

/* ------------------------------ Wire & Reg (Execute) ------------------------------ */

wire [ 3:0] ALUCtrl_E;
wire [31:0] ALUResult_E;
wire        ALUSrc_E;
wire        AndOut_E;
wire        Branch_E;
wire        Flush_E;
wire [ 1:0] Forward1_E;
wire [ 1:0] Forward2_E;
wire [31:0] ImmExt_E;
wire        Imm_ui_E;
wire        Jump_E;
wire        Jalr_E;
wire        Jsel_E;
wire [ 3:0] MemRead_E;
wire [ 3:0] MemWrite_E;
wire [31:0] MuxJ_o;
wire [31:0] PC_E;
wire [31:0] PC_Plus4_E;
wire        PC_Src_E;
wire [31:0] PC_Target_E;
wire [31:0] RD1_E;
wire [31:0] RD2_E;
wire [ 4:0] Rd_E;
wire        RegWrite_E;
wire [ 1:0] ResultSrc_E;
wire [ 4:0] Rs1_E;
wire [ 4:0] Rs2_E;
wire [31:0] Src1_E;
wire [31:0] Src2_E;
wire [31:0] WriteData_E;
wire        Zero_E;

/* ------------------------------ Wire & Reg (Memory) ------------------------------ */

wire [31:0] ALUResult_M;
wire [31:0] ReadData_M;
wire        RegWrite_M;
wire [ 1:0] ResultSrc_M;
wire [ 3:0] MemRead_M;
wire [ 3:0] MemWrite_M;
wire [31:0] WriteData_M;
wire [ 4:0] Rd_M;
wire [31:0] PC_Plus4_M;
wire [31:0] PC_Target_M;
wire [31:0] PC_ui_M;
wire        Imm_ui_M;
wire [31:0] ImmExt_M;

wire [7:0] MEM_0;
wire [7:0] MEM_1;
wire [7:0] MEM_2;
wire [7:0] MEM_3;
wire [7:0] MEM_4;
wire [7:0] MEM_5;
wire [7:0] MEM_6;
wire [7:0] MEM_7;
wire [7:0] MEM_8;
wire [7:0] MEM_9;
wire [7:0] MEM_10;
wire [7:0] MEM_11;
wire [7:0] MEM_12;
wire [7:0] MEM_13;
wire [7:0] MEM_14;
wire [7:0] MEM_15;
wire [7:0] MEM_16;
wire [7:0] MEM_17;
wire [7:0] MEM_18;
wire [7:0] MEM_19;
wire [7:0] MEM_20;
wire [7:0] MEM_21;
wire [7:0] MEM_22;
wire [7:0] MEM_23;
wire [7:0] MEM_24;
wire [7:0] MEM_25;
wire [7:0] MEM_26;
wire [7:0] MEM_27;
wire [7:0] MEM_28;
wire [7:0] MEM_29;
wire [7:0] MEM_30;
wire [7:0] MEM_31;


/* ------------------------------ Wire & Reg (WriteBack) ------------------------------ */

wire [31:0] ALUResult_W;
wire [ 4:0] Rd_W;
wire [31:0] ReadData_W;
wire        RegWrite_W;
wire [31:0] Result_W;
wire [ 1:0] ResultSrc_W;
wire [31:0] PC_Plus4_W;
wire [31:0] PC_ui_W;

/* ------------------------------ Wire & Reg (Control) ------------------------------ */

wire [ 1:0] ALU_op;


/* ------------------------------ Assignments ------------------------------ */

assign Rs1_D = Instr_D[19:15];
assign Rs2_D = Instr_D[24:20];
assign Rd_D = Instr_D[11:7];

/* ------------------------------ Sub-modules (Fetch) ------------------------------ */

Mux2_32b uMux_PC (
    .data1_i(PC_Plus4_F),   // <- uAdd_PC
    .data2_i(PC_Target_E),  // <- uAdd_E
    .select_i(PC_Src_E),    // <- uOr_E
    .data_o(PC_next)        // -> uPC
);

PC uPC (
    .CLK(CLK),                  // <- external
    .nRST(nRST),                // <- external
    .nEN(Stall_F),              // <- Hazard_Unit
    .PCnext(PC_next),           // <- uMux_PC
    .PC(PC_F)                   // -> uInstr_Mem
);

Instr_Mem uInstr_Mem (
    .PC_F(PC_F),                // <- uPC
    .Instr_F(Instr_F)           // -> uID_IF
);

Add2_32b uAdd_PC (
    .data1_i(PC_F),             // <- uPC
    .data2_i(32'h4),            // <- 4
    .data_o(PC_Plus4_F)         // -> uMux_PC, uIF_ID
);

IF_ID uIF_ID (
    .nEN(Stall_D),              // <- uHazard_Unit
    .nRST(nRST),
    .CLK(CLK),                  // <- external
    .CLR(Flush_D),              // <- uHazard_Unit
    .PC_F(PC_F),                // <- uPC
    .PC_Plus4F(PC_Plus4_F),     // <- uAdd_PC
    .Instr_F(Instr_F),          // <- uInstr_Mem
    .PC_D(PC_D),                // -> uID_EX
    .PC_Plus4D(PC_Plus4_D),      // -> uID_EX
    .Instr_D(Instr_D)           // -> uCtrl_Unit, uRegFile, uExtend
);

/* ------------------------------ Sub-modules (Decode) ------------------------------ */

RegFile uRegFile (
    .CLK(CLK),                      // <- external
    .nRST(nRST),                    // <- external
    .wEN(RegWrite_W),               // <- uMEM_WB
    .RSaddr_i(Instr_D[19:15]),      // <- uID_IF
    .RTaddr_i(Instr_D[24:20]),      // <- uID_IF
    .RDaddr_i(Rd_W),                // <- uID_IF
    .wData_i(Result_W),             // <- uMux_WB
    .RSdata_o(RD1_D),               // -> uID_EX
    .RTdata_o(RD2_D),               // -> uID_EX
    .x0_o(X0),
    .x1_o(X1),
    .x2_o(X2),
    .x3_o(X3),
    .x4_o(X4),
    .x5_o(X5),
    .x6_o(X6),
    .x7_o(X7),
    .x8_o(X8),
    .x9_o(X9),
    .x10_o(X10),
    .x11_o(X11),
    .x12_o(X12),
    .x13_o(X13),
    .x14_o(X14),
    .x15_o(X15),
    .x16_o(X16)
);

Extend uExtend (
    .Instr(Instr_D[31:7]),          // <- uIF_ID
    .src(ImmSrc_D),                 // <- uCtrl_Unit
    .imm_extd(ImmExt_D)             // -> uID_EX
);

ID_EX uID_EX (
    .CLK(CLK),                      // <- external
    .nRST(nRST),
    .CLR(Flush_E),                  // <- external
    .RegWrite_i(RegWrite_D),        // <- uCtrl_Unit
    .ResultSrc_i(ResultSrc_D),      // <- uCtrl_Unit
    .MemRead_i(MemRead_D),
    .MemWrite_i(MemWrite_D),        // <- uCtrl_Unit
    .Jump_i(Jump_D),                // <- uCtrl_Unit
    .Jalr_i(Jalr_D),                // <- uCtrl_Unit
    .Branch_i(Branch_D),            // <- uCtrl_Unit
    .ALUCtrl_i(ALUCtrl_D),          // <- uCtrl_Unit
    .ALUSrc_i(ALUSrc_D),            // <- uCtrl_Unit
    .imm_ui_i(Imm_ui_D),            // <- uCtrl_Unit
    .RS_data_i(RD1_D),              // <- uRegister
    .RT_data_i(RD2_D),              // <- uRegister
    .pc_i(PC_D),                    // <- uIF_ID
    .RS_addr_i(Rs1_D),              // <- uIF_ID
    .RT_addr_i(Rs2_D),              // <- uIF_ID
    .RD_addr_i(Rd_D),               // <- uIF_ID
    .imm_extd_i(ImmExt_D),          // <- uIF_ID
    .pc_incr_i(PC_Plus4_D),         // <- uIF_ID
    .RegWrite_o(RegWrite_E),        // -> uEX_MEM
    .ResultSrc_o(ResultSrc_E),      // -> uEX_MEM
    .MemRead_o(MemRead_E),
    .MemWrite_o(MemWrite_E),        // -> uEX_MEM
    .Jump_o(Jump_E),                // -> uEX_MEM
    .Jalr_o(Jalr_E),                // -> uEX_MEM
    .Branch_o(Branch_E),            // -> uEX_MEM
    .ALUCtrl_o(ALUCtrl_E),          // -> uALU
    .ALUSrc_o(ALUSrc_E),            // -> uALU
    .imm_ui_o(Imm_ui_E),            // -> uALU
    .RS_data_o(RD1_E),              // -> uMux3_Fwd1
    .RT_data_o(RD2_E),              // -> uMux3_Fwd2
    .pc_o(PC_E),                    // -> uAdd_E
    .RS_addr_o(Rs1_E),              // -> uHazard_Unit
    .RT_addr_o(Rs2_E),              // -> uHazard_Unit
    .RD_addr_o(Rd_E),               // -> uHazard_Unit, uEX_MEM
    .imm_extd_o(ImmExt_E),          // -> uAdd_E
    .pc_incr_o(PC_Plus4_E)          // -> uEX_MEM
);

/* ------------------------------ Sub-modules (Execute) ------------------------------ */

Or2_1b uOr_E (
    .data1_i(AndOut_E),             // <- uAnd_E
    .data2_i(Jsel_E),               // <- uID_EX
    .data_o(PC_Src_E)               // -> uMux_PC
);

And2_1b uAnd_E (
    .data1_i(Zero_E),               // <- uALU
    .data2_i(Branch_E),             // <- uID_EX
    .data_o(AndOut_E)               // -> uOr_E
);

Mux3_32b uMux3_Fwd1 (
    .data1_i(RD1_E),                // <- uID_EX
    .data2_i(Result_W),             // <- uMux_W
    .data3_i(ALUResult_M),          // <- uEX_MEM
    .select_i(Forward1_E),          // <- uHazard_Unit
    .data_o(Src1_E)                 // -> uALU
);

Mux3_32b uMux3_Fwd2 (
    .data1_i(RD2_E),                // <- uID_EX
    .data2_i(Result_W),             // <- uMux_W
    .data3_i(ALUResult_M),          // <- uEX_MEM
    .select_i(Forward2_E),          // <- uHazard_Unit
    .data_o(WriteData_E)            // -> uEX_MEM, uMux_E
);

Mux2_32b uMux_E (
    .data1_i(WriteData_E),          // <- uMux3_Fwd2
    .data2_i(ImmExt_E),             // <- uID_EX
    .select_i(ALUSrc_E),            // <- uID_EX
    .data_o(Src2_E)                 // -> uALU
);

Add2_32b uAdd_E (
    .data1_i(MuxJ_o),               // <- uMux_Jump
    .data2_i(ImmExt_E),             // <- uID_EX
    .data_o(PC_Target_E)            // -> uMux_PC
);

ALU uALU (
    .ALU_Ctrl(ALUCtrl_E),           // <- uID_EX
    .data1_i(Src1_E),               // <- uMux3_Fwd1
    .data2_i(Src2_E),               // <- uMux_E
    .result(ALUResult_E),           // -> uEX_MEM
    .ALU_Br(Zero_E)                 // -> uAnd_E
);

EX_MEM uEX_MEM(
    .CLK(CLK),
    .nRST(nRST),
    .RegWrite_i(RegWrite_E),
    .ResultSrc_i(ResultSrc_E),
    .MemRead_i(MemRead_E),
    .MemWrite_i(MemWrite_E),        // <- uCtrl_Unit
    .ALUResult_i(ALUResult_E),
    .WriteData_i(WriteData_E),
    .RD_addr_i(Rd_E),
    .pc_incr_i(PC_Plus4_E),
    .pc_target_i(PC_Target_E),
    .imm_ui_i(Imm_ui_E),
    .imm_extd_i(ImmExt_E),
    .RegWrite_o(RegWrite_M),
    .ResultSrc_o(ResultSrc_M),
    .MemRead_o(MemRead_M),
    .MemWrite_o(MemWrite_M),
    .ALUResult_o(ALUResult_M),
    .WriteData_o(WriteData_M),
    .RD_addr_o(Rd_M),
    .pc_incr_o(PC_Plus4_M),
    .pc_target_o(PC_Target_M),
    .imm_ui_o(Imm_ui_M),
    .imm_extd_o(ImmExt_M)
);

Or2_1b uOr_Jump(
    .data1_i(Jump_E),
    .data2_i(Jalr_E),
    .data_o(Jsel_E)
);

Mux2_32b uMux_Jump(
    .data1_i(PC_E),
    .data2_i(RD1_E),
    .select_i(Jalr_E),
    .data_o(MuxJ_o)
);    

/* ------------------------------ Sub-modules (Memory) ------------------------------ */

Data_Mem uData_Mem(
    .CLK(CLK),
    .rEN(MemRead_M),
    .wEN(MemWrite_M),
    .addr_i(ALUResult_M),
    .data_i(WriteData_M),
    .data_o(ReadData_M),
    .mem_data_0 (MEM_0),
    .mem_data_1 (MEM_1),
    .mem_data_2 (MEM_2),
    .mem_data_3 (MEM_3),
    .mem_data_4 (MEM_4),
    .mem_data_5 (MEM_5),
    .mem_data_6 (MEM_6),
    .mem_data_7 (MEM_7),
    .mem_data_8 (MEM_8),
    .mem_data_9 (MEM_9),
    .mem_data_10(MEM_10),
    .mem_data_11(MEM_11),
    .mem_data_12(MEM_12),
    .mem_data_13(MEM_13),
    .mem_data_14(MEM_14),
    .mem_data_15(MEM_15),
    .mem_data_16(MEM_16),
    .mem_data_17(MEM_17),
    .mem_data_18(MEM_18),
    .mem_data_19(MEM_19),
    .mem_data_20(MEM_20),
    .mem_data_21(MEM_21),
    .mem_data_22(MEM_22),
    .mem_data_23(MEM_23),
    .mem_data_24(MEM_24),
    .mem_data_25(MEM_25),
    .mem_data_26(MEM_26),
    .mem_data_27(MEM_27),
    .mem_data_28(MEM_28),
    .mem_data_29(MEM_29),
    .mem_data_30(MEM_30),
    .mem_data_31(MEM_31)
);

MEM_WB uMEM_WB(
    .CLK(CLK),
    .nRST(nRST),
    .RegWrite_i(RegWrite_M),
    .ResultSrc_i(ResultSrc_M),
    .ALUResult_i(ALUResult_M),
    .ReadData_i(ReadData_M),
    .RD_addr_i(Rd_M),
    .pc_incr_i(PC_Plus4_M),
    .pc_ui_i(PC_ui_M),
    .RegWrite_o(RegWrite_W),
    .ResultSrc_o(ResultSrc_W),
    .ALUResult_o(ALUResult_W),
    .ReadData_o(ReadData_W),
    .RD_addr_o(Rd_W),
    .pc_incr_o(PC_Plus4_W),
    .pc_ui_o(PC_ui_W)
);

Mux2_32b uMux_IMM(
    .data1_i(PC_Target_M),
    .data2_i(ImmExt_M),
    .select_i(Imm_ui_M),
    .data_o(PC_ui_M)
);

/* ------------------------------ Sub-modules (WriteBack) ------------------------------ */

Mux4_32b uMux_WB(
    .data1_i(ALUResult_W),
    .data2_i(ReadData_W),
    .data3_i(PC_Plus4_W),
    .data4_i(PC_ui_W),
    .select_i(ResultSrc_W),
    .data_o(Result_W)
);

/* ------------------------------ Sub-modules (Hazard) ------------------------------ */

Hazard_Unit uHazard_Unit(
    .RS_addrD_i(Rs1_D),
    .RT_addrD_i(Rs2_D),
    .RS_addrE_i(Rs1_E),
    .RT_addrE_i(Rs2_E),
    .RD_addrE_i(Rd_E),
    .PC_SrcE_i(PC_Src_E),
    .ResultSrcE_i(ResultSrc_E), // *** check
    .RD_addrM_i(Rd_M),
    .RegWriteM_i(RegWrite_M),
    .RD_addrW_i(Rd_W),
    .RegWriteW_i(RegWrite_W),
    .StallF_o(Stall_F),
    .StallD_o(Stall_D),
    .FlushD_o(Flush_D),
    .FlushE_o(Flush_E),
    .Forward1E_o(Forward1_E),
    .Forward2E_o(Forward2_E)
);

/* ------------------------------ Sub-modules (Control) ------------------------------ */

ALUctrl uALUctrl(
    .ALUop_i(ALU_op),
    .func3_i(Instr_D[14:12]),
    .func7_i(Instr_D[30]),        // func7[5]
    .opcode_i(Instr_D[5]),        // opcode[5]
    .ALUctrl_o(ALUCtrl_D) 
);

Ctrl_Unit uCtrl_Unit(
    .opcode_i(Instr_D[6:0]),
    .func3_i(Instr_D[14:12]),
    .RegWrite_o(RegWrite_D),
    .ResultSrc_o(ResultSrc_D),
    .MemWrite_o(MemWrite_D),
    .MemRead_o(MemRead_D),
    .Jump_o(Jump_D),
    .Jalr_o(Jalr_D),
    .Branch_o(Branch_D),
    .ALUsrc_o(ALUSrc_D),
    .ALUop_o(ALU_op),
    .ImmSrc_o(ImmSrc_D),
    .ImmUI_o(Imm_ui_D)
);

endmodule
