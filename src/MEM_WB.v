module MEM_WB (
    input wire        CLK,
    input wire        nRST,
    input wire        RegWrite_i,
    input wire [ 1:0] ResultSrc_i,
    input wire [31:0] ALUResult_i,
    input wire [31:0] ReadData_i,
    input wire [ 4:0] RD_addr_i,
    input wire [31:0] pc_incr_i,
    input wire [31:0] pc_ui_i,
    output reg        RegWrite_o,
    output reg [ 1:0] ResultSrc_o,
    output reg [31:0] ALUResult_o,
    output reg [31:0] ReadData_o,
    output reg [ 4:0] RD_addr_o,
    output reg [31:0] pc_incr_o,
    output reg [31:0] pc_ui_o
    );

    always @(posedge CLK)
    begin
        if (~nRST)
        begin
            RegWrite_o      <= 1'b0;  
            ResultSrc_o     <= 2'b0;
            ALUResult_o     <= 32'b0;
            ReadData_o      <= 32'b0; 
            RD_addr_o       <= 5'b0;
            pc_incr_o       <= 32'b0; 
            pc_ui_o         <= 32'b0;
        end
        else
        begin
            RegWrite_o      <= RegWrite_i;
            ResultSrc_o     <= ResultSrc_i;
            ALUResult_o     <= ALUResult_i;
            ReadData_o      <= ReadData_i;
            RD_addr_o       <= RD_addr_i;
            pc_incr_o       <= pc_incr_i;
            pc_ui_o         <= pc_ui_i;
        end
        
    end

endmodule
