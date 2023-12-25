`include "adder_32.v"
`include "dff.v"
`include "mux21_32.v"
`include "shiftL1.v"
module fetch(
    input clk, reset,
    input [31:0] imm,rd1,
    input branch,mux2_ctrl,
    output [31:0] pc);

wire [31:0] pcnext,imm_shift,mux1,mux2;

dff #(32) dff1(clk,reset,pcnext,pc);
shiftL1 shift_imm(imm,imm_shift);
mux21_32 #(32) branch_select_mux1(32'h0004,imm_shift,branch,mux1);
mux21_32 #(32) pc_or_rd1_mux2(pc,rd1,mux2_ctrl,mux2);
adder_32 adder1(pc,mux1,pcnext);

endmodule
