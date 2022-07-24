`define WIDTH_SEG    4
`define WIDTH_WORD   8
`define WIDTH_DOUBLE (2*`WIDTH_WORD)
`define WIDTH_INST   WIDTH_DOUBLE

`define STATE_FETCHPC 0
`define STATE_FETCHOP 1
`define STATE_DECODE  2
`define STATE_EXECUTE 3
`define STATE_STOREPC 4

`define OP_HLT  4'b0000
`define OP_ST   4'b0001
`define OP_LD   4'b0010
`define OP_MVC  4'b0011
`define OP_CALL 4'b0100
`define OP_EQ   4'b0101
`define OP_LT   4'b0110
`define OP_CND  4'b0111
`define OP_ADD  4'b1000
`define OP_SUB  4'b1001
`define OP_AND  4'b1010
`define OP_OR   4'b1011
`define OP_NOT  4'b1100
`define OP_MV   4'b1101
`define OP_MVD  4'b1110
`define OP_NOP  4'b1111

`define ARG_OPC  15:12
`define ARG_DST  11:8
`define ARG_SRC0 7:4
`define ARG_SRC1 3:0
`define ARG_NUM  7:0
