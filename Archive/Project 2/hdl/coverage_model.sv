module coverage_model(dut_interface dut_bus);

  // Coverage group
  covergroup cg_with @(posedge dut_bus.clk);
    // Cover points for request and response tags
    cp_req_tag_1: coverpoint dut_bus.req1_tag {
      bins low  = {0}; // Example bin
      bins high = {1,2,3}; // Example bins for other values
    }
    cp_req_tag_2: coverpoint dut_bus.req2_tag {
      bins low  = {0}; // Example bin
      bins high = {1,2,3}; // Example bins for other values
    }
    cp_req_tag_3: coverpoint dut_bus.req3_tag {
      bins low  = {0}; // Example bin
      bins high = {1,2,3}; // Example bins for other values
    }
    cp_req_tag_4: coverpoint dut_bus.req4_tag {
      bins low  = {0}; // Example bin
      bins high = {1,2,3}; // Example bins for other values
    }
  endgroup

  initial begin
    cg_with cg = new(); // Instantiate the coverage group
  end
endmodule