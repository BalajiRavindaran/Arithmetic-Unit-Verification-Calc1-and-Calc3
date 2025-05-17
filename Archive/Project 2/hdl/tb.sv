`default_nettype none
`include "interface.sv"
`include "monitor.sv" // Assuming monitor code is in this file
`include "coverage_model.sv" // Assuming coverage model code is in this file

module tb(dut_interface dut_interface_master);

  bit clk;

  // Initialize the clock
  always begin
    clk = 1'b0;
    dut_interface_master.a_clk = clk;
    dut_interface_master.b_clk = clk;
    dut_interface_master.c_clk = clk;
    dut_interface_master.clk = clk;
    #6; // Toggle clock every 5 time units
    clk = 1'b1;
    dut_interface_master.a_clk = clk;
    dut_interface_master.b_clk = clk;
    dut_interface_master.c_clk = clk;
    dut_interface_master.clk = clk;
    #6;
  end

  // Instantiate the monitor and coverage model, passing the dut_interface_master interface
  monitor m0(.dut_bus(dut_interface_master)); // Ensure the monitor module accepts a parameter or modify accordingly
  coverage_model cm0(.dut_bus(dut_interface_master)); // Ensure the coverage model module accepts a parameter or modify accordingly

  // Test sequence
  initial begin
    // Initial reset sequence
    dut_interface_master.reset = 1'b1;
    #100ns; // Adjust timing as necessary
    dut_interface_master.reset = 1'b0;

    // Example test actions - You'll need to add your own stimulus here
    // This could involve driving specific signals on dut_interface_master to simulate
    // different scenarios and conditions for your DUT.
    #500ns;

    for (int i = 0; i<4; i++) begin
    @(posedge clk)
    dut_interface_master.req4_cmd = 1;
    dut_interface_master.req4_d1 = 1;
    dut_interface_master.req4_d2 = 2;
    dut_interface_master.req4_r1 = 3;
    dut_interface_master.req4_tag = i;
    @(negedge clk)
    dut_interface_master.req4_cmd = 0;
    dut_interface_master.req4_d1 = 4;
    dut_interface_master.req4_d2 = 5;
    dut_interface_master.req4_r1 = 6;
    dut_interface_master.req4_tag = 0;
    #100ns;
    end

    @(negedge clk);
    while (dut_interface_master.out1_resp !== 2'b01) begin
    @(negedge clk);
    if (dut_interface_master.out1_resp == 2'b01) begin
      break;
    end
  end

  end

endmodule