module instruction_decoder(
    input logic clk,
    input logic reset_n,
    input logic[6:0] opcode,
    input logic[2:0] funct3,
    input logic[6:0] funct7,
)

typedef enum logic[1:0] { 
    ALU=2'b00,
    MEM=2'b01,
    PC=2'b10,//Before jumping, it writes the next address of your current location (i.e., PC + 4) to the register.
    IMM=2'b11
 } WB_STAGE_SRC;

typedef enum logic[4:0] { 
    ALU_SUB=5'b00000, 
    ALU_ADD=5'b00000, 
    ALU_SLL=5'b00000, 
    ALU_SLT=5'b00000,
    ALU_SLTU=5'b00000,
    ALU_XOR=5'b00000,
    ALU_SRA=5'b00000,
    ALU_SRL=5'b00000,
    ALU_OR=5'b00000,
    ALU_AND=5'b00000,
} alu_op;

typedef enum logic[2:0] {  } branch_type;
always_comb begin
    reg_write    = 1'b0;
    mem_read     = 1'b0;
    mem_write    = 1'b0;
    alu_src      = 1'b0; 
    branch       = 1'b0;
    jump         = 1'b0;
    alu_control  = 5'b00000; 
    illegal_instr
    case (opcode)
        // --- R-TYPE (REGISTER-REGISTER) ---
        7'b0110011: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
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
        7'b0010011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            case (funct3)
                3'b000: alu_control = ALU_ADD;  // ADDI
                3'b010: alu_control = ALU_SLT;  // SLTI
                3'b011: alu_control = ALU_SLTU; // SLTIU
                3'b100: alu_control = ALU_XOR;  // XORI
                3'b110: alu_control = ALU_OR;   // ORI
                3'b111: alu_control = ALU_AND;  // ANDI
                3'b001: alu_control = ALU_SLL;  // SLLI (funct7 genellikle 0'dır)
                3'b101: alu_control = (funct7[5]) ? ALU_SRA : ALU_SRL; // SRAI / SRLI
            endcase
        end

        // --- I-TYPE (LOAD) ---
        7'b0000011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            mem_read  = 1'b1;
            alu_control = ALU_ADD; //  (rs1 + imm)
        end

        // --- S-TYPE (STORE) ---
        7'b0100011: begin
            alu_src   = 1'b1;
            mem_write = 1'b1;
            alu_control = ALU_ADD; //  (rs1 + imm)
        end

        // --- B-TYPE (BRANCH) ---
        7'b1100011: begin
            branch = 1'b1;
            alu_src = 1'b0;
            // funct3 : BEQ(000), BNE(001), BLT(100), BGE(101), BLTU(110), BGEU(111)
        end

        // --- U-TYPE (LUI, AUIPC) ---
        7'b0110111: begin // LUI
            reg_write = 1'b1;
            alu_control = ALU_LUI; 
        end
        7'b0010111: begin // AUIPC
            reg_write = 1'b1;
            alu_control = ALU_AUIPC;
        end

        // --- J-TYPE (JAL) ---
        7'b1101111: begin // JAL
            reg_write = 1'b1;
            jump = 1'b1;
        end

        // --- I-TYPE (JALR) ---
        7'b1100111: begin // JALR
            reg_write = 1'b1;
            jump = 1'b1;
            alu_control = ALU_ADD;
        end

        // --- SYSTEM (CSR, ECALL, EBREAK) ---
        7'b1110011: begin
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
        7'b0001111: begin
            // Bellek bariyeri işlemleri
        end

        default: begin
            // Geçersiz komut durumu
        end
    endcase
end



endmodule 