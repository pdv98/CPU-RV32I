module Instr_Mem (
    input  wire [31:0] PC_F,
    output wire [31:0] Instr_F
    );

    reg [31:0] instr_mem [0:4095];     // 32 x 4096 memory

    initial
    begin
        $readmemh("instructions.hex", instr_mem);
        // $readmemh --> 합성 가능한 회로의 MEM 초기값 설정 시에도 사용 가능
	    // 명령어를 처음에 프로그래밍하여 저장하고 clk cycle 시작    
    end

    assign Instr_F = instr_mem[PC_F[31:2]];
    // "word aligned" (because of "PC <= PC+4")

    //always @(*)
    //begin
    //    Instr_F <= instr_mem[PC_F >> 2];
    //end
    
endmodule