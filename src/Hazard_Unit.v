module Hazard_Unit (
    input  wire [ 4:0] RS_addrD_i,
    input  wire [ 4:0] RT_addrD_i,
    input  wire [ 4:0] RS_addrE_i,
    input  wire [ 4:0] RT_addrE_i,
    input  wire [ 4:0] RD_addrE_i,
    input  wire        PC_SrcE_i,
    input  wire [ 1:0] ResultSrcE_i,
    input  wire [ 4:0] RD_addrM_i,
    input  wire        RegWriteM_i,
    input  wire [ 4:0] RD_addrW_i,
    input  wire        RegWriteW_i,
    output wire        StallF_o,
    output wire        StallD_o,
    output wire        FlushD_o,
    output wire        FlushE_o,
    output reg  [ 1:0] Forward1E_o,
    output reg  [ 1:0] Forward2E_o
    );

    //initial begin
    //    lwStall = 1'b0;
    //end

/*  
    <Data Hazard>
    p.444
    RAW(Read After Write) Hazard
    : one instruction writes a register and subsequent instructions read this register.
    -> Stall & Forwarding

    RS_addr_E == RD_addr_M | RS_addr_E == RD_addr_W -> Forwarding is necessary 
*/

    always @(*)
    begin
        if      (((RS_addrE_i == RD_addrM_i) & RegWriteM_i) & (RS_addrE_i != 5'b0))   Forward1E_o = 2'b10;
        else if (((RS_addrE_i == RD_addrW_i) & RegWriteW_i) & (RS_addrE_i != 5'b0))   Forward1E_o = 2'b01;
        else                                                                          Forward1E_o = 2'b00;
    end

    always @(*)
    begin
        if      (((RT_addrE_i == RD_addrM_i) & RegWriteM_i) & (RT_addrE_i != 5'b0))   Forward2E_o = 2'b10;
        else if (((RT_addrE_i == RD_addrW_i) & RegWriteW_i) & (RT_addrE_i != 5'b0))   Forward2E_o = 2'b01;
        else                                                                          Forward2E_o = 2'b00;
    end

    reg lwStall;
    
    // assign lwStall = ResultSrcE_i & ((RS_addrD_i == RD_addrE_i) | (RT_addrD_i == RD_addrE_i));

    always @(*)
    begin
        if      ((ResultSrcE_i == 2'b00) & ((RS_addrD_i == RD_addrE_i) | (RT_addrD_i == RD_addrE_i)))      lwStall = 1'b0;
        else if ((ResultSrcE_i == 2'b01) & ((RS_addrD_i == RD_addrE_i) | (RT_addrD_i == RD_addrE_i)))      lwStall = 1'b1; // Load
        else if ((ResultSrcE_i == 2'b10) & ((RS_addrD_i == RD_addrE_i) | (RT_addrD_i == RD_addrE_i)))      lwStall = 1'b0; // pc+4
        else if ((ResultSrcE_i == 2'b11) & ((RS_addrD_i == RD_addrE_i) | (RT_addrD_i == RD_addrE_i)))      lwStall = 1'b1; // auipc, LUI *****
        else                                                                                               lwStall = 1'b0; // default
    end

    assign StallF_o = lwStall;
    assign StallD_o = lwStall;

/*
    <Control Hazard>
    p.450
*/
    assign FlushD_o = PC_SrcE_i;
    assign FlushE_o = lwStall | PC_SrcE_i;

endmodule
