module monitor(dut_interface dut_bus);
  // Monitor logic here
  initial begin
    forever begin
      @(posedge dut_bus.clk); // Wait for the positive edge of the clock
      // Example: monitoring a simple request-response transaction
      $display("Time: %0t, Req Tag: %0h, Resp Tag: %0h, Resp Data: %0h",
               $time, dut_bus.req2_tag, dut_bus.out2_tag, dut_bus.out2_data);
    end
  end
endmodule