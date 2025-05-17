`default_nettype none
`include "interface.sv"

module top;

   // The interface
   dut_interface dut_bus();

   // The DUT
   calc_dut_wrapper calc_dut(dut_bus.slave);

   // The test
   tb test(dut_bus.master);

endmodule