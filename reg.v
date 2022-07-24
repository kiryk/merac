`include "const.v"

module registers (clk, write0, write1, //pc,
                  waddr0, in0,  waddr1, in1,
	                raddr0, out0, raddr1, out1);
	input  wire clk;
	input  wire write0;
	input  wire write1;

	input  wire [`WIDTH_SEG-1:0]  raddr0;
	input  wire [`WIDTH_SEG-1:0]  raddr1;
	input  wire [`WIDTH_SEG-1:0]  waddr0;
	input  wire [`WIDTH_SEG-1:0]  waddr1;
	input  wire [`WIDTH_WORD-1:0] in0;
	input  wire [`WIDTH_WORD-1:0] in1;
	output wire [`WIDTH_WORD-1:0] out0;
	output wire [`WIDTH_WORD-1:0] out1;

	reg [`WIDTH_WORD-1:0] regs [2**`WIDTH_SEG-1:0];

  integer i;
  initial begin
    for (i = 0; i < 16; i = i + 1) begin
      if (i == 14)
        regs[i] = 6;
      else
        regs[i] = 0;
    end
  end

	assign out0 = regs[raddr0];
	assign out1 = regs[raddr1];

	always @(posedge clk) begin
		if (write0)
			regs[waddr0] <= in0;
		if (write1)
			regs[waddr1] <= in1;
	end
endmodule
