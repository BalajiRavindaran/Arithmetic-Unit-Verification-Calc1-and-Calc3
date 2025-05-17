module calculator_tb;

  // Define test bench inputs
  logic c_clk;
  logic [1:0] out_resp1, out_resp2, out_resp3, out_resp4;
  logic [31:0] req1_data_in, req2_data_in, req3_data_in, req4_data_in;
  logic [3:0] req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
  logic [7:0] reset;

  // Define test bench outputs
  logic [31:0] out_data1, out_data2, out_data3, out_data4;

  // Instantiate calculator design module
  calc1_top calc_inst (
    .c_clk(c_clk),
    .out_resp1(out_resp1),
    .out_resp2(out_resp2),
    .out_resp3(out_resp3),
    .out_resp4(out_resp4),
    .req1_data_in(req1_data_in),
    .req2_data_in(req2_data_in),
    .req3_data_in(req3_data_in),
    .req4_data_in(req4_data_in),
    .req1_cmd_in(req1_cmd_in),
    .req2_cmd_in(req2_cmd_in),
    .req3_cmd_in(req3_cmd_in),
    .req4_cmd_in(req4_cmd_in),
    .reset(reset),
    .out_data1(out_data1),
    .out_data2(out_data2),
    .out_data3(out_data3),
    .out_data4(out_data4)
  );

  // Add your test bench logic here

  always begin
    c_clk = 1'b0;
    #5; // Toggle clock every 5 time units
    c_clk = 1'b1;
    #5;
  end

  // Reset handling logic
  initial begin
    reset = 8'b11111111; // Hold reset for 8 cycles
    #8;
    reset = 8'b00000000; // Release reset
    #10; // Wait for some cycles before sending commands
    // Now start sending commands and data
  end

  initial begin
    // Send initial commands and data after some cycles
    #10;
    // Example: Sending an 'Add' command with operands
    req1_cmd_in = 4'b0001; // Add command
    req1_data_in = 32'h0; // Operand1
    req2_data_in = 32'h1; // Operand2
    // Wait for response before sending next command
    #10;
    // Now send next command, and so on...
  end

  always @(posedge c_clk) begin
    // Example: Verify response and result data
    if (out_resp1 == 2'b01) begin // Check if response is successful
      $display("Add operation successful!");
      $display("Result: %h", out_data1);
    end
    // Add similar checks for other responses and result data
  end

endmodule