module ID_stage(
    input logic clk,
    input logic reset_n,
    input logic stall,
    input logic [31:0] pc_in,
    input logic [31:0] instr_in,
    output logic [31:0] pc_out,
    output logic [31:0] instr_out
);

always_comb begin 
    
end

always_ff @(posedge clk,negedge reset_n ) begin 
    
end

endmodule 