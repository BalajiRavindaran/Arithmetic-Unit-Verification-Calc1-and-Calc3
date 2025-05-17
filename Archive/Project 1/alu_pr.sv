module alu_pr;

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

  int clk_count, clk_count_1, clk_count_2, clk_count_3, clk_count_4 = 0;
  time time_1, time_2, time_3, time_4 = 0;

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

  /////////////////////////////// ADD - ADD - ADD - ADD ///////////////////////////////////////

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
    
    clk_count = 0;
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

  /////////////////////////////// ADD - SUB - ADD - SUB ///////////////////////////////////////

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
    
    clk_count = 0;
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
    
    clk_count = 0;
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
    
    clk_count = 0;
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
    
    clk_count = 0;
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
endfunction
endmodule