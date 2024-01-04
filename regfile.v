module regfile (input clk,regwrite,
                input [4:0] rs1,rs2,wr,
                input [31:0] wd,
                output [31:0] rd1,rd2);

    reg [31:0] regf[31:0];//32 registers each 32 bit
    always @(posedge clk)
    begin
    regf[5'b00000] <= 32'h0000;
        if(regwrite)
        regf[wr]<=wd;
    end
    assign rd1 = (rs1!=0)?regf[rs1]:0;//zero register = 0
    assign rd2 = (rs2!=0)?regf[rs2]:0;
endmodule