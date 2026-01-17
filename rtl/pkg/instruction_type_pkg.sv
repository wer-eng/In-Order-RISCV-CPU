package rv32i_pkg;

    // =========================================================================
    // OPCODE
    // =========================================================================
    typedef enum logic [6:0] {
        OP_R_TYPE   = 7'b0110011, // ADD, SUB, SLL, SLT, SRL, SRA, OR, AND [cite: 1, 2]
        OP_I_TYPE   = 7'b0010011, // ADDI, SLTI, XORI, SLLI, SRLI, SRAI 
        OP_LOAD     = 7'b0000011, // LB, LH, LW, LBU, LHU 
        OP_STORE    = 7'b0100011, // SB, SH, SW 
        OP_BRANCH   = 7'b1100011, // BEQ, BNE, BLT, BGE, BLTU, BGEU 
        OP_JAL      = 7'b1101111, // JAL 
        OP_JALR     = 7'b1100111, // JALR 
        OP_LUI      = 7'b0110111, // LUI 
        OP_AUIPC    = 7'b0010111, // AUIPC 
        OP_SYSTEM   = 7'b1110011  // ECALL, EBREAK, CSRRW, CSRRS, CSRRC 
    } opcode_t;

    // =========================================================================
    // FUNCT3 
    // =========================================================================
    
    // R-Type ve I-Type için ortak Funct3
    typedef enum logic [2:0] {
        F3_ADD_SUB  = 3'b000, // ADDI, ADD, SUB 
        F3_SLL      = 3'b001, // SLLI, SLL [cite: 1, 2]
        F3_SLT      = 3'b010, // SLTI, SLT [cite: 1, 2]
        F3_SLTU     = 3'b011, // SLTIU, SLTU [cite: 1, 2]
        F3_XOR      = 3'b100, // XORI, XOR [cite: 1, 2]
        F3_SR_LA    = 3'b101, // SRL, SRA, SRLI, SRAI [cite: 1, 2]
        F3_OR       = 3'b110, // ORI, OR [cite: 1, 2]
        F3_AND      = 3'b111  // ANDI, AND [cite: 1, 2]
    } funct3_arith_t;

    // Branch 
    typedef enum logic [2:0] {
        F3_BEQ      = 3'b000, 
        F3_BNE      = 3'b001,  
        F3_BLT      = 3'b100, 
        F3_BGE      = 3'b101, 
        F3_BLTU     = 3'b110, 
        F3_BGEU     = 3'b111  
    } funct3_branch_t;

    // Load/Store  Funct3
    typedef enum logic [2:0] {
        F3_BYTE     = 3'b000, // LB, SB 
        F3_HALF     = 3'b001, // LH, SH 
        F3_WORD     = 3'b010, // LW, SW 
        F3_BYTE_U   = 3'b100, // LBU 
        F3_HALF_U   = 3'b101  // LHU 
    } funct3_mem_t;

    // =========================================================================
    // FUNCT7 
    // =========================================================================
    localparam logic [6:0] F7_DEFAULT  = 7'b0000000;
    localparam logic [6:0] F7_ALT      = 7'b0100000; // SUB, SRA, SRAI 

endpackage