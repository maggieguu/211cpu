`define NO_SHIFT 2'b00
`define LEFT_SHIFT 2'b01
`define RIGHT_SHIFT 2'b10
`define ARITH_RIGHT 2'b11

module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);
  reg [15:0] result;
  reg [15:0] sout;
  assign shift_out = sout;

  always @(*) begin
    case (shift_op)
        `NO_SHIFT: result = shift_in;
        `LEFT_SHIFT: result = {shift_in[14:0], 1'b0};
        `RIGHT_SHIFT: result = {1'b0, shift_in[15:1]};
        `ARITH_RIGHT: result = {shift_in[15], shift_in[15:1]};
        default: result = 16'bxxxxxxxxxxxxxxxx;
    endcase
    
    sout = result;
end
endmodule: shifter
