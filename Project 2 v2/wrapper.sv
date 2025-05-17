//////////////////////////////////////////////////////////////////////////////////
// Module: dut_wrapper                                                         //
// Date: 2024-04-15                                                           //
//                                                                              //
// Description:                                                                 //
// The `dut_wrapper` module is a facilitator that wraps around the Device      //
// Under Test (DUT). It connects the DUT to the verification environment via   //
// the `dut_interface_slave` interface. This module acts as a bridge,          //
// forwarding the control and observation signals between the DUT and the test  //
// environment, thereby abstracting the complexities and allowing for a cleaner //
// top-level integration.                                                       //
//                                                                              //
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor                  //
//                                                                              //
// Revision History:                                                           //
// - 2024-04-15: Initial version of the dut_wrapper module created to interface//
//               with the new calc3_top DUT.                                   //
//                                                                              //
// Notes:                                                                       //
// - The dut_wrapper is responsible for signal mapping between the DUT and     //
//   the testbench interface.                                                   //
// - Ensure signal integrity by maintaining a consistent naming convention and  //
//   adherence to interface definitions.                                        //
// - This module should be revised if there are changes in the DUT interface or //
//   in the signal requirements of the testbench.                               //
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

module dut_wrapper (
    dut_interface dut_interface_slave
);

   // Instantiate the DUT
   calc3_top dut (
      .req1_tag(dut_interface_slave.req1_tag),
      .req2_tag(dut_interface_slave.req2_tag),
      .req3_tag(dut_interface_slave.req3_tag),
      .req4_tag(dut_interface_slave.req4_tag),
      .a_clk(dut_interface_slave.a_clk),
      .b_clk(dut_interface_slave.b_clk),
      .c_clk(dut_interface_slave.c_clk),
      .reset(dut_interface_slave.reset),
      .scan_in(dut_interface_slave.scan_in),
      .req1_cmd(dut_interface_slave.req1_cmd),
      .req1_d1(dut_interface_slave.req1_d1),
      .req1_d2(dut_interface_slave.req1_d2),
      .req1_r1(dut_interface_slave.req1_r1),
      .req2_cmd(dut_interface_slave.req2_cmd),
      .req2_d1(dut_interface_slave.req2_d1),
      .req2_d2(dut_interface_slave.req2_d2),
      .req2_r1(dut_interface_slave.req2_r1),
      .req3_cmd(dut_interface_slave.req3_cmd),
      .req3_d1(dut_interface_slave.req3_d1),
      .req3_d2(dut_interface_slave.req3_d2),
      .req3_r1(dut_interface_slave.req3_r1),
      .req4_cmd(dut_interface_slave.req4_cmd),
      .req4_d1(dut_interface_slave.req4_d1),
      .req4_d2(dut_interface_slave.req4_d2),
      .req4_r1(dut_interface_slave.req4_r1),
      .req1_data(dut_interface_slave.req1_data),
      .req2_data(dut_interface_slave.req2_data),
      .req3_data(dut_interface_slave.req3_data),
      .req4_data(dut_interface_slave.req4_data),
      .out1_resp(dut_interface_slave.out1_resp),
      .out1_tag(dut_interface_slave.out1_tag),
      .out2_resp(dut_interface_slave.out2_resp),
      .out2_tag(dut_interface_slave.out2_tag),
      .out3_resp(dut_interface_slave.out3_resp),
      .out3_tag(dut_interface_slave.out3_tag),
      .out4_resp(dut_interface_slave.out4_resp),
      .out4_tag(dut_interface_slave.out4_tag),
      .out1_data(dut_interface_slave.out1_data),
      .out2_data(dut_interface_slave.out2_data),
      .out3_data(dut_interface_slave.out3_data),
      .out4_data(dut_interface_slave.out4_data),
      .scan_out(dut_interface_slave.scan_out)
   );

endmodule