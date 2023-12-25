module alu(
    input  [6:0]opcode_reg,
    input  [3:0]ALUControl_reg,
    input  [31:0] SrcA, SrcB,
    output  reg [31:0] ALUResult,
    output reg branch
);
wire cf, zf, of, sf;
wire [31:0] addTemp, compSrcB;

assign compSrcB = (~SrcB);       
assign {cf, addTemp} = ALUControl_reg[3] ? (SrcA + compSrcB + 1'b1) : (SrcA + SrcB);            
assign zf = (addTemp == 0);
assign sf = addTemp[31];
assign of = (SrcA[31] ^ (compSrcB[31]) ^ addTemp[31] ^ cf);

always @(*)
begin
    case (opcode_reg)
        //  R-type instructions
        //  I-type instructions(shift, logical, arithmetic)
        7'b0110011 , 7'b0010011: begin
            case (ALUControl_reg)
                4'b0000:  ALUResult = addTemp; //add addi
                4'b0001:  ALUResult = (SrcA << SrcB); //sll slli
                4'b0010:  ALUResult = {31'b0,(sf != of)}; //slt slti
                4'b0011:  ALUResult = {31'b0,(~cf)}; //sltu sltu
                4'b0100:  ALUResult = SrcA ^ SrcB; //xor xori
                4'b0101:  ALUResult = (SrcA >> SrcB); //srl srli
                4'b0110:  ALUResult = SrcA | SrcB; //or ori
                4'b0111:  ALUResult = SrcA & SrcB; //and andi
                4'b1000:  ALUResult = addTemp; //sub
                4'b1101:  ALUResult = (SrcA >>> SrcB); //sra srai
            endcase
            branch = 1'b0;
        end
        //  I-type instructions(load)
        7'b0000011: begin
                ALUResult = addTemp; //ALUControl_reg[3]=0 i.e. addtemp = addition
                branch = 1'b0;
        end//lb,lh,lw,lbu,lhu

        //  I-type instructions(jump)
        7'b1100111: begin
                    ALUResult = addTemp;//ALUControl_reg[3]=0 i.e. addtemp = addition
                    branch=1'b1;
        end//jalr srcA=rs1
        
        //  S-type instructions
        7'b0100011: begin
            ALUResult = addTemp;//ALUControl_reg[3]=0 i.e. addtemp = addition
            branch = 1'b0;
        end//sb,sh,sw

        //B-type instructions
        7'b1100011: begin //ALUControl_reg[3]=1 i.e. addtemp = subtraction
                    ALUResult=addTemp;                    
                    case (ALUControl_reg) 
                        4'b1000: branch = zf;  //beq      
                        4'b1001: branch = ~zf;      //bne  
                        4'b1100: branch = (sf!=of);      //blt    
                        4'b1101: branch = (sf==of);        ///bge
                        4'b1110:branch = ~cf;         //bltu
                        4'b1111:branch = cf;   //bgeu
                        default: branch = 1'b0;    
                    endcase
            end//beq,bge,bgeu,blt,bltu,bne

        //  J-type instructions
        7'b1101111: begin  //ALUControl_reg[3]=0 i.e. addtemp = addition
                    ALUResult = addTemp;;
                    branch=1'b1;
        end//jal srcA=pc

        //  U-type (load upper immediate)
        7'b0110111: begin
                ALUResult = SrcB;
                branch = 1'b0;
        end

        //  U-type (add upper immediate)
        7'b0010111: begin  //ALUControl_reg[3]=0 i.e. addtemp = addition
                ALUResult = addTemp;
                branch = 1'b0;
        end
        
    endcase

end
endmodule