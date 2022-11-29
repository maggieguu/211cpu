module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);

    wire [15:0] regOut, sximm5, sximm8, mdata;
    wire [7:0] pc;
    assign mdata = 16'd0;
    assign pc = 8'd0;
    wire [1:0] reg_sel, ALU_op, shift_op, wb_sel;
    wire [2:0] opcode, r_addr, w_addr;
    wire w_en, en_A, en_B, en_C, en_status, sel_A, sel_B;

    vDFF #(16) instruction_reg(.clk(clk), .en(load), .w_data(instr), .ALU_out(regOut));

    idecoder decoder(.ir(regOut), .reg_sel(reg_sel), .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op),
                      .sximm5(sximm5), .sximm8(sximm8), .r_addr(r_addr), .w_addr(w_addr));

    controller control(.clk(clk), .rst_n(rst_n), .start(start), .opcode(opcode), .ALU_op(ALU_op), 
                          .shift_op(shift_op), .Z(Z), .N(N), .V(V), .waiting(waiting), .reg_sel(reg_sel),
                            .wb_sel(wb_sel), .w_en(w_en), .en_A(en_A), .en_B(en_B), .en_C(en_C), 
                              .en_status(en_status), .sel_A(sel_A), .sel_B(sel_B));

    datapath data(.clk(clk), .mdata(mdata), .pc(pc), .wb_sel(wb_sel), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr),
                    .en_A(en_A), .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B), .ALU_op(ALU_op),
                      .en_C(en_C), .en_status(en_status), .sximm8(sximm8), .sximm5(sximm5), .datapath_out(out), 
                        .Z_out(Z), .N_out(N), .V_out(V));

endmodule: cpu
