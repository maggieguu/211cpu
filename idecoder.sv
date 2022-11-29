module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);


        wire [2:0] Rn, Rd, Rm;
        wire [4:0] imm5;
        wire [7:0] imm8;

        assign opcode = ir[15:13];
        assign ALU_op = ir[12:11];
        assign shift_op = ir[4:3];

        assign Rn = ir[10:8];
        assign Rd = ir[7:5];
        assign Rm = ir[2:0];

        assign imm5 = ir[4:0];
        assign imm8 = ir[7:0];

        signExtend sExt(.imm8(imm8), .imm5(imm5), .sximm8(sximm8), .sximm5(sximm5));

        mux mux3(.rn(Rn), .rd(Rd), .rm(Rm), .nsel(reg_sel), .readnum(r_addr), .writenum(w_addr));

        
endmodule: idecoder

module signExtend(input [7:0] imm8, input [4:0] imm5, output [15:0] sximm5, output [15:0] sximm8);
        reg [15:0] sximm81, sximm51;
        assign sximm8 = sximm81;
        assign sximm5 = sximm51;

        always @(*) begin 

                if (imm8[7] == 1) begin
                        sximm81 = {8'b11111111, imm8};
                end else begin
                        sximm81 = {8'b00000000, imm8};
                end

                if (imm5[4] == 1) begin
                        sximm51 = {11'b11111111111, imm5};
                end else begin
                        sximm51 = {11'b00000000000, imm5};
                end
        end

endmodule: signExtend

module mux(rn, rd, rm, nsel, readnum, writenum);
    parameter n = 3;
    input [n-1:0] rn, rd, rm;
    input [1:0] nsel;
    output [n-1:0] readnum, writenum;
    reg [n-1:0] readnum1, writenum1;
    assign readnum = readnum1;
    assign writenum = writenum1;
 
    always @(*) begin
        case (nsel)
            2'b10: begin
                readnum1 = rn;
                writenum1 = rn;
            end
            2'b01: begin
                readnum1 = rd;
                writenum1 = rd;
            end
            2'b00: begin
                readnum1 = rm;
                writenum1 = rm;
            end
            default: begin
                readnum1 = 2'bxx;
                writenum1 = 2'bxx;
            end
        endcase
    end
endmodule: mux
