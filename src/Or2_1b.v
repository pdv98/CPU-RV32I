module Or2_1b (
    input  wire data1_i,
    input  wire data2_i,
    output wire data_o
    );

    assign data_o = data1_i | data2_i;

endmodule