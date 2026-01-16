module register_file(
    input logic clk,
    input logic reset_n,
    input logic[31:0] data_in,
    input logic wr_en,
    input logic[4:0] reg_wr_addr,
    output logic[31:0] data_1_out, 
    output logic[31:0] data_2_out,
    input logic[4:0] reg_1_addr,
    input logic[4:0] reg_2_addr
);

logic [31:0] register_file [0:31];

always_comb begin


    if (wr_en && reg_wr_addr == reg_1_addr && reg_wr_addr != 5'd0)
        data_1_out = data_in;
    else if (reg_1_addr == 5'd0)
        data_1_out = 32'd0;
    else
        data_1_out = register_file[reg_1_addr];

    if (wr_en && reg_wr_addr == reg_2_addr && reg_wr_addr != 5'd0)
        data_2_out = data_in;
    else if (reg_2_addr == 5'd0)
        data_2_out = 32'd0;
    else
        data_2_out = register_file[reg_2_addr];

end
 integer i;

always_ff @(posedge clk,negedge reset_n ) begin 
    if(!reset_n)begin 
        for (i=0; i<32; i=i+1)
            register_file[i] <= 32'd0;
    end else begin
        if(reg_wr_addr != 5'd0 && wr_en)register_file[reg_wr_addr]<=data_in;
    end     
end

endmodule