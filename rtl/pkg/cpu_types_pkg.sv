package cpu_types_pkg;

    typedef enum logic [1:0] {
        SRC_RS1,
        SRC_PC,
        SRC_ZERO
    } alu_srcA_t;

    typedef enum logic [1:0] {
        SRC_RS2,
        SRC_IMM,
        SRC_4
    } alu_srcB_t;

    typedef enum logic [3:0] {
        ALU_ADD,
        ALU_SUB,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLT,
        ALU_SLL,
        ALU_SRL,
        ALU_BEQ,
        ALU_BNE,
        ALU_BGE
        ALU_BLT,
        ALU_BLTU,
        ALU_BGEU
    } alu_op_t;
endpackage