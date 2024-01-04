`include "processor.v"
`include "imem.v"
`include "dmem.v"

module topLevel(
    input clk,reset,
    output [31:0] writedata,dataadr,
    output memwrite
);

wire [31:0] pc, instruction,readdata;

processor RiscV_singleCycle(clk,reset,instruction,readdata,memwrite,pc,dataadr,writedata);
imem imem(pc[7:2],instruction);
dmem dmem(clk,memwrite,dataadr,writedata,readdata);
endmodule