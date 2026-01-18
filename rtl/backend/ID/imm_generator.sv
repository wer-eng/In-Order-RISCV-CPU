module imm_generation(

    input logic clk,
    input logic reset_n,
    input logic[31:0] instr_in,
    input logic[31:0] imm
);


always_comb begin 

    casez(instr_in[6:2])
        5'b00000,5'b00100,5'b11001: //I_TYPE
            imm = {{20{instr[31]}}, instr[31:20]};

        5'b01000: //S_TYPE
            imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        5'b11000: //B_TYPE
            imm = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
        5'b01101,5'b00101: //U_TYPE
            imm = {instr[31:12], 12'b0};
        5'b11011 : //J_TYPE
            imm = {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
        default: imm = 32'd0;
    endcase 

end 

endmodule 

/*
IMM_I     load (lb,lh,lw,lbu,lhu)   00000
IMM_I     OP-IMM (addi,andi,...)    00100
IMM_I     JALR                      11001

IMM_S     store (sb,sh,sw)          01000

IMM_B     branch (beq,bne,blt...)   11000

IMM_U     LUI                       01101
IMM_U     AUIPC                     00101

IMM_J     JAL                       11011
*/