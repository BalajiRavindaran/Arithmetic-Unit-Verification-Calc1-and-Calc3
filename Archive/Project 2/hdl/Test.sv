`default_nettype none

module test;

   logic [0:1] out1_resp, out1_tag, out2_resp, out2_tag, out3_resp, out3_tag, out4_resp, out4_tag;
   logic [0:31] out1_data, out2_data, out3_data, out4_data;
   logic scan_out;
   logic clk;
   logic [0:1] req1_tag, req2_tag, req3_tag, req4_tag;
   logic a_clk, b_clk, c_clk, reset, scan_in;
   logic [0:3] req1_cmd, req1_d1, req1_d2, req1_r1, req2_cmd, req2_d1, req2_d2, req2_r1, req3_cmd, req3_d1, req3_d2, req3_r1, req4_cmd, req4_d1, req4_d2, req4_r1;
   logic [0:31] req1_data, req2_data, req3_data, req4_data;

   calc3_top dut (
      .req1_tag(req1_tag),
      .req2_tag(req2_tag),
      .req3_tag(req3_tag),
      .req4_tag(req4_tag),
      .a_clk(a_clk),
      .b_clk(b_clk),
      .c_clk(c_clk),
      .reset(reset),
      .scan_in(scan_in),
      .req1_cmd(req1_cmd),
      .req1_d1(req1_d1),
      .req1_d2(req1_d2),
      .req1_r1(req1_r1),
      .req2_cmd(req2_cmd),
      .req2_d1(req2_d1),
      .req2_d2(req2_d2),
      .req2_r1(req2_r1),
      .req3_cmd(req3_cmd),
      .req3_d1(req3_d1),
      .req3_d2(req3_d2),
      .req3_r1(req3_r1),
      .req4_cmd(req4_cmd),
      .req4_d1(req4_d1),
      .req4_d2(req4_d2),
      .req4_r1(req4_r1),
      .req1_data(req1_data),
      .req2_data(req2_data),
      .req3_data(req3_data),
      .req4_data(req4_data),
      .out1_resp(out1_resp),
      .out1_tag(out1_tag),
      .out2_resp(out2_resp),
      .out2_tag(out2_tag),
      .out3_resp(out3_resp),
      .out3_tag(out3_tag),
      .out4_resp(out4_resp),
      .out4_tag(out4_tag),
      .out1_data(out1_data),
      .out2_data(out2_data),
      .out3_data(out3_data),
      .out4_data(out4_data),
      .scan_out(scan_out)
   );

  // Initialize the clock
  always begin
    clk = 1'b0;
    a_clk = clk;
    b_clk = clk;
    c_clk = clk;
    #20; // Toggle clock every 5 time units
    clk = 1'b1;
    a_clk = clk;
    b_clk = clk;
    c_clk = clk;
    #20;
  end

  // Instantiate the monitor and coverage model, passing the dut_interface_master interface
  // monitor m0(.dut_bus(dut_interface_master)); // Ensure the monitor module accepts a parameter or modify accordingly
  // coverage_model cm0(.dut_bus(dut_interface_master)); // Ensure the coverage model module accepts a parameter or modify accordingly

  // Test sequence
  initial begin
    // Initial reset sequence
    reset = 1'b1;
    #100ns; // Adjust timing as necessary
    reset = 1'b0;
    

    // Example test actions - You'll need to add your own stimulus here
    // This could involve driving specific signals on dut_interface_master to simulate
    // different scenarios and conditions for your DUT.
    #100ns;

    @(posedge clk)
    req1_cmd = 4'b1010;
    req1_d1 = 4'b0001;
    req1_tag = 1;
    @(negedge clk)

    @(negedge clk);
    while (out1_resp !== 2'b01) begin
    @(negedge clk);
    if (out1_resp == 2'b01) begin
      break;
    end
  end

  end

endmodule