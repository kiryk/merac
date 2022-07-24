`include "const.v"

`define WIDTH_OP 3
`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define OR  3'b011
`define NOT 3'b100
`define MVC 3'b101

module alu (op, a, b, y, carry);
	input  wire [`WIDTH_OP-1:0]   op;
	input  wire [`WIDTH_WORD-1:0] a;
	input  wire [`WIDTH_WORD-1:0] b;
	output reg  [`WIDTH_WORD-1:0] y;
	output reg  carry;

	/* verilator lint_off CASEINCOMPLETE */
	always @(op, a, b) begin
		case (op)
			`ADD: begin
				{carry, y} = a + b;
			end
			`SUB: begin
				{carry, y} = a - b;
			end
			`AND: begin
				{carry, y} = {|y, a & b};
			end
			`OR: begin
				{carry, y} = {|y, a | b};
			end
			`NOT: begin
				{carry, y} = {|y, ~a};
			end
			`MVC: begin
				{carry, y} = {|y, a};
			end
		endcase
	end
	/* verilator lint_on CASEINCOMPLETE */
endmodule
