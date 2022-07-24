`timescale 1ns/1ps

`include "const.v"
`include "reg.v"
`include "alu.v"

module testbench;
	reg clk = 0;

	always #5 clk = ~clk;

	t t0(clk);
endmodule

module t (/*AUTOARG*/
   // Inputs
   clk
   );
	input clk;

	reg [7:0] mem [2**`WIDTH_DOUBLE-1:0];
	reg [2:0] state = `STATE_FETCHPC;
	reg [`WIDTH_DOUBLE-1:0] pc;
	reg [`WIDTH_DOUBLE-1:0] op;
	reg [`WIDTH_DOUBLE-1:0] addr;

	integer i;
	initial for (i = 0; i < 2**`WIDTH_DOUBLE; i = i + 1) begin
		case (i)
		7:  {mem[i], mem[i-1]} = {`OP_MVC, 4'd1, 8'd8};
		9:  {mem[i], mem[i-1]} = {`OP_MVC, 4'd3, 8'd5};
		11: {mem[i], mem[i-1]} = {`OP_ADD, 4'd2, 4'd3, 4'd1};
		default: mem[i] = 0;
		endcase
	end

	reg  write0 = 0, write1 = 0;
	reg  [`WIDTH_SEG-1:0]    dstreg0;
	reg  [`WIDTH_SEG-1:0]    dstreg1;
	reg  [`WIDTH_WORD-1:0]   dstval0;
	reg  [`WIDTH_WORD-1:0]   dstval1;
	reg  [`WIDTH_SEG-1:0]    argreg0 = 14;
	reg  [`WIDTH_SEG-1:0]    argreg1 = 15;
	wire [`WIDTH_WORD-1:0]   argval0;
	wire [`WIDTH_WORD-1:0]   argval1;
	wire [`WIDTH_DOUBLE-1:0] argval;
	registers r0(clk, write0, write1,
							 dstreg0, dstval0,
							 dstreg1, dstval1,
							 argreg0, argval0,
							 argreg1, argval1);

	assign argval = {argval1, argval0};

	wire [`WIDTH_WORD-1:0] dstval;
	wire carry;
	alu a0(op[15], op[14:12], argval0, argval1, dstval, carry);

	always @(posedge clk) begin
		case (state)
			`STATE_FETCHPC: begin
				state  <= `STATE_FETCHOP;
				write0 <= 0;
				write1 <= 0;
			end
			`STATE_FETCHOP: begin
				state <= `STATE_DECODE;
				pc    <= {argval};
				op    <= {mem[argval+1], mem[argval]};
			end
			`STATE_DECODE: begin
				state   <= `STATE_EXECUTE;
				argreg0 <= op[`ARG_SRC0];
				argreg1 <= op[`ARG_SRC1];
			end
			`STATE_EXECUTE: begin
				state <= `STATE_STOREPC;
				case (op[`ARG_OPC])
					`OP_HLT: begin
						pc <= pc - 2;
						$finish;
					end
					`OP_LD: begin
						write0 <= 1;
						dstreg0 <= op[`ARG_DST];
						dstval0 <= mem[argval];
					end
					`OP_ST: begin
					end
					`OP_MVC: begin
						write0  <= 1;
						dstreg0 <= op[`ARG_DST];
						dstval0 <= op[`ARG_NUM];
					end
					`OP_CALL: begin
					end
					`OP_MVD: begin
						write0 <= 1;
						write1 <= 1;
						dstreg0 <= (op[`ARG_DST] + 0);
						dstreg1 <= (op[`ARG_DST] + 1);
						dstval0 <= argval0;
						dstval1 <= argval1;
					end
					`OP_EQ: begin
					end
					`OP_LT: begin
					end
					`OP_CND: begin
					end
					`OP_ADD,
					`OP_SUB,
					`OP_OR,
					`OP_NOT,
					`OP_MV: begin
						write0  <= 1;
						dstreg0 <= op[`ARG_DST];
						dstval0 <= dstval;
					end
					`OP_NOP: begin
					end
				endcase
			end
			`STATE_STOREPC: begin
				write0  <= 1;
				write1  <= 1;
				dstreg0 <= 14;
				dstreg1 <= 15;
				{dstval1, dstval0} <= pc + 2;

				argreg0 <= 14;
				argreg1 <= 15;
				state <= `STATE_FETCHPC;
			end
		endcase
	end
endmodule
