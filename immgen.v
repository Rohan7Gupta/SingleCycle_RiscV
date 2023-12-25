module immgen(
    input [31:0] instr,
    output reg [31:0] imm);

always @(*)
begin
    case (instr[6:0])
        //R type
        7'b0110011: begin
            imm <= 32'h0000;
        end
        
        //I type (arithmatic, shift, logic)
        7'b0010011: begin
            case (instr[14:12])
                            3'b001, 3'b101: begin // slli, srli, srai
                                imm = {12'b0, instr[31:20]}; // shift amount immediate
                            end
                            3'b000, 3'b010, 3'b011, 3'b100, 3'b111: begin // addi, slti, sltiu, xori, ori, andi
                                imm <= {{20{instr[31]}}, instr[31:20]};
                            end
            endcase
        end

        //I type (load)
        7'b0000011: begin
            imm <= {{20{instr[31]}}, instr[31:20]};
            end


        //I type (jalr)
        7'b1100111: begin
            imm <= {{20{instr[31]}}, instr[31:20]};
        end

        //J type(jal)
        7'b110111: begin
            imm <= {{12{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21]}; //jal
        end

        //U type (lui)
        7'b0110111: begin
            imm = {instr[31:20], 12'b0};
        end

        //U type (auipc)
        7'b0010111: begin
            imm = {instr[31:20], 12'b0};
        end

        //S type 
        7'b0100011: begin
            imm <= {{20{instr[31]}}, instr[31:25], instr[11:7]};
        end

        //B type 
        7'b1100011: begin
            imm <= {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8]};

        end
    endcase

end
endmodule