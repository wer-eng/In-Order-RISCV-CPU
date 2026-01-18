import cpu_types_pkg::*;
import instruction_type_pkg::*;

module rf_read(
    input logic forward,//when it is 1 ,mean that we take rd from alu with forwarding
    output logic[31:0] data_1_out, 
    output logic[31:0] data_2_out,
    input logic[31:0] data_1_in, 
    input logic[31:0] data_2_in,
    input logic[31:0] PC_in;
    input logic[31:0] imm,
    input logic[1:0] srcA,
    input logic[1:0] srcB
);

always_comb begin 
    case(srcA)
        SRC_RS1:begin
            data_1_out=data_1_in;
        end 
        SRC_PC:begin 
            data_1_out=PC_in
        end 
        SRC_ZERO:begin 
            data_1_out=32'd0;
        end 
    
    endcase

    case(srcB)
        SRC_RS2:begin
            data_2_out=data_2_in;
        end 
        SRC_IMM:begin 
            data_2_out=imm;
        end     
        SRC_4:begin 
            data_2_out=32'd4;
        end 
    endcase
end 

endmodule