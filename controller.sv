`define WAIT 4'b0000
`define DECODE 4'b0001
`define MOVNEW 4'b0010
`define GETA 4'b0011
`define GETB 4'b0100
`define ALU 4'b0101
`define MOVREG 4'b0110
`define WRITE 4'b0111

module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
  

  reg [3:0] state;
  reg [1:0] reg_sel1;
  assign reg_sel = reg_sel1;
  reg [1:0] wb_sel1;
  assign wb_sel = wb_sel1;

  reg waiting1, w_en1, en_A1, en_B1, en_C1, en_status1, sel_A1, sel_B1;
  assign waiting = waiting1;
  assign w_en = w_en1;
  assign en_A = en_A1;
  assign en_B = en_B1;
  assign en_C = en_C1;
  assign en_status = en_status1;
  assign sel_A = sel_A1;
  assign sel_B = sel_B1;
  assign w_en = w_en1;


  always @(posedge clk) begin
    if(rst_n == 1'b1) begin
      state = `WAIT;
    end else begin
       case(state) 
        `WAIT:  if (start == 1'b1) begin 
                  state = `DECODE;
                end else begin
                  state = `WAIT; 
                end
        `DECODE:    if (opcode == 3'b110) begin
                                if (ALU_op == 2'b10) begin
                                    state = `MOVNEW; 
                                end else if (ALU_op == 2'b00) begin
                                    state = `GETB; 
                                end
                            end else if (opcode == 3'b101) begin
                                if (ALU_op !== 2'b11) begin
                                    state = `GETA; 
                                end else begin
                                    state = `GETB; 
                                end
                            end
                `MOVNEW:    state = `WAIT;
                `GETA:      state = `GETB; 
                `GETB:      if (opcode == 3'b101) begin
                                state = `ALU; 
                            end else begin
                                state = `MOVREG; 
                            end
						
                `ALU:       if (ALU_op !== 2'b01) begin
							                state = `WRITE; 
                            end else begin
							                state = `WAIT;
                            end
                `MOVREG:    state = `WRITE; 
                `WRITE:     state = `WAIT; 
                default:    state = 4'bxxxx;
            endcase
        end


        case (state)
            `WAIT:      begin
                            
                            if (start == 1'b1) begin
                                waiting1 = 1'b0;
                            end else begin
                                waiting1 = 1'b1;  
                            end
                            
                            reg_sel1 = 2'b00;
                            en_A1 = 1'b0;
                            en_B1 = 1'b0;
                            en_C1 = 1'b0;
                            en_status1 = 1'b0;
                            sel_A1 = 1'b0;
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b01;
                            w_en1 = 1'b0;
                        end
            `DECODE:    begin
                            
                            waiting1 = 1'b0; 
                            reg_sel1 = 2'b00;
                            en_A1 = 1'b0;
                            en_B1 = 1'b0;
                            en_C1 = 1'b0;
                            en_status1 = 1'b0;
                            sel_A1 = 1'b0;
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b01;
                            w_en1 = 1'b0;
                        end
            `MOVNEW:    begin
                           
                            waiting1 = 1'b0; 
                            reg_sel1 = 2'b01; 
                            en_A1 = 1'b0;
                            en_B1 = 1'b0;
                            en_C1 = 1'b0;
                            en_status1 = 1'b0;
                            sel_A1 = 1'b0;
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b10; 
                            w_en1 = 1'b1; 
                        end
            `GETA:      begin
                         
                            waiting1 = 1'b0; 
                            reg_sel1 = 2'b10; 
                            en_A1 = 1'b1; 
                            en_B1 = 1'b0;
                            en_C1 = 1'b0;
                            en_status1 = 1'b0;
                            sel_A1 = 1'b0;
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b01;
                            w_en1 = 1'b0;
                        end
            `GETB:      begin
                        
                            waiting1 = 1'b0; 
                            reg_sel1 = 2'b00; 
                            en_A1 = 1'b0;
                            en_B1 = 1'b1; 
                            en_C1 = 1'b0;
                            en_status1 = 1'b0;
                            sel_A1 = 1'b0;
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b01;
                            w_en1 = 1'b0;
                        end
            `ALU:       begin
                           
                            waiting1 = 1'b0; 
                            reg_sel1 = 2'b00;
                            en_A1 = 1'b0;
                            en_B1 = 1'b0;
                            if (ALU_op == 2'b01) begin
                                en_status1 = 1'b1; 
								                en_C1 = 1'b0;
                            end else begin
                                en_status1 = 1'b0; 
								                en_C1 = 1'b1; 
                            end
                            sel_A1 = 1'b0;
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b01;
                            w_en1 = 1'b0;
                        end
            `MOVREG:    begin
                        
                            waiting1 = 1'b0;
                            reg_sel1 = 2'b00;
                            en_A1 = 1'b0;
                            en_B1 = 1'b0;
                            en_C1 = 1'b1;
                            en_status1 = 1'b0;
                            sel_A1 = 1'b1; 
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b01;
                            w_en1 = 1'b0;
                        end
            `WRITE:     begin
                            
                            waiting1 = 1'b0; 
                            reg_sel1 = 3'b01; 
                            en_A1 = 1'b0;
                            en_B1 = 1'b0;
                            en_C1 = 1'b1; 
                            en_status1 = 1'b0;
                            sel_A1 = 1'b0;
                            sel_B1 = 1'b0;
                            wb_sel1 = 2'b01; 
                            w_en1 = 1'b1;
                        end
            default:    begin
                     
                            waiting1 = 1'bx;
                            reg_sel1 = 3'bxxx;
                            en_A1 = 1'bx;
                            en_B1 = 1'bx;
                            en_C1 = 1'bx;
                            en_status1 = 1'bx;
                            sel_A1 = 1'bx;
                            sel_B1 = 1'bx;
                            wb_sel1 = 4'bxxxx;
                            w_en1 = 1'bx;
                        end
        endcase
       
    end
  







endmodule: controller
