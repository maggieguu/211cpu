`define ADD 2'b00
`define SUB 2'b01
`define AND 2'b10
`define NOT 2'b11

module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, 
            output N, output V, output Z);
    reg [15:0] ALU_out1, result;
    reg Z1, V1, N1;
    assign V = V1;
    assign N = N1;
  	assign ALU_out = ALU_out1;
	assign Z = Z1;
    

  always @(*) begin
    case (ALU_op) 
        2'b00: result = val_A + val_B; 
        2'b01: result = val_A - val_B;
        2'b10: result = val_A & val_B;
        2'b11: result = ~val_B;
        default: result = 16'bxxxxxxxxxxxxxxxx;
    endcase

    ALU_out1 = result;

    if (ALU_out1[15] == 1'd1) begin
        N1 = 1'b1;
    end else begin
        N1 = 1'b0;
    end


    
    if (val_A[15] == 1'd0 & val_B[15] == 1'd1 & result[15] == 1'd1 )
        V1 = 1'b1;
    // if underflow when -A - B = C
    else if (val_A[15] == 1'd1 & val_B[15] == 1'd0 & result[15] == 1'd0)
        V1 = 1'b1;
    else V1 = 1'b0;
	

    // Assign Z to the right number depending on the ALU_out value
    if (ALU_out1 == 16'd0) begin
        Z1 = 1'b1;
    end else begin
        Z1 = 1'b0;
    end
    
end
  
endmodule: ALU
