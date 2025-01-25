module Data_Mem (
    input  wire        CLK,
    input  wire [ 3:0] rEN,      // 4'b1000: LW, 4'b0010: LH, 4'b1010: LHU, 4'b0001: LB, 4'b1001: LBU
    input  wire [ 3:0] wEN,      // 4'b1000: SW, 4'b0010: SH, 4'b0001: SB
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output  reg [31:0] data_o,
    output wire [ 7:0] mem_data_0,  
    output wire [ 7:0] mem_data_1,  
    output wire [ 7:0] mem_data_2,  
    output wire [ 7:0] mem_data_3,  
    output wire [ 7:0] mem_data_4,  
    output wire [ 7:0] mem_data_5,  
    output wire [ 7:0] mem_data_6,  
    output wire [ 7:0] mem_data_7,  
    output wire [ 7:0] mem_data_8,  
    output wire [ 7:0] mem_data_9,  
    output wire [ 7:0] mem_data_10, 
    output wire [ 7:0] mem_data_11, 
    output wire [ 7:0] mem_data_12, 
    output wire [ 7:0] mem_data_13, 
    output wire [ 7:0] mem_data_14, 
    output wire [ 7:0] mem_data_15, 
    output wire [ 7:0] mem_data_16, 
    output wire [ 7:0] mem_data_17, 
    output wire [ 7:0] mem_data_18, 
    output wire [ 7:0] mem_data_19, 
    output wire [ 7:0] mem_data_20, 
    output wire [ 7:0] mem_data_21, 
    output wire [ 7:0] mem_data_22, 
    output wire [ 7:0] mem_data_23, 
    output wire [ 7:0] mem_data_24, 
    output wire [ 7:0] mem_data_25, 
    output wire [ 7:0] mem_data_26, 
    output wire [ 7:0] mem_data_27, 
    output wire [ 7:0] mem_data_28, 
    output wire [ 7:0] mem_data_29, 
    output wire [ 7:0] mem_data_30, 
    output wire [ 7:0] mem_data_31  
    );

    reg [7:0] DATA_MEM [0:31];  // 8 bits x 32
    
    initial 
    begin
        $readmemh("DATA_MEM.hex", DATA_MEM);
    end
    
    // for debug
    assign mem_data_0  = DATA_MEM[ 0];
    assign mem_data_1  = DATA_MEM[ 1];
    assign mem_data_2  = DATA_MEM[ 2];
    assign mem_data_3  = DATA_MEM[ 3];
    assign mem_data_4  = DATA_MEM[ 4];
    assign mem_data_5  = DATA_MEM[ 5];
    assign mem_data_6  = DATA_MEM[ 6];
    assign mem_data_7  = DATA_MEM[ 7];
    assign mem_data_8  = DATA_MEM[ 8];
    assign mem_data_9  = DATA_MEM[ 9];
    assign mem_data_10 = DATA_MEM[10];
    assign mem_data_11 = DATA_MEM[11];
    assign mem_data_12 = DATA_MEM[12];
    assign mem_data_13 = DATA_MEM[13];
    assign mem_data_14 = DATA_MEM[14];
    assign mem_data_15 = DATA_MEM[15];
    assign mem_data_16 = DATA_MEM[16];
    assign mem_data_17 = DATA_MEM[17];
    assign mem_data_18 = DATA_MEM[18];
    assign mem_data_19 = DATA_MEM[19];
    assign mem_data_20 = DATA_MEM[20];
    assign mem_data_21 = DATA_MEM[21];
    assign mem_data_22 = DATA_MEM[22];
    assign mem_data_23 = DATA_MEM[23];
    assign mem_data_24 = DATA_MEM[24];
    assign mem_data_25 = DATA_MEM[25];
    assign mem_data_26 = DATA_MEM[26];
    assign mem_data_27 = DATA_MEM[27];
    assign mem_data_28 = DATA_MEM[28];
    assign mem_data_29 = DATA_MEM[29];
    assign mem_data_30 = DATA_MEM[30];
    assign mem_data_31 = DATA_MEM[31];



    // Read (Load)
    always @(*)
    begin
        case (rEN)
            4'b1000: data_o = {DATA_MEM[addr_i +32'd3], DATA_MEM[addr_i +32'd2], DATA_MEM[addr_i +32'd1], DATA_MEM[addr_i]}; // LW
            4'b0010: data_o = {                {16{DATA_MEM[addr_i +32'd1][7]}}, DATA_MEM[addr_i +32'd1], DATA_MEM[addr_i]}; // LH (Signed)
            4'b1010: data_o = {                   8'b0,                    8'b0, DATA_MEM[addr_i +32'd1], DATA_MEM[addr_i]}; // LHU
            4'b0001: data_o = {                                                {24{DATA_MEM[addr_i][7]}}, DATA_MEM[addr_i]}; // LB (Signed)
            4'b1001: data_o = {                   8'b0,                    8'b0,                    8'b0, DATA_MEM[addr_i]}; // LBU
            default: data_o = {DATA_MEM[addr_i +32'd3], DATA_MEM[addr_i +32'd2], DATA_MEM[addr_i +32'd1], DATA_MEM[addr_i]}; // LW
        endcase
    end
    
    // Write (STORE)
    always @(posedge CLK)   
    begin
        if (wEN[3])         // SW
        begin
            DATA_MEM[addr_i +32'd3] <= data_i[31:24];
            DATA_MEM[addr_i +32'd2] <= data_i[23:16];
            DATA_MEM[addr_i +32'd1] <= data_i[15: 8];
            DATA_MEM[addr_i       ] <= data_i[ 7: 0];
        end
        else if (wEN[1])    // SH
        begin
            DATA_MEM[addr_i +32'd1] <= data_i[15: 8];
            DATA_MEM[addr_i       ] <= data_i[ 7: 0];
        end
        else if (wEN[0])    // SB
        begin
            DATA_MEM[addr_i       ] <= data_i[ 7: 0];
        end
        //else                // default
        //begin
        //    DATA_MEM[addr_i +32'd3] <= DATA_MEM[addr_i +32'd3];
        //    DATA_MEM[addr_i +32'd2] <= DATA_MEM[addr_i +32'd2];
        //    DATA_MEM[addr_i +32'd1] <= DATA_MEM[addr_i +32'd1];
        //    DATA_MEM[addr_i       ] <= DATA_MEM[addr_i       ];
        //end
    end


endmodule
