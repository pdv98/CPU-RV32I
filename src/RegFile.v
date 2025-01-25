module RegFile (
    input wire         CLK,          // <- external
    input wire         nRST,         // <- external
    input wire         wEN,          // <- MEM_WB
    input wire  [ 4:0] RSaddr_i,     // <- ID_IF
    input wire  [ 4:0] RTaddr_i,     // <- ID_IF
    input wire  [ 4:0] RDaddr_i,     // <- ID_IF
    input wire  [31:0] wData_i,      // <- Mux_WB
    output wire [31:0] RSdata_o,     // -> ID_EX
    output wire [31:0] RTdata_o,      // -> ID_EX
    output wire [31:0] x0_o, 
    output wire [31:0] x1_o, 
    output wire [31:0] x2_o, 
    output wire [31:0] x3_o, 
    output wire [31:0] x4_o, 
    output wire [31:0] x5_o, 
    output wire [31:0] x6_o, 
    output wire [31:0] x7_o, 
    output wire [31:0] x8_o, 
    output wire [31:0] x9_o, 
    output wire [31:0] x10_o,
    output wire [31:0] x11_o,
    output wire [31:0] x12_o,
    output wire [31:0] x13_o,
    output wire [31:0] x14_o,
    output wire [31:0] x15_o,
    output wire [31:0] x16_o 
    );

    integer i;

    reg [31:0] register [0:31]; // 32 X 32

    assign RSdata_o = register[RSaddr_i];
    assign RTdata_o = register[RTaddr_i];

    // for debug
    assign x0_o = register[0];
    assign x1_o = register[1];
    assign x2_o = register[2];
    assign x3_o = register[3];
    assign x4_o = register[4];
    assign x5_o = register[5];
    assign x6_o = register[6];
    assign x7_o = register[7];
    assign x8_o = register[8];
    assign x9_o = register[9];
    assign x10_o = register[10];
    assign x11_o = register[11];
    assign x12_o = register[12];
    assign x13_o = register[13];
    assign x14_o = register[14];
    assign x15_o = register[15];
    assign x16_o = register[16];

    always @(negedge CLK)
    begin
        if (~nRST)
        begin
            for(i=0; i<32; i=i+1)
                register[i] <= 32'b0;
        end
        else
        begin
            if (wEN && (RDaddr_i != 5'b0))    // x0 cannot be written
                register[RDaddr_i] <= wData_i;
        end
    end

    // register[0] hardwired to 0
    // assign RSdata_o = (RSaddr_i == 5'b0) ? 32'b0 : register[RSaddr_i];
    // assign RTdata_o = (RTaddr_i == 5'b0) ? 32'b0 : register[RTaddr_i];

endmodule