
import cpu_types_pkg::*;
import instruction_type_pkg::*;

module instruction_decoder(
    input logic clk,
    input logic reset_n,
    input logic[6:0] opcode,
    input logic[2:0] funct3,
    input logic[6:0] funct7
);

typedef enum logic[1:0] { 
    ALU=2'b00,
    MEM=2'b01,
    PC=2'b10,//Before jumping, it writes the next address of your current location (i.e., PC + 4) to the register.
    IMM=2'b11
}WB_STAGE_SRC;


alu_op alu_control=ALU_ADD;
alu_srcB_t alu_srcA=SRC_RS1;
alu_srcA_t alu_srcB=SRC_RS2;
WB_STAGE_SRC wb_src=ALU;

logic reg_write;
logic mem_read;
logic mem_write;
logic alu_src;
logic branch;
logic jump;
logic illegal_instr;
logic alu_by_pass;
always_comb begin
    reg_write    = 1'b0;
    mem_read     = 1'b0;
    mem_write    = 1'b0;
    alu_src      = 1'b0; 
    branch       = 1'b0;
    jump         = 1'b0;
    alu_control  = 5'b00000; 
    illegal_instr = 1'b0;
    alu_control=ALU_ADD;
    alu_srcA=SRC_RS1;
    alu_srcB=SRC_RS2;
    wb_src=ALU;
    alu_by_pass=1'b1;
    case (opcode)
        // --- R-TYPE (REGISTER-REGISTER) ---
        OP_R_TYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_srcA=SRC_RS1;
            alu_srcB=SRC_RS2;
            wb_src=ALU;
            case (funct3)
                3'b000: alu_control = (funct7[5]) ? ALU_SUB : ALU_ADD;
                3'b001: alu_control = ALU_SLL;
                3'b010: alu_control = ALU_SLT;
                3'b011: alu_control = ALU_SLTU;
                3'b100: alu_control = ALU_XOR;
                3'b101: alu_control = (funct7[5]) ? ALU_SRA : ALU_SRL;
                3'b110: alu_control = ALU_OR;
                3'b111: alu_control = ALU_AND;
            endcase
        end

        // --- I-TYPE (ALU WITH IMMEDIATE) ---
        OP_I_TYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_srcA=SRC_IMM;
            alu_srcB=SRC_RS2;
            wb_src=ALU;
            case (funct3)
                3'b000: alu_control = ALU_ADD;  // ADDI
                3'b010: alu_control = ALU_SLT;  // SLTI
                3'b011: alu_control = ALU_SLTU; // SLTIU
                3'b100: alu_control = ALU_XOR;  // XORI
                3'b110: alu_control = ALU_OR;   // ORI
                3'b111: alu_control = ALU_AND;  // ANDI
                3'b001: alu_control = ALU_SLL;  // SLLI
                3'b101: alu_control = (funct7[5]) ? ALU_SRA : ALU_SRL; // SRAI / SRLI
            endcase
        end

        // --- I-TYPE (LOAD) ---
        OP_LOAD: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            mem_read  = 1'b1;
            wb_src=MEM;
            alu_control = ALU_ADD; //  (rs1 + imm)
        end

        // --- S-TYPE (STORE) ---
        OP_STORE: begin
            alu_src   = 1'b1;
            mem_write = 1'b1;
            alu_srcA=SRC_RS1;
            alu_srcA=SRC_IMM;
            alu_control = ALU_ADD; //  (rs1 + imm)
        end

        // --- B-TYPE (BRANCH) ---
        OP_BRANCH: begin
            branch = 1'b1;
            alu_src = 1'b1;
            alu_srcA=SRC_RS1;
            alu_srcB=SRC_RS2;
            case (funct3)
                3'b000:  alu_control=ALU_BEQ;// BEQ (Branch Equal)
                3'b001:  alu_control=ALU_BNE;// BNE (Branch Not Equal)
                3'b100:  alu_control=ALU_BLT;// BLT (Branch Less Than - Signed)
                3'b101:  alu_control=ALU_BGE;// BGE (Branch Greater Equal - Signed)
                3'b110:  alu_control=ALU_BLTU;// BLTU (Branch Less Than - Unsigned)
                3'b111:  alu_control=ALU_BGEU;// BGEU (Branch Greater Equal - Unsigned)
                default: branch_taken = 1'b0;
            endcase
            // funct3 : BEQ(000), BNE(001), BLT(100), BGE(101), BLTU(110), BGEU(111)
        end

        // --- U-TYPE (LUI, AUIPC) ---
        OP_LUI: begin // LUI
            reg_write = 1'b1;
            alu_by_pass=1'b1;
            wb_src=alu;
        end
        OP_AUIPC: begin // AUIPC
            reg_write = 1'b1;
            alu_srcA=PC;
            alu_srcB=IMM;
            alu_src=1'b1;
            wb_src=alu;
            alu_control = ALU_ADD;
        end

        // --- J-TYPE (JAL) ---
        OP_JAL: begin // JAL
            reg_write = 1'b1;
            jump = 1'b1;
            wb_src=ALU;
        end

        // --- I-TYPE (JALR) ---
        OP_JALR: begin // JALR
            reg_write = 1'b1;
            jump = 1'b1;
            alu_srcA=SRC_RS1;
            alu_srcB=SRC_IMM;
            wb_src=PC;
            alu_control = ALU_ADD;
        end

        // --- SYSTEM (CSR, ECALL, EBREAK) ---
        OP_SYSTEM: begin
            case (funct3)
                3'b000: begin
                end
                default: begin
                    // CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
                    reg_write = 1'b1;
                end
            endcase
        end

        // --- FENCE ---
        OP_: begin
            // Bellek bariyeri işlemleri
        end

        default: begin
            illegal_instr = 1'b1;
        end
    endcase
end



endmodule 