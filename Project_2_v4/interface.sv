interface dut_interface;
   logic [0:1] out1_resp, out1_tag, out2_resp, out2_tag, out3_resp, out3_tag, out4_resp, out4_tag;
   logic [0:31] out1_data, out2_data, out3_data, out4_data;
   logic scan_out;
   logic clk;
   logic [0:1] req1_tag, req2_tag, req3_tag, req4_tag;
   logic a_clk, b_clk, c_clk, reset, scan_in;
   logic [0:3] req1_cmd, req1_d1, req1_d2, req1_r1, req2_cmd, req2_d1, req2_d2, req2_r1, req3_cmd, req3_d1, req3_d2, req3_r1, req4_cmd, req4_d1, req4_d2, req4_r1;
   logic [0:31] req1_data, req2_data, req3_data, req4_data;

   modport master(output req1_tag, req2_tag, req3_tag, req4_tag, 
                 output a_clk, b_clk, c_clk, clk, reset, scan_in, 
                 output req1_cmd, req1_d1, req1_d2, req1_r1, req2_cmd, req2_d1, req2_d2, req2_r1, req3_cmd, req3_d1, req3_d2, req3_r1, req4_cmd, req4_d1, req4_d2, req4_r1, 
                 output req1_data, req2_data, req3_data, req4_data,
                 input out1_resp, out1_tag, out2_resp, out2_tag, out3_resp, out3_tag, out4_resp, out4_tag,
                 input out1_data, out2_data, out3_data, out4_data,
                 input scan_out);

   modport slave(input req1_tag, req2_tag, req3_tag, req4_tag, 
                 input a_clk, b_clk, c_clk, reset, scan_in, 
                 input req1_cmd, req1_d1, req1_d2, req1_r1, req2_cmd, req2_d1, req2_d2, req2_r1, req3_cmd, req3_d1, req3_d2, req3_r1, req4_cmd, req4_d1, req4_d2, req4_r1, 
                 input req1_data, req2_data, req3_data, req4_data,
                 output out1_resp, out1_tag, out2_resp, out2_tag, out3_resp, out3_tag, out4_resp, out4_tag,
                 output out1_data, out2_data, out3_data, out4_data,
                 output scan_out);
endinterface