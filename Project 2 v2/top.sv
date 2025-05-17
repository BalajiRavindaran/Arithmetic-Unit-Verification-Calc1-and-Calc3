//////////////////////////////////////////////////////////////////////////////////
// Module: Top                                                                 //
//                                                                              //
// Description:                                                                 //
// This top-level module serves as the primary interface between the Device     //
// Under Test (DUT) and the verification environment. It integrates the DUT,    //
// the testbench, and the interface to establish a cohesive environment for     //
// testing and verification. The module instantiates the DUT and connects it    //
// to the testbench components through a well-defined interface, enabling       //
// controlled simulations and observations of the DUT's behavior.               //
//                                                                              //
// Responsibilities:                                                           //
// - Instantiating the DUT and verification environment                        //
// - Routing the interface signals to and from the DUT                         //
// - Managing top-level test configurations and parameters                      //
//                                                                              //
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor                   //
// Date: [2024-04-15]                                                           //
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////


`default_nettype none
`include "interface.sv"

module top;

   // The interface
   dut_interface dut_bus();

   // The DUT
   dut_wrapper calc_dut(dut_bus.slave);

   // The test
   test test(dut_bus.master);

endmodule