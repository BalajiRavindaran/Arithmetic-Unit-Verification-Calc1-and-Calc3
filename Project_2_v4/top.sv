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