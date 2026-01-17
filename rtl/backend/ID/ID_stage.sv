module ID_stage(
    input logic clk,
    input logic reset_n,
    input logic stall,
    input logic [31:0] pc_in,
    input logic [31:0] instr_in,
    output logic [31:0] pc_out,
    output logic [31:0] instr_out,
    output logic alu_op,
    output logic[31:0] alu_src_1,
    output logic[31:0] alu_src_2,

);




endmodule 