library verilog;
use verilog.vl_types.all;
entity calc3_dummy is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        req_cmd         : in     vl_logic;
        req_d1          : in     vl_logic;
        req_d2          : in     vl_logic;
        req_r1          : in     vl_logic;
        req_tag         : in     vl_logic;
        req_data        : in     vl_logic;
        out_resp        : out    vl_logic;
        out_tag         : out    vl_logic;
        out_data        : out    vl_logic
    );
end calc3_dummy;
