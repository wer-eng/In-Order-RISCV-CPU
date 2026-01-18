package

    typedef enum logic [1:0] {
        FWD_NONE = 2'b00,
        FWD_EX   = 2'b01,
        FWD_MEM  = 2'b10,
        FWD_WB   = 2'b11
    } fwd_sel_t;

endpackage