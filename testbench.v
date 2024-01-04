`include "topLevel.v"
`timescale 1ns/1ps

module testbench();

    reg clk;
    reg reset;
    wire [31:0] writedata, dataadr;
    wire memwrite;

    topLevel dut (
        .clk(clk),
        .reset(reset),
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite)
    );

    // Initialize signals
    initial begin
        reset <= 1;
        #10 reset <= 0;
        //$readmemh ("memfile.dat",dut.imem.RAM_instr);
        dut.imem.RAM_instr[0] = 32'h00030303;
        dut.imem.RAM_instr[1] = 32'h00130303;
        dut.imem.RAM_instr[2] = 32'h00a30333;
        dut.imem.RAM_instr[3] = 32'ha2a30313;

        // Initialize memory with example instructions
        // Modify this section based on your actual RISC-V program
        /*dut.dmem.memory[0] = 32'h00030303;  // Example: LW instruction
        dut.dmem.memory[1] = 32'h00130303;  // Example: LW instruction
        dut.dmem.memory[2] = 32'h00a30333;  // Example: ADD instruction
        dut.dmem.memory[3] = 32'ha2a30313;*/  // Example: SW instruction

        // Start the clock
        #10;
        forever #5 clk = ~clk; 
        #1000;
        $finish; // Generate a clock signal
    end

    // Monitor outputs
    always @(posedge clk) begin
        // Monitor outputs
        // For example, print memory contents, dataadr, writedata, etc.
        $display("PC: %h, Instruction: %h, ReadData: %h", dut.RiscV_singleCycle.pc, dut.RiscV_singleCycle.instruction, dut.RiscV_singleCycle.readdata);
        $display("Data Memory Content at Address %h: %h", dataadr, dut.dmem.RAM[dataadr/4]);
        $dumpfile("test.vcd");
        $dumpvars(0,testbench);
    end
    
endmodule
