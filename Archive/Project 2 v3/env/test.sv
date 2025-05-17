`include "storeTransaction.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "environment.sv" // Include this if you have an environment class

// Have to change // Include Environment
module test(dut_interface dut_interface_master);

  bit clk;
  environment env;
  monitor mon;
  mailbox storeTransaction_mbx = new();

  // Clock
  always begin
    clk = 1'b0;
    dut_interface_master.a_clk = clk;
    dut_interface_master.b_clk = clk;
    dut_interface_master.c_clk = clk;
    dut_interface_master.clk = clk;
    #20;
    clk = 1'b1;
    dut_interface_master.a_clk = clk;
    dut_interface_master.b_clk = clk;
    dut_interface_master.c_clk = clk;
    dut_interface_master.clk = clk;
    #20;
  end

  initial begin
    env = new(dut_interface_master, storeTransaction_mbx);
    mon = new(dut_interface_master, storeTransaction_mbx);

    reset();
    setAllPortsToZero();
    #100ns;

    fork
      mon.run();  // Start the monitor's run task
      begin
        repeat (5) begin
          @(posedge clk)
          env.start();
          @(negedge clk)
          setAllPortsToZero();
          #100ns;
        end
      end
    join

  end

  task reset();
    dut_interface_master.reset = 1'b1;
    #640ns;
    dut_interface_master.reset = 1'b0;
  endtask

  task setAllPortsToZero();
    dut_interface_master.req1_cmd = 0;
    dut_interface_master.req1_d1 = 0;
    dut_interface_master.req1_d2 = 0;
    dut_interface_master.req1_r1 = 0;
    dut_interface_master.req1_tag = 0;
    dut_interface_master.req1_data = 0;
    dut_interface_master.req2_cmd = 0;
    dut_interface_master.req2_d1 = 0;
    dut_interface_master.req2_d2 = 0;
    dut_interface_master.req2_r1 = 0;
    dut_interface_master.req2_tag = 0;
    dut_interface_master.req2_data = 0;
    dut_interface_master.req3_cmd = 0;
    dut_interface_master.req3_d1 = 0;
    dut_interface_master.req3_d2 = 0;
    dut_interface_master.req3_r1 = 0;
    dut_interface_master.req3_tag = 0;
    dut_interface_master.req3_data = 0;
    dut_interface_master.req4_cmd = 0;
    dut_interface_master.req4_d1 = 0;
    dut_interface_master.req4_d2 = 0;
    dut_interface_master.req4_r1 = 0;
    dut_interface_master.req4_tag = 0;
    dut_interface_master.req4_data = 0;
  endtask

endmodule