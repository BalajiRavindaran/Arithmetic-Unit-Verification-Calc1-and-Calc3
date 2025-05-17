module alu_sub_tb_v2;

  // Define test bench inputs
  logic c_clk;
  logic [0:1] out_resp1, out_resp2, out_resp3, out_resp4;
  logic [0:31] req1_data_in, req2_data_in, req3_data_in, req4_data_in;
  logic [0:3] req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
  logic [0:7] reset;

  // Define test bench outputs
  logic [0:31] out_data1, out_data2, out_data3, out_data4;

  int operand1 = 0;
  int operand2 = 0;

  bit [0:31] operand1_unsigned = $unsigned(operand1);
  bit [0:31] operand2_unsigned = $unsigned(operand2);
  bit [0:31] operand2_unsigned_temp = $unsigned(operand2);

  // int unsigned max_loop_value = 2; // 4294967295 Max Value

  int correct_count = 0;
  int error_count = 0;
  int clk_count = 0;

  int underflow_count = 0;
  int no_resp = 0;

  calc1_top calc_inst (
    .c_clk(c_clk),

    .req1_cmd_in(req1_cmd_in),
    .req2_cmd_in(req2_cmd_in),
    .req3_cmd_in(req3_cmd_in),
    .req4_cmd_in(req4_cmd_in),

    .req1_data_in(req1_data_in),
    .req2_data_in(req2_data_in),
    .req3_data_in(req3_data_in),
    .req4_data_in(req4_data_in),

    .reset(reset),

    .out_resp1(out_resp1),
    .out_resp2(out_resp2),
    .out_resp3(out_resp3),
    .out_resp4(out_resp4),

    .out_data1(out_data1),
    .out_data2(out_data2),
    .out_data3(out_data3),
    .out_data4(out_data4)
  );

  // Add your test bench logic here

  always begin
    c_clk = 1'b0;
    #6;
    c_clk = 1'b1;
    #6;
    clk_count++;
  end

initial begin
  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  for (operand1_unsigned = 0; operand1_unsigned <= 10; operand1_unsigned++) begin
    for (operand2_unsigned = 0; operand2_unsigned <= 10; operand2_unsigned++) begin

      @(posedge c_clk);
      req1_cmd_in = 4'b0010; // Set command for SUB operation
      req1_data_in = operand1_unsigned; // Operand 1
      @(negedge c_clk);
      req1_cmd_in = 4'b0000; // Reset command to default
      req1_data_in = operand2_unsigned; // Operand 2
      operand2_unsigned_temp = operand2_unsigned;

      @(negedge c_clk);
      while (out_resp1 !== 2'b01) begin
        if (clk_count >= 3 && req1_data_in == operand2_unsigned_temp) begin
          no_resp++;
          clk_count = 0;
          break;
        end

        @(negedge c_clk);
      end

      // Check result and display for SUBTRACT
      if (out_resp1 == 2'b10) begin 
        underflow_count++;
        $display("Underflow (SUB): %d - %d, Operand 1 is less than Operand 2", operand1_unsigned, operand2_unsigned);
      end else if (out_data1 !== operand1_unsigned - operand2_unsigned) begin
        // Check for error
        $display("Error (SUB): %d - %d = %d, but calculator output is %d", operand1_unsigned, operand2_unsigned, operand1_unsigned - operand2_unsigned, out_data1);
        error_count++;
      end else begin
        $display("Correct (SUB): %d - %d = %d", operand1_unsigned, operand2_unsigned, out_data1);
        correct_count++;
      end

    end
  end

  #6;

// Display final counts
  $display("Correct results: %d", correct_count);
  $display("Error results: %d", error_count);
  $display("Underflow results: %d", underflow_count);
  $display("No Response: %d", no_resp);
end

endmodule