`include "fetch.v"
`include "control.v"
`include "regfile.v"
`include "mux42_32.v"
//`include "mux21_32.v" //already included in fetch.v
`include "alu.v"
`include "immgen.v"
`include "store.v"
`include "load.v"
module processor(
    input clk,reset,
    input [31:0] instruction,readdata,
    output MemWrite,
    output [31:0] pc, ALUResult,writedata
);

wire [31:0] imm,rd1,rd2,wd,srcA,srcB,loadOut;
wire [1:0] ALUsrcB,storeCtrl;
wire [6:0] opcode;
wire [3:0] ALUop;
wire [2:0] loadCtrl;
wire branch, mux2_ctrl,regwrite,ALUsrcA,MemReg;

control control(instruction,opcode,ALUop,ALUsrcB,loadCtrl,storeCtrl,regwrite,ALUsrcA,MemWrite,MemReg,Mux2_ctrl);
regfile regfile(clk,regwrite,instruction[19:15],instruction[24:20],instruction[11:7],wd,rd1,rd2);
immgen immgen(instruction,imm);
mux42_32 #(32) mux5(rd2,32'h0004,imm,32'b0,ALUsrcB,srcB);
mux21_32 #(32) mux4(pc,rd1,ALUsrcA,srcA);
alu alu(opcode,ALUop,srcA,srcB,ALUResult,branch);
fetch fetch(clk,reset,imm,rd1,branch,mux2_ctrl,pc);
load load(readdata,loadCtrl,loadOut);
store store(rd2,storeCtrl,writedata);
mux21_32 #(32) mux3(loadOut,ALUResult,MemReg,wd);

endmodule