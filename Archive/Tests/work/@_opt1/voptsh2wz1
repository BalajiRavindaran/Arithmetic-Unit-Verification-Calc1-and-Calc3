library verilog;
use verilog.vl_types.all;
entity Calculator_DUT is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        req_tag         : in     vl_logic_vector(0 to 1);
        req_cmd         : in     vl_logic_vector(0 to 3);
        req_d1          : in     vl_logic_vector(0 to 3);
        req_d2          : in     vl_logic_vector(0 to 3);
        req_r1          : in     vl_logic_vector(0 to 3);
        req_data        : in     vl_logic_vector(0 to 31);
        out_resp        : out    vl_logic_vector(0 to 1);
        out_tag         : out    vl_logic_vector(0 to 1);
        out_data        : out    vl_logic_vector(0 to 31)
    );
end Calculator_DUT;
