module imem (input [5:0] a,
             output [31:0] rd);
reg [31:0] RAM[63:0];//RAM 64 words, each word 32 bit
initial
begin
$readmemh ("memfile.dat",RAM);
end
assign rd = RAM[a]; // word aligned
endmodule