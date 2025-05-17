//////////////////////////////////////////////////////////////////////////////
// Module Name: reset_sequence_tb
// Description: Testbench for the Calc1 Verification
// Authors: Nitish Sundarraj Balaji, Balaji Ravindaran, Adilmanzoor Kaliloor Rahman
// Company: Concordia University
// Date: March 09, 2024
//////////////////////////////////////////////////////////////////////////////

module calc1_testbench;

  // Inputs
  logic c_clk;
  logic [0:1] out_resp1, out_resp2, out_resp3, out_resp4;
  logic [0:31] req1_data_in, req2_data_in, req3_data_in, req4_data_in;
  logic [0:3] req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
  logic [0:7] reset;

  // Outputs
  logic [0:31] out_data1, out_data2, out_data3, out_data4;

  bit [0:31] operand1_unsigned = 7;
  bit [0:31] operand2_unsigned = 2;
  bit [0:31] operand2_unsigned_temp;

  int clk_count, clk_count_1, clk_count_2, clk_count_3, clk_count_4 = 0;
  time time_1, time_2, time_3, time_4 = 0;

  logic [3:0] operations[0:3] = '{4'b0001, 4'b0010, 4'b0101, 4'b0110};
  string operations_s[0:3] = '{"ADD", "SUB", "SLL", "SRR"};

  int max_loop_value = 200; // 4294967295 Max Value

  int correct_count = 0;
  int error_count = 0;
  int overflow_count = 0;
  int underflow_count = 0;
  int no_resp = 0;

  int max_shift_value = 31;

  //DUT
  calc1_top calc1 (

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

  // Clock Generation
  always begin
    c_clk = 1'b0;
    #6;
    c_clk = 1'b1;
    #6;
    clk_count++;
  end


// Reset Cycles
initial begin

  $display("PORT OPERATIONS TESTING");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  $display("PORT 1");

  @(posedge c_clk);
  req1_cmd_in = 4'b0000; // Set command for ADD operation
  req1_data_in = operand1_unsigned; // Operand 1
  @(negedge c_clk);
  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = operand2_unsigned; // Operand 2

  // Wait for response and display result
  @(negedge c_clk);
  while (out_resp1 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50 && out_resp1 !== 2'b01) begin
      $display("0000 (NO OP) opearation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data1, $time);
      break;
    end
  end

  reset_fn();

  if (out_resp1 == 2'b01) begin
    $display("0000 (NO OP) operation failed, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data1, $time);
  end

  for (int i=0; i<4; i++) begin

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
      if (clk_count >= 50 && out_resp1 !== 2'b01) begin
        $display("%b (%s) no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data1, $time);
        break;
      end
    end

    reset_fn();

    if (out_resp1 == 2'b01) begin
      $display("%b (%s) operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data1, $time);
    end
  end

  $display("PORT 2");

  @(posedge c_clk);
  req2_cmd_in = 4'b0000; // Set command for ADD operation
  req2_data_in = operand1_unsigned; // Operand 1
  @(negedge c_clk);
  req2_cmd_in = 4'b0000; // Reset command to default
  req2_data_in = operand2_unsigned; // Operand 2

  // Wait for response and display result
  @(negedge c_clk);
  while (out_resp2 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50 && out_resp2 !== 2'b01) begin
      $display("0000 (NO OP) opearation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data2, $time);
      break;
    end
  end

  reset_fn();

  if (out_resp2 == 2'b01) begin
    $display("0000 (NO OP) operation failed, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data2, $time);
  end

  for (int i=0; i<4; i++) begin

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
      if (clk_count >= 50 && out_resp2 !== 2'b01) begin
        $display("%b (%s) no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data2, $time);
        break;
      end
    end

    reset_fn();

    if (out_resp2 == 2'b01) begin
      $display("%b (%s) operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data2, $time);
    end
  end

  $display("PORT 3");

  @(posedge c_clk);
  req3_cmd_in = 4'b0000; // Set command for ADD operation
  req3_data_in = operand1_unsigned; // Operand 1
  @(negedge c_clk);
  req3_cmd_in = 4'b0000; // Reset command to default
  req3_data_in = operand2_unsigned; // Operand 2

  // Wait for response and display result
  @(negedge c_clk);
  while (out_resp3 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50 && out_resp3 !== 2'b01) begin
      $display("0000 (NO OP) opearation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data3, $time);
      break;
    end
  end

  reset_fn();

  if (out_resp3 == 2'b01) begin
    $display("0000 (NO OP) operation failed, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data3, $time);
  end

  for (int i=0; i<4; i++) begin

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
      if (clk_count >= 50 && out_resp3 !== 2'b01) begin
        $display("%b (%s) no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data3, $time);
        break;
      end
    end

    reset_fn();

    if (out_resp3 == 2'b01) begin
      $display("%b (%s) operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data3, $time);
    end
  end

  $display("PORT 4");

  @(posedge c_clk);
  req4_cmd_in = 4'b0000; // Set command for ADD operation
  req4_data_in = operand1_unsigned; // Operand 1
  @(negedge c_clk);
  req4_cmd_in = 4'b0000; // Reset command to default
  req4_data_in = operand2_unsigned; // Operand 2

  // Wait for response and display result
  @(negedge c_clk);
  while (out_resp4 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50 && out_resp4 !== 2'b01) begin
      $display("0000 (NO OP) opearation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data4, $time);
      break;
    end
  end

  reset_fn();

  if (out_resp4 == 2'b01) begin
    $display("0000 (NO OP) operation failed, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operand1_unsigned, operand2_unsigned, out_data4, $time);
  end

  for (int i=0; i<4; i++) begin

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
      if (clk_count >= 50 && out_resp4 !== 2'b01) begin
        $display("%b (%s) no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data4, $time);
        break;
      end
    end

    reset_fn();

    if (out_resp4 == 2'b01) begin
      $display("%b (%s) operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data4, $time);
    end
  end


  #12;

  $display("SEQUENTIAL OPERATIONS TESTING\n");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  // PIN 1
  $display("//////////// PIN 1 ////////////\n");

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
            $display("%b (%s) base operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data1, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp1 == 2'b01) begin
          $display("%b (%s) base operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data1, $time);
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
            $display("%b (%s) secondary operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data1, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp1 == 2'b01) begin
          $display("%b (%s) secondary operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data1, $time);
        end
    end
  end

  $display("//////////// PIN 2 ////////////\n");

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
            $display("%b (%s) base operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data2, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp2 == 2'b01) begin
          $display("%b (%s) base operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data2, $time);
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
            $display("%b (%s) secondary operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data2, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp2 == 2'b01) begin
          $display("%b (%s) secondary operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data2, $time);
        end
    end
  end

  // PIN 3
  $display("//////////// PIN 3 ////////////\n");

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
            $display("%b (%s) base operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data3, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp3 == 2'b01) begin
          $display("%b (%s) base operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data3, $time);
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
            $display("%b (%s) secondary operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data3, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp3 == 2'b01) begin
          $display("%b (%s) secondary operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data3, $time);
        end
    end
  end

  // PIN 4
  $display("//////////// PIN 4 ////////////\n");


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
            $display("%b (%s) base operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data4, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp4 == 2'b01) begin
          $display("%b (%s) base operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[i], operations_s[i], operand1_unsigned, operand2_unsigned, out_data4, $time);
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
            $display("%b (%s) secondary operation -- no responce, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data4, $time);
            break;
          end
        end

        reset_fn();

        if (out_resp4 == 2'b01) begin
          $display("%b (%s) secondary operation successful, IN 1: %d, IN 2: %d, OUT: %d, Time: %t", operations[j], operations_s[j], operand1_unsigned, operand2_unsigned, out_data4, $time);
        end
    end
  end


  #12;

  $display("FIRST COME FIRST SERVE TESTING\n");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  @(posedge c_clk);
  req1_cmd_in = 4'b0001; // Set command for ADD operation
  req1_data_in = operand1_unsigned; // Operand 1

  req2_cmd_in = 4'b0001; // Set command for ADD operation
  req2_data_in = operand1_unsigned; // Operand 1

  req3_cmd_in = 4'b0001; // Set command for ADD operation
  req3_data_in = operand1_unsigned; // Operand 1

  req4_cmd_in = 4'b0001; // Set command for ADD operation
  req4_data_in = operand1_unsigned; // Operand 1

  @(negedge c_clk);

  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = operand2_unsigned; // Operand 2

  req2_cmd_in = 4'b0000; // Reset command to default
  req2_data_in = operand2_unsigned; // Operand 2
      
  req3_cmd_in = 4'b0000; // Reset command to default
  req3_data_in = operand2_unsigned; // Operand 2

  req4_cmd_in = 4'b0000; // Reset command to default
  req4_data_in = operand2_unsigned; // Operand 2

  @(negedge c_clk);
  while (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 30 && (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01)) begin
        if (clk_count_1 == 0) begin
            clk_count_1 = clk_count;
            time_1 = $time;
        end else if (clk_count_2 == 0) begin
            clk_count_2 = clk_count;
            time_2 = $time;
        end else if (clk_count_3 == 0) begin
            clk_count_3 = clk_count;
            time_3 = $time;
        end else begin
            clk_count_4 = clk_count;
            time_4 = $time;
        end

    break;
    end else begin
        if (out_resp1 == 2'b01) begin
          clk_count_1 = clk_count;
          time_1 = $time;
        end
        if (out_resp2 == 2'b01) begin
          clk_count_2 = clk_count;
          time_2 = $time;
        end
        if (out_resp3 == 2'b01) begin
          clk_count_3 = clk_count;
          time_3 = $time;
        end
        if (out_resp4 == 2'b01) begin
          clk_count_4 = clk_count;
          time_4 = $time;
        end
    end
  end

  $display("Input 1: ADD, Input 2: ADD, Input 3: ADD, Input 4: ADD");

  if ("MAX" && clk_count_1 == 30) begin
    $display("Input 1 Cycles: MAX, Input 1 Time: %t", time_1);
  end else begin
    $display("Input 1 Cycles: %0d, Input 1 Time: %t", clk_count_1, time_1);
  end

  if ("MAX" && clk_count_2 == 30) begin
    $display("Input 2 Cycles: MAX, Input 2 Time: %t", time_2);
  end else begin
    $display("Input 2 Cycles: %0d, Input 2 Time: %t", clk_count_2, time_2);
  end

  if ("MAX" && clk_count_3 == 30) begin
    $display("Input 3 Cycles: MAX, Input 3 Time: %t", time_3);
  end else begin
    $display("Input 3 Cycles: %0d, Input 3 Time: %t", clk_count_3, time_3);
  end

  if ("MAX" && clk_count_4 == 30) begin
    $display("Input 4 Cycles: MAX, Input 4 Time: %t", time_4);
  end else begin
    $display("Input 4 Cycles: %0d, Input 4 Time: %t", clk_count_4, time_4);
  end

  reset_fn();

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  @(posedge c_clk);
  req1_cmd_in = 4'b0001; // Set command for ADD operation
  req1_data_in = operand1_unsigned; // Operand 1

  req2_cmd_in = 4'b0010; // Set command for ADD operation
  req2_data_in = operand1_unsigned; // Operand 1

  req3_cmd_in = 4'b0001; // Set command for ADD operation
  req3_data_in = operand1_unsigned; // Operand 1

  req4_cmd_in = 4'b0010; // Set command for ADD operation
  req4_data_in = operand1_unsigned; // Operand 1

  @(negedge c_clk);

  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = operand2_unsigned; // Operand 2

  req2_cmd_in = 4'b0000; // Reset command to default
  req2_data_in = operand2_unsigned; // Operand 2
      
  req3_cmd_in = 4'b0000; // Reset command to default
  req3_data_in = operand2_unsigned; // Operand 2

  req4_cmd_in = 4'b0000; // Reset command to default
  req4_data_in = operand2_unsigned; // Operand 2

  @(negedge c_clk);
  while (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 30 && (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01)) begin
        if (clk_count_1 == 0) begin
            clk_count_1 = clk_count;
            time_1 = $time;
        end else if (clk_count_2 == 0) begin
            clk_count_2 = clk_count;
            time_2 = $time;
        end else if (clk_count_3 == 0) begin
            clk_count_3 = clk_count;
            time_3 = $time;
        end else begin
            clk_count_4 = clk_count;
            time_4 = $time;
        end
    
    break;
    end else begin
        if (out_resp1 == 2'b01) begin
          clk_count_1 = clk_count;
          time_1 = $time;
        end
        if (out_resp2 == 2'b01) begin
          clk_count_2 = clk_count;
          time_2 = $time;
        end
        if (out_resp3 == 2'b01) begin
          clk_count_3 = clk_count;
          time_3 = $time;
        end
        if (out_resp4 == 2'b01) begin
          clk_count_4 = clk_count;
          time_4 = $time;
        end
    end
  end

  $display("Input 1: ADD, Input 2: SUB, Input 3: ADD, Input 4: SUB");

  if ("MAX" && clk_count_1 == 30) begin
    $display("Input 1 Cycles: MAX, Input 1 Time: %t", time_1);
  end else begin
    $display("Input 1 Cycles: %0d, Input 1 Time: %t", clk_count_1, time_1);
  end

  if ("MAX" && clk_count_2 == 30) begin
    $display("Input 2 Cycles: MAX, Input 2 Time: %t", time_2);
  end else begin
    $display("Input 2 Cycles: %0d, Input 2 Time: %t", clk_count_2, time_2);
  end

  if ("MAX" && clk_count_3 == 30) begin
    $display("Input 3 Cycles: MAX, Input 3 Time: %t", time_3);
  end else begin
    $display("Input 3 Cycles: %0d, Input 3 Time: %t", clk_count_3, time_3);
  end

  if ("MAX" && clk_count_4 == 30) begin
    $display("Input 4 Cycles: MAX, Input 4 Time: %t", time_4);
  end else begin
    $display("Input 4 Cycles: %0d, Input 4 Time: %t", clk_count_4, time_4);
  end

  /////////////////////////////// SUB - SLL - SUB - SLL ///////////////////////////////////////

  reset_fn();

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  @(posedge c_clk);
  req1_cmd_in = 4'b0010; // Set command for ADD operation
  req1_data_in = operand1_unsigned; // Operand 1

  req2_cmd_in = 4'b0101; // Set command for ADD operation
  req2_data_in = operand1_unsigned; // Operand 1

  req3_cmd_in = 4'b0010; // Set command for ADD operation
  req3_data_in = operand1_unsigned; // Operand 1

  req4_cmd_in = 4'b0101; // Set command for ADD operation
  req4_data_in = operand1_unsigned; // Operand 1

  @(negedge c_clk);

  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = operand2_unsigned; // Operand 2

  req2_cmd_in = 4'b0000; // Reset command to default
  req2_data_in = operand2_unsigned; // Operand 2
      
  req3_cmd_in = 4'b0000; // Reset command to default
  req3_data_in = operand2_unsigned; // Operand 2

  req4_cmd_in = 4'b0000; // Reset command to default
  req4_data_in = operand2_unsigned; // Operand 2

  @(negedge c_clk);
  while (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50 && (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01)) begin
        if (clk_count_1 == 0) begin
            clk_count_1 = clk_count;
            time_1 = $time;
        end else if (clk_count_2 == 0) begin
            clk_count_2 = clk_count;
            time_2 = $time;
        end else if (clk_count_3 == 0) begin
            clk_count_3 = clk_count;
            time_3 = $time;
        end else begin
            clk_count_4 = clk_count;
            time_4 = $time;
        end
    
    break;
    end else begin
        if (out_resp1 == 2'b01) begin
          clk_count_1 = clk_count;
          time_1 = $time;
        end
        if (out_resp2 == 2'b01) begin
          clk_count_2 = clk_count;
          time_2 = $time;
        end
        if (out_resp3 == 2'b01) begin
          clk_count_3 = clk_count;
          time_3 = $time;
        end
        if (out_resp4 == 2'b01) begin
          clk_count_4 = clk_count;
          time_4 = $time;
        end
    end
  end

  $display("Input 1: SUB, Input 2: SLL, Input 3: SUB, Input 4: SLL");

  if ("MAX" && clk_count_1 == 50) begin
    $display("Input 1 Cycles: MAX, Input 1 Time: %t", time_1);
  end else begin
    $display("Input 1 Cycles: %0d, Input 1 Time: %t", clk_count_1, time_1);
  end

  if ("MAX" && clk_count_2 == 50) begin
    $display("Input 2 Cycles: MAX, Input 2 Time: %t", time_2);
  end else begin
    $display("Input 2 Cycles: %0d, Input 2 Time: %t", clk_count_2, time_2);
  end

  if ("MAX" && clk_count_3 == 50) begin
    $display("Input 3 Cycles: MAX, Input 3 Time: %t", time_3);
  end else begin
    $display("Input 3 Cycles: %0d, Input 3 Time: %t", clk_count_3, time_3);
  end

  if ("MAX" && clk_count_4 == 50) begin
    $display("Input 4 Cycles: MAX, Input 4 Time: %t", time_4);
  end else begin
    $display("Input 4 Cycles: %0d, Input 4 Time: %t", clk_count_4, time_4);
  end

  /////////////////////////////// SLL - SRR - SLL - SRR ///////////////////////////////////////

  reset_fn();

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  @(posedge c_clk);
  req1_cmd_in = 4'b0101; // Set command for ADD operation
  req1_data_in = operand1_unsigned; // Operand 1

  req2_cmd_in = 4'b0110; // Set command for ADD operation
  req2_data_in = operand1_unsigned; // Operand 1

  req3_cmd_in = 4'b0101; // Set command for ADD operation
  req3_data_in = operand1_unsigned; // Operand 1

  req4_cmd_in = 4'b0110; // Set command for ADD operation
  req4_data_in = operand1_unsigned; // Operand 1

  @(negedge c_clk);

  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = operand2_unsigned; // Operand 2

  req2_cmd_in = 4'b0000; // Reset command to default
  req2_data_in = operand2_unsigned; // Operand 2
      
  req3_cmd_in = 4'b0000; // Reset command to default
  req3_data_in = operand2_unsigned; // Operand 2

  req4_cmd_in = 4'b0000; // Reset command to default
  req4_data_in = operand2_unsigned; // Operand 2

  @(negedge c_clk);
  while (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50 && (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01)) begin
        if (clk_count_1 == 0) begin
            clk_count_1 = clk_count;
            time_1 = $time;
        end else if (clk_count_2 == 0) begin
            clk_count_2 = clk_count;
            time_2 = $time;
        end else if (clk_count_3 == 0) begin
            clk_count_3 = clk_count;
            time_3 = $time;
        end else begin
            clk_count_4 = clk_count;
            time_4 = $time;
        end
    
    break;
    end else begin
        if (out_resp1 == 2'b01) begin
          clk_count_1 = clk_count;
          time_1 = $time;
        end
        if (out_resp2 == 2'b01) begin
          clk_count_2 = clk_count;
          time_2 = $time;
        end
        if (out_resp3 == 2'b01) begin
          clk_count_3 = clk_count;
          time_3 = $time;
        end
        if (out_resp4 == 2'b01) begin
          clk_count_4 = clk_count;
          time_4 = $time;
        end
    end
  end

  $display("Input 1: SLL, Input 2: SRR, Input 3: SLL, Input 4: SRR");

  if ("MAX" && clk_count_1 == 50) begin
    $display("Input 1 Cycles: MAX, Input 1 Time: %t", time_1);
  end else begin
    $display("Input 1 Cycles: %0d, Input 1 Time: %t", clk_count_1, time_1);
  end

  if ("MAX" && clk_count_2 == 50) begin
    $display("Input 2 Cycles: MAX, Input 2 Time: %t", time_2);
  end else begin
    $display("Input 2 Cycles: %0d, Input 2 Time: %t", clk_count_2, time_2);
  end

  if ("MAX" && clk_count_3 == 50) begin
    $display("Input 3 Cycles: MAX, Input 3 Time: %t", time_3);
  end else begin
    $display("Input 3 Cycles: %0d, Input 3 Time: %t", clk_count_3, time_3);
  end

  if ("MAX" && clk_count_4 == 50) begin
    $display("Input 4 Cycles: MAX, Input 4 Time: %t", time_4);
  end else begin
    $display("Input 4 Cycles: %0d, Input 4 Time: %t", clk_count_4, time_4);
  end

  /////////////////////////////// SRR - ADD - SRR - ADD ///////////////////////////////////////

  reset_fn();

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  @(posedge c_clk);
  req1_cmd_in = 4'b0110; // Set command for ADD operation
  req1_data_in = operand1_unsigned; // Operand 1

  req2_cmd_in = 4'b0001; // Set command for ADD operation
  req2_data_in = operand1_unsigned; // Operand 1

  req3_cmd_in = 4'b0110; // Set command for ADD operation
  req3_data_in = operand1_unsigned; // Operand 1

  req4_cmd_in = 4'b0001; // Set command for ADD operation
  req4_data_in = operand1_unsigned; // Operand 1

  @(negedge c_clk);

  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = operand2_unsigned; // Operand 2

  req2_cmd_in = 4'b0000; // Reset command to default
  req2_data_in = operand2_unsigned; // Operand 2
      
  req3_cmd_in = 4'b0000; // Reset command to default
  req3_data_in = operand2_unsigned; // Operand 2

  req4_cmd_in = 4'b0000; // Reset command to default
  req4_data_in = operand2_unsigned; // Operand 2

  @(negedge c_clk);
  while (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 30 && (out_resp1 !== 2'b01 || out_resp2 !== 2'b01 || out_resp3 !== 2'b01 || out_resp4 !== 2'b01)) begin
        if (clk_count_1 == 0) begin
            clk_count_1 = clk_count;
            time_1 = $time;
        end else if (clk_count_2 == 0) begin
            clk_count_2 = clk_count;
            time_2 = $time;
        end else if (clk_count_3 == 0) begin
            clk_count_3 = clk_count;
            time_3 = $time;
        end else begin
            clk_count_4 = clk_count;
            time_4 = $time;
        end
    
    break;
    end else begin
        if (out_resp1 == 2'b01) begin
          clk_count_1 = clk_count;
          time_1 = $time;
        end
        if (out_resp2 == 2'b01) begin
          clk_count_2 = clk_count;
          time_2 = $time;
        end
        if (out_resp3 == 2'b01) begin
          clk_count_3 = clk_count;
          time_3 = $time;
        end
        if (out_resp4 == 2'b01) begin
          clk_count_4 = clk_count;
          time_4 = $time;
        end
    end
  end

  $display("Input 1: SRR, Input 2: ADD, Input 3: SRR, Input 4: ADD");

  if ("MAX" && clk_count_1 == 30) begin
    $display("Input 1 Cycles: MAX, Input 1 Time: %t", time_1);
  end else begin
    $display("Input 1 Cycles: %0d, Input 1 Time: %t", clk_count_1, time_1);
  end

  if ("MAX" && clk_count_2 == 30) begin
    $display("Input 2 Cycles: MAX, Input 2 Time: %t", time_2);
  end else begin
    $display("Input 2 Cycles: %0d, Input 2 Time: %t", clk_count_2, time_2);
  end

  if ("MAX" && clk_count_3 == 30) begin
    $display("Input 3 Cycles: MAX, Input 3 Time: %t", time_3);
  end else begin
    $display("Input 3 Cycles: %0d, Input 3 Time: %t", clk_count_3, time_3);
  end

  if ("MAX" && clk_count_4 == 30) begin
    $display("Input 4 Cycles: MAX, Input 4 Time: %t", time_4);
  end else begin
    $display("Input 4 Cycles: %0d, Input 4 Time: %t", clk_count_4, time_4);
  end

  reset_fn();
  #12;

  $display("ADD OPERATION TESTING");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset
 
    // Addition Operation Test (REQ1)
  for (operand1_unsigned = 0; operand1_unsigned <= max_loop_value; operand1_unsigned++) begin
    for (operand2_unsigned = 0; operand2_unsigned <= max_loop_value; operand2_unsigned++) begin
      @(posedge c_clk);
      req1_cmd_in = 4'b0001; // Set command for ADD operation
      req1_data_in = operand1_unsigned; // Operand 1
      @(negedge c_clk);
      req1_cmd_in = 4'b0000; // Reset command to default
      req1_data_in = operand2_unsigned; // Operand 2

      // Wait for response and display result
      @(negedge c_clk);
      while (out_resp1 !== 2'b01) begin
        @(negedge c_clk);
        if (out_resp1 == 2'b10) begin
          overflow_count++;
          break;
        end
      end

      // Display result and check correctness
      if (out_resp1 == 2'b01) begin
        if (out_data1 !== operand1_unsigned + operand2_unsigned) begin
          //$display("Error: %d + %d = %d", operand1_unsigned, operand2_unsigned, out_data2);
          error_count++;
        end else begin
          correct_count++;
          //$display("Correct: %d + %d = %d", operand1_unsigned, operand2_unsigned, out_data2);
        end
      end
    end
  end

// Display final counts
  $display("1 - %d Count\n", max_loop_value);
  $display("Correct results: %d", correct_count);
  $display("Error results: %d", error_count);
  $display("Overflow results: %d", overflow_count);

  reset_fn();
  #12;

  $display("SUB OPERATION TESTING");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset

  for (operand1_unsigned = 0; operand1_unsigned <= max_loop_value; operand1_unsigned++) begin
    for (operand2_unsigned = 0; operand2_unsigned <= max_loop_value; operand2_unsigned++) begin

      @(posedge c_clk);
      req1_cmd_in = 4'b0010; // Set command for SUB operation
      req1_data_in = operand1_unsigned; // Operand 1
      @(negedge c_clk);
      req1_cmd_in = 4'b0000; // Reset command to default
      req1_data_in = operand2_unsigned; // Operand 2
      operand2_unsigned_temp = operand2_unsigned;

      @(negedge c_clk);
      while (out_resp1 !== 2'b01) begin
        if (clk_count > 5 && req1_data_in == operand2_unsigned_temp) begin
          no_resp++;
          clk_count = 0;
          break;
        end

        @(negedge c_clk);
      end

      // Check result and display for SUBTRACT
      if (out_resp1 == 2'b10) begin 
        underflow_count++;
      end else if (out_data1 !== operand1_unsigned - operand2_unsigned) begin
        // Check for error
        //$display("Error: %d - %d = %d", operand1_unsigned, operand2_unsigned, out_data1);
        error_count++;
      end else begin
        correct_count++;
        //$display("Correct: %d - %d = %d", operand1_unsigned, operand2_unsigned, out_data1);
      end
    end
  end

// Display final counts
  $display("1 - %d Count\n", max_loop_value);
  $display("Correct results: %d", correct_count);
  $display("Error results: %d", error_count);
  $display("Underflow results: %d", underflow_count);
  $display("No Response: %d", no_resp);

  reset_fn();

  $display("SLL OPERATIONS TESTING");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000; // Release reset
 
  // Shift Left Logic Operation Test (REQ1)
  for (operand1_unsigned = 0; operand1_unsigned <= max_loop_value; operand1_unsigned++) begin
    for (operand2_unsigned = 0; operand2_unsigned <= max_shift_value; operand2_unsigned++) begin
      @(posedge c_clk);
      req1_cmd_in = 4'b0101; // Set command for SLL operation
      req1_data_in = operand1_unsigned; // Operand 1
      @(negedge c_clk);
      req1_cmd_in = 4'b0000; // Reset command to default
      req1_data_in = operand2_unsigned; // Operand 2

      // Wait for response and display result
      @(negedge c_clk);
      while (out_resp1 !== 2'b01) begin
        @(negedge c_clk);
      end

      // Check result and display for SLL
      if (out_data1 !== (operand1_unsigned << (operand2_unsigned & max_shift_value))) begin
        //$display("Error: %d SLL %d = %d", operand1_unsigned, operand2_unsigned, out_data1);
        error_count++;
      end else begin
        correct_count++;
      end
    end
  end

  $display("1 - %d Count\n", max_loop_value);
  $display("Correct results: %d", correct_count);
  $display("Error results: %d", error_count);

  reset_fn();

  $display("SRR OPERATIONS TESTING");

  for (int operand1_unsigned = 0; operand1_unsigned <= max_loop_value; operand1_unsigned++) begin
    for (int operand2_unsigned = 0; operand2_unsigned <= max_shift_value; operand2_unsigned++) begin
      @(posedge c_clk);
      req2_cmd_in = 4'b0110; // Set command for SRL operation
      req2_data_in = operand1_unsigned; // Operand 1
      @(negedge c_clk);
      req2_cmd_in = 4'b0000; // Reset command to default
      req2_data_in = operand2_unsigned; // Operand 2

      // Wait for response and display result
      @(negedge c_clk);
      while (out_resp2 !== 2'b01) begin
        @(negedge c_clk);
      end

      // Check result and display for SRL
      if (out_data2 !== (operand1_unsigned >> (operand2_unsigned & max_shift_value))) begin
        //$display("Error: %d SRR %d = %d", operand1_unsigned, operand2_unsigned, out_data1);
        error_count++;
      end else begin
        correct_count++;
      end
    end
  end
    
  $display("1 - %d Count\n", max_loop_value);
  $display("Correct results: %d", correct_count);
  $display("Error results: %d", error_count);

  reset_fn();

  ////////////////////// EDGE ////////////////////

  // SLL MAX
  $display("EDGE CASES");
  $display("SLL MAX");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000;

  operand1_unsigned = '1;
  operand2_unsigned = '1;

  @(posedge c_clk);
    req1_cmd_in = 4'b0101; // Set command for SUB operation
    req1_data_in = operand1_unsigned; // Operand 1
  @(negedge c_clk);
    req1_cmd_in = 4'b0000; // Reset command to default
    req1_data_in = operand2_unsigned; // Operand 2

  // Wait for response and display result
  @(negedge c_clk);
  while (out_resp1 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50) begin
      $display("no response");
      break;
    end
  end

  if (out_resp1 == 2'b01) begin
    if (out_data1 !== (operand1_unsigned << (operand2_unsigned & 32))) begin
      $display("Error (SLL): %d << %d = %d, but calculator output is %d", operand1_unsigned, operand2_unsigned & 32, operand1_unsigned << (operand2_unsigned & 32), out_data1);
      error_count++;
    end else begin
      $display("Correct (SLL): %d << %d = %d", operand1_unsigned, operand2_unsigned & 33, out_data1);
      correct_count++;
    end
  end

  reset_fn();

  // SRR MAX
  $display("SRR MAX");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000;

  @(posedge c_clk);
    req1_cmd_in = 4'b0110; // Set command for SUB operation
    req1_data_in = operand1_unsigned; // Operand 1
  @(negedge c_clk);
    req1_cmd_in = 4'b0000; // Reset command to default
    req1_data_in = operand2_unsigned; // Operand 2

  // Wait for response and display result
  @(negedge c_clk);
  while (out_resp1 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 50) begin
      $display("no response");
      break;
    end
  end

  if (out_resp1 == 2'b01) begin
    if (out_data1 !== (operand1_unsigned >> (operand2_unsigned & 32))) begin
      $display("Error (SRL): %d >> %d = %d, but calculator output is 1", operand1_unsigned, operand2_unsigned & 32, operand1_unsigned >> (operand2_unsigned & 32));
      error_count++;
    end else begin
      $display("Correct (SRL): %d >> %d = %d", operand1_unsigned, operand2_unsigned & 32, out_data1);
      correct_count++;
    end
  end

  reset_fn();

  // ADD MAX
  $display("ADD MAX");

  @(posedge c_clk);
  req1_cmd_in = 4'b0001; // Set command for ADD operation
  req1_data_in = operand1_unsigned; // Operand 1
  @(negedge c_clk);
  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = 1; // Operand 2

  // Wait for response and display result
  @(negedge c_clk);
  while (out_resp1 !== 2'b01) begin
    @(negedge c_clk);
    if (out_resp1 == 2'b10) begin
      overflow_count++;
      break;
    end
    if (clk_count >= 50) begin
      $display("Max clk count reached, IN 1: %d, IN 2: %d, OUT: %d", operand1_unsigned, 1, out_data1);
      break;
    end
  end

  $display("Overflow results: %d, OUT: %d", overflow_count, out_data1);

  reset_fn();

  // SRR MAX
  $display("RESET TRIGGER");

  @(posedge c_clk);
  reset = 8'b01111111; // Hold reset for 8 cycles
  req1_cmd_in = 4'b0001; // Set command for ADD operation
  req1_data_in = 5; // Operand 1
  @(negedge c_clk);
  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = 1; // Operand 2
  reset = 8'b00000000;

  @(negedge c_clk);
  while (out_resp1 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 5) begin
      $display("Max clk count reached, IN 1: %d, IN 2: %d, OUT: %d", 5, 1, out_data1);
      break;
    end
  end

  if (out_resp1 == 2'b01) begin
    $display("Data Received: %d", out_data1);
  end

  reset_fn();

  // SRR MAX
  $display("INVALID TRIGGER");

  for (int i = 0; i < 8; i++) begin
    @(posedge c_clk);
    reset = 8'b01111111; // Hold reset for 8 cycles
  end

  reset = 8'b00000000;

  @(posedge c_clk);
  req1_cmd_in = 4'b1111; // Set command for ADD operation
  req1_data_in = 5; // Operand 1
  @(negedge c_clk);
  req1_cmd_in = 4'b0000; // Reset command to default
  req1_data_in = 1; // Operand 2

  @(negedge c_clk);
  while (out_resp1 !== 2'b01) begin
    @(negedge c_clk);
    if (clk_count >= 5) begin
      $display("Max clk count reached, IN 1: %d, IN 2: %d, OUT: %d", 5, 1, out_data1);
      break;
    end
  end

  if (out_resp1 == 2'b01) begin
    $display("Data Received: %d", out_data1);
  end

  reset_fn();

end

function void reset_fn;
  // Function body
  clk_count = 0;
  clk_count_1 = 0;
  clk_count_2 = 0;
  clk_count_3 = 0;
  clk_count_4 = 0;
  time_1 = 0;
  time_2 = 0;
  time_3 = 0;
  time_4 = 0;
  correct_count = 0;
  error_count = 0;
  overflow_count = 0;
  underflow_count = 0;
  no_resp = 0;
endfunction

endmodule