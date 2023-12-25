module store(
    input [31:0] rs2,
    input [1:0] storeCtrl,
    output reg [31:0] wd
);
always @(*)
begin
    case (storeCtrl)
            3'b00: begin
                wd <= {24'h000,rs2[7:0]};//sb
            end
            3'b01: begin
                wd <= {16'h00,rs2[15:0]};//sh
            end
            3'b10: begin
                wd <= rs2;//sw
            end
            default: begin
                wd <= rs2;
            end
            endcase
end
endmodule