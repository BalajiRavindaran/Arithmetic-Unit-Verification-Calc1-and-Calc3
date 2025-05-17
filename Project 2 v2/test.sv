//////////////////////////////////////////////////////////////////////////////////
// Module: test                                                                 //
// Date: 2024-04-15                                                            //
//                                                                              //
// Description:                                                                 //
// The `test` module is the top-level entity for verification environment that  //
// orchestrates the interaction between the testbench components and the DUT    //
// through the `dut_interface_master` interface. It controls the initial        //
// conditions for the DUT, such as resetting and setting ports to zero, and     //
// initiates the test sequence by invoking the environment's start task.        //
//                                                                              //
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor                  //
//                                                                              //
// Revision History:                                                            //
// - 2024-04-15: Initial creation and setup of the test module. It integrates  //
//               the environment with the DUT interface for simulation.         //
//                                                                              //
// Notes:                                                                       //
// - This module simulates the primary test scenario for the DUT.               //
// - The instantiation of the environment and the coverage model is included.   //
// - Additional tests and configurations may be added as per requirements.      //
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

`include "Transactions.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "environment.sv" // Include this if you have an environment class

// Have to change // Include Environment
module test(dut_interface dut_interface_master);

  bit clk;
  environment env;
  coverage_model cm(dut_interface_master);
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
    env = new(dut_interface_master);

    reset();
    setAllPortsToZero();
    #100ns;

    env.start();

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