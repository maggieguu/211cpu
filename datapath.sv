module muxx(input [1:0] wb_sel, input [15:0] mdata, input [15:0] sximm8, input [15:0] pc, input [15:0] C, output [15:0] w_data);
	reg [1:0] wb_sel1;
	assign wb_sel1 = wb_sel;
	reg [15:0] w_data1;
	assign w_data = w_data1;
	
		always @(*) begin
			case(wb_sel)
				2'b11: w_data1 = mdata;
				2'b10: w_data1 = sximm8;
				2'b01: w_data1 = pc;
				2'b00: w_data1 = C;
				default:;
			endcase
		end
		
endmodule: muxx


module vDFF #(parameter n = 1) (input clk, input en, input [n - 1: 0] w_data, output [n - 1: 0] ALU_out);
	reg [n - 1: 0] ALU_out1;
	assign ALU_out = ALU_out1;
        always @(posedge clk) 
            begin
                if(en==1'b1)
                    ALU_out1 <= w_data;
                else 
                    ALU_out1 <= 1'b0; 
            end 
 endmodule: vDFF


module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
								input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);

		// same as existing 
		wire ZZ, VV, NN;
    wire [15:0] w_data, r_data, out_a, out_b, sout, val_A, val_B, ALUout;

		
		reg [15:0] datapath_out1;
		assign datapath_out = datapath_out1;
		wire [2:0] Z_out1;
		
		wire [2:0] flag;

     // 1 Instantiates register file
    regfile REGFILE(.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

    // 3 Instantiates register A
    vDFF #(16) regA(.clk(clk),.en(en_A), .w_data(r_data),.ALU_out(out_a));

    // 4 Instantiates register B
    vDFF #(16) regB(.clk(clk), .en(en_B), .w_data(r_data), .ALU_out(out_b));

    // 8 Instantiates shifter 
    shifter shifted(.shift_in(out_b), .shift_op(shift_op),.shift_out(sout));

    // 7 Instantiates mux B
    assign val_B = sel_B ? sximm5 : sout;

    // 6 Instantiates mux A
    assign val_A = sel_A ? 16'b0000000000000000 : out_a;

    // 2 Instantiates ALU
    ALU alu(.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALUout), .N(NN), .V(VV), .Z(ZZ));

	
		assign flag = {ZZ, NN, VV};

    // 5 Instantiates register C
    vDFF #(16) regC(.clk(clk), .en(en_C), .w_data(ALUout), .ALU_out(datapath_out1));

    // 10 Instantiates status register
    vDFF #(3) status(.clk(clk), .en(en_status), .w_data(flag), .ALU_out(Z_out1));

		assign Z_out = Z_out1[2];
		assign N_out = Z_out1[1];
		assign V_out = Z_out1[0];

    // 9 Instantiates mux for input
    muxx mux3(.wb_sel(wb_sel), .mdata(mdata), .sximm8(sximm8), .pc({8'b00000000, pc}), .C(datapath_out1), .w_data(w_data));

endmodule: datapath

