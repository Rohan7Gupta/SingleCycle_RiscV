module load(
    input [31:0] rd,
    input [2:0] loadCtrl,
    output reg [31:0] loadOut
);
always @(*)
begin
    case (loadCtrl)
            3'b000: begin//lb
                loadOut <= {{24{rd[7]}},rd[7:0]};
            end
            3'b001: begin//lh
                loadOut <= {{16{rd[15]}},rd[15:0]};
            end
            3'b010: begin//lw
                loadOut <= rd;
            end
            3'b100: begin//lbu
                loadOut <= {24'h000,rd[7:0]};
            end
            3'b101: begin //lhu
                loadOut <= {16'h00,rd[7:0]};
            end
            default: begin
                loadOut <= rd;
            end
    endcase
end
endmodule