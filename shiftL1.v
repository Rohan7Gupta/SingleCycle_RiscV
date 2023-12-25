module shiftL1(input [31:0] a,
               output [31:0] y);

assign y = {a[30:0],2'b0};
endmodule