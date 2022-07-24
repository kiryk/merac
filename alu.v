`include "const.v"

`define WIDTH_OP 3

`define ADD  3'b000
`define SUB  3'b001
`define AND  3'b010
`define OR   3'b011
`define NOT  3'b100
`define MV   3'b101

module alu (active, op, a, b, y, carry);
  input  wire active;
  input  wire [`WIDTH_OP-1:0]   op;
  input  wire [`WIDTH_WORD-1:0] a;
  input  wire [`WIDTH_WORD-1:0] b;
  output reg  [`WIDTH_WORD-1:0] y;
  output reg  carry;

  /* verilator lint_off CASEINCOMPLETE */
  always @(op, a, b) begin
    if (active) case (op)
    `ADD: {carry, y} = a + b;
    `SUB: {carry, y} = a - b;
    `AND: {carry, y} = {|y, a & b};
    `OR:  {carry, y} = {|y, a | b};
    `NOT: {carry, y} = {|y, ~a};
    `MV:  {carry, y} = {|y, a};
    endcase
  end
  /* verilator lint_on CASEINCOMPLETE */
endmodule
