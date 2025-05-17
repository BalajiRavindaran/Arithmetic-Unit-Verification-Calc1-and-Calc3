module alu_sub_tb;

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

  int max_loop_value = 10; // 4294967295 Max Value

  int correct_count = 0;
  int error_count = 0;

  int overflow_count = 0;
  int underflow_count = 0;

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
  end

initial begin
  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset
 
     // Check result and display for SUBTRACT
        if (out_data1 !== operand1_unsigned - operand2_unsigned) begin
          // Check for Overflow
          if (out_resp1 === 2'b10) begin
            $display("Overflow (SUB): %d - %d = %d, calculator detected overflow", operand1_unsigned, operand2_unsigned, operand1_unsigned - operand2_unsigned);
            overflow_count++;
          end else begin
            $display("Error (SUB): %d - %d = %d, but calculator output is %d", operand1_unsigned, operand2_unsigned, operand1_unsigned - operand2_unsigned, out_data1);
            error_count++;
          end
        end else if (operand1_unsigned < operand2_unsigned) begin
          // Check for Underflow
          if (out_resp1 === 2'b10) begin
            $display("Underflow (SUB): %d - %d = %d, calculator detected underflow", operand1_unsigned, operand2_unsigned, operand1_unsigned - operand2_unsigned);
            underflow_count++;
          end else begin
            $display("Error (SUB): %d - %d = %d, but calculator output is %d", operand1_unsigned, operand2_unsigned, operand1_unsigned - operand2_unsigned, out_data1);
            error_count++;
          end
        end else begin
          $display("Correct (SUB): %d - %d = %d", operand1_unsigned, operand2_unsigned, out_data1);
          correct_count++;
        end

    #6;

// Display final counts
  $display("Correct results: %d", correct_count);
  $display("Error results: %d", error_count);
  $display("Overflow results: %d", overflow_count);
  $display("Underflow results: %d", underflow_count);
end

endmodule