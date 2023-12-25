module control(
    input [31:0] instr,
    output [6:0] opcode,
    output reg [3:0] ALUop,//used for alu control
    output reg [1:0] ALUsrcB,
    output reg [2:0] loadCtrl,
    output reg [1:0] storeCtrl,
    output reg regwrite, ALUsrcA,MemWrite,MemReg,Mux2_ctrl);

wire [2:0] funct3;
wire [6:0] funct7;
assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];
always @(*)
begin
    storeCtrl <= 2'b11;
    loadCtrl <= 3'b111;
    case (opcode)
        //R type
        7'b0110011: begin
            ALUsrcA <= 1'b1;
            ALUsrcB <= 2'b00;
            if (funct7 == 7'b0000000) begin
                ALUop <= {1'b0, funct3}; //add, slt, sltu, sll, xor, srl, or ,and
                end
            else if (funct7 == 7'b0100000) begin
                ALUop <= {1'b1, funct3}; //sub, sra
            end
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b1;
            Mux2_ctrl <= 1'b0;//pc
        end
        
        //I type (arithmatic, shift, logic)
        7'b0010011: begin
            ALUsrcA <= 1'b1;
            ALUsrcB <= 2'b10;
            if (funct7 == 7'b0100000) begin
                ALUop <= {1'b1, funct3}; //srai
            end
            else begin
                ALUop <= {1'b0, funct3}; //addi, slti, sltui, slli, xori, srli, ori ,andi
            end
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b1;//no operation
            Mux2_ctrl <= 1'b0;//pc


        end

        //I type (load)
        7'b0000011: begin
            ALUsrcA <= 1'b1;
            ALUsrcB <= 2'b10;
            ALUop <= 4'b0000;//sum rs1 & imm
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b0;
            loadCtrl <= funct3;
            Mux2_ctrl <= 1'b0;
            end


        //I type (jalr)
        7'b1100111: begin
            ALUsrcA <= 1'b0;
            ALUsrcB <= 2'b01;
            ALUop <= 4'b0000;//sum pc + 4
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b0;
            Mux2_ctrl <= 1'b1;//rs1
        end

        //J type(jal)
        7'b110111: begin
            ALUsrcA <= 1'b0;
            ALUsrcB <= 2'b01;
            ALUop <= 4'b0000;//sum pc + 4
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b1;
            Mux2_ctrl <= 1'b0;//pc
        end

        //U type (lui)
        7'b0110111: begin
            ALUsrcA <= 1'b1;
            ALUsrcB <= 2'b10;
            ALUop <= 4'b0000;//sum rd1 + imm
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b1;
            Mux2_ctrl <= 1'b0;//pc
        end

        //U type (auipc)
        7'b0010111: begin
            ALUsrcA <= 1'b0;//pc
            ALUsrcB <= 2'b10;
            ALUop <= 4'b0000;//sum pc + imm
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b1;
            Mux2_ctrl <= 1'b0;//pc
        end

        //S type 
        7'b0100011: begin
            ALUsrcA <= 1'b1;//rs1
            ALUsrcB <= 2'b10;
            ALUop <= 4'b0000;//sum rd1 + imm
            regwrite <= 1'b1;
            MemWrite <= 1'b0;
            MemReg <= 1'b1;
            Mux2_ctrl <= 1'b0;//pc
            storeCtrl <= funct3[1:0];
        end

        //B type 
        7'b1100011: begin
            ALUsrcA <= 1'b1;//rs1
            ALUsrcB <= 2'b00;
            ALUop <= {1'b1, funct3};//sumr rs1-rs2
            regwrite <= 1'b0;
            MemWrite <= 1'b0;
            MemReg <= 1'b0;
            Mux2_ctrl <= 1'b0;//pc
        end
    endcase

end
endmodule