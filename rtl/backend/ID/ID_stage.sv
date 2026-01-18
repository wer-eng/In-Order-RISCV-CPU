import cpu_types_pkg::*;
import instruction_type_pkg::*;

module ID_stage(
    input  logic        clk,
    input  logic        reset_n,
    input  logic        stall,
    input  logic [31:0] pc_in,
    input  logic [31:0] instr_in,
    
 
    output logic        reg_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic        branch,
    output logic        jump,
    output alu_op       alu_control, 
    
    // Veri Çıkışları
    output logic [31:0] pc_out,
    output logic [31:0] instr_out,
    output logic [31:0] imm_out,
    

    output logic [31:0] alu_src_1,
    output logic [31:0] alu_src_2
);

  
    logic [31:0] imm_gen_wire;
    alu_srcA_t   alu_srcA_sel;
    alu_srcB_t   alu_srcB_sel;
    logic        alu_src_mux_ctrl;


    imm_generation imm_gen_unit (
        .clk(clk),
        .reset_n(reset_n),
        .instr_in(instr_in),
        .imm(imm_gen_wire)
    );


    instruction_decoder decoder_unit (
        .clk(clk),
        .reset_n(reset_n),
        .opcode(instr_in[6:0]),
        .funct3(instr_in[14:12]),
        .funct7(instr_in[31:25]),
        // Çıkış sinyalleri
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src_mux_ctrl),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control),
        .alu_srcA(alu_srcA_sel),
        .alu_srcB(alu_srcB_sel),
        .wb_src(),         
        .alu_by_pass(),
        .illegal_instr()
    );


    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pc_out    <= 32'h0;
            instr_out <= 32'h0;
            imm_out   <= 32'h0;
        end else if (!stall) begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
            imm_out   <= imm_gen_wire;
        end else if(flush)begin
            pc_out    <= 32'd0;
            instr_out <= 32'd0;
            imm_out   <= 32'd0;
        end 
    end


    assign alu_src_1 = (alu_srcA_sel == SRC_RS1) ? rs1_data_in : pc_in; 
    assign alu_src_2 = (alu_src_mux_ctrl) ? imm_gen_wire : rs2_data_in; 

endmodule