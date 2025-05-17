module alu_comb;

  // Define test bench inputs
  logic c_clk;
  logic [0:1] out_resp1, out_resp2, out_resp3, out_resp4;
  logic [0:31] req1_data_in, req2_data_in, req3_data_in, req4_data_in;
  logic [0:3] req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
  logic [0:7] reset;

  // Define test bench outputs
  logic [0:31] out_data1, out_data2, out_data3, out_data4;

  bit [0:31] operand1_unsigned = 5;
  bit [0:31] operand2_unsigned = 5;

  int clk_count = 0;

  logic [3:0] operations[0:3] = '{4'b0001, 4'b0010, 4'b0101, 4'b0110};
  string operations_s[0:3] = '{"ADD", "SUB", "SLL", "SRR"};

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

  // PIN 1
  $display("//////////// PIN 1 ////////////");

  for (int i = 0; i < 4; i++) begin
    for (int j = 0; j < 4; j++) begin
        @(posedge c_clk);
        req1_cmd_in = operations[i]; // Set command for ADD operation
        req1_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req1_cmd_in = 4'b0000; // Reset command to default
        req1_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp1 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp1 !== 2'b01) begin
            $display("%b (%s) base operation -- no responce", operations[i], operations_s[i]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp1 == 2'b01) begin
          $display("%b (%s) base operation successful", operations[i], operations_s[i]);
        end

        @(posedge c_clk);
        req1_cmd_in = operations[j]; // Set command for ADD operation
        req1_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req1_cmd_in = 4'b0000; // Reset command to default
        req1_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp1 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp1 !== 2'b01) begin
            $display("%b (%s) secondary operation -- no responce", operations[j], operations_s[j]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp1 == 2'b01) begin
          $display("%b (%s) secondary operation successful", operations[j], operations_s[j]);
        end
    end
  end

  $display("//////////// PIN 2 ////////////");

  // PIN 2

  for (int i = 0; i < 4; i++) begin
    for (int j = 0; j < 4; j++) begin
        @(posedge c_clk);
        req2_cmd_in = operations[i]; // Set command for ADD operation
        req2_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req2_cmd_in = 4'b0000; // Reset command to default
        req2_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp2 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp2 !== 2'b01) begin
            $display("%b (%s) base operation -- no responce", operations[i], operations_s[i]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp2 == 2'b01) begin
          $display("%b (%s) base operation successful", operations[i], operations_s[i]);
        end

        @(posedge c_clk);
        req2_cmd_in = operations[j]; // Set command for ADD operation
        req2_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req2_cmd_in = 4'b0000; // Reset command to default
        req2_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp2 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp2 !== 2'b01) begin
            $display("%b (%s) secondary operation -- no responce", operations[j], operations_s[j]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp2 == 2'b01) begin
          $display("%b (%s) secondary operation successful", operations[j], operations_s[j]);
        end
    end
  end

  // PIN 3
  $display("//////////// PIN 3 ////////////");

  for (int i = 0; i < 4; i++) begin
    for (int j = 0; j < 4; j++) begin
        @(posedge c_clk);
        req3_cmd_in = operations[i]; // Set command for ADD operation
        req3_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req3_cmd_in = 4'b0000; // Reset command to default
        req3_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp3 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp3 !== 2'b01) begin
            $display("%b (%s) base operation -- no responce", operations[i], operations_s[i]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp3 == 2'b01) begin
          $display("%b (%s) base operation successful", operations[i], operations_s[i]);
        end

        @(posedge c_clk);
        req3_cmd_in = operations[j]; // Set command for ADD operation
        req3_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req3_cmd_in = 4'b0000; // Reset command to default
        req3_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp3 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp3 !== 2'b01) begin
            $display("%b (%s) secondary operation -- no responce", operations[j], operations_s[j]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp3 == 2'b01) begin
          $display("%b (%s) secondary operation successful", operations[j], operations_s[j]);
        end
    end
  end

  // PIN 4
  $display("//////////// PIN 4 ////////////");

  for (int i = 0; i < 4; i++) begin
    for (int j = 0; j < 4; j++) begin
        @(posedge c_clk);
        req4_cmd_in = operations[i]; // Set command for ADD operation
        req4_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req4_cmd_in = 4'b0000; // Reset command to default
        req4_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp4 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp4 !== 2'b01) begin
            $display("%b (%s) base operation -- no responce", operations[i], operations_s[i]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp4 == 2'b01) begin
          $display("%b (%s) base operation successful", operations[i], operations_s[i]);
        end

        @(posedge c_clk);
        req4_cmd_in = operations[j]; // Set command for ADD operation
        req4_data_in = operand1_unsigned; // Operand 1
        @(negedge c_clk);
        req4_cmd_in = 4'b0000; // Reset command to default
        req4_data_in = operand2_unsigned; // Operand 2

        // Wait for response and display result
        @(negedge c_clk);
        while (out_resp4 !== 2'b01) begin
          @(negedge c_clk);
          if (clk_count >= 100 && out_resp4 !== 2'b01) begin
            $display("%b (%s) secondary operation -- no responce", operations[j], operations_s[j]);
            break;
          end
        end

        clk_count = 0;

        if (out_resp4 == 2'b01) begin
          $display("%b (%s) secondary operation successful", operations[j], operations_s[j]);
        end
    end
  end

end

endmodule