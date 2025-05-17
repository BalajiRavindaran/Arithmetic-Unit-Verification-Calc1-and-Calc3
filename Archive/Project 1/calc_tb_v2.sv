module calculator_tb_v2;

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

  initial begin
    // Initialize clock
    c_clk = 1'b0;

    // Reset sequence
    reset = 8'b11111111;
    #8;
    reset = 8'b00000000;
    
    // Perform ADD operation
    req1_cmd_in = 4'b0101; // Command for ADD operation
    req1_data_in = 32'h01; // Operand 1 for ADD operation
    #4;
    req1_data_in = 32'h05;

    // Wait for response
    @(posedge c_clk);
    while (out_resp1 !== 2'b01) begin
      #1;
    end

    // Display result
    $display("%d, Added Output", out_data1);
  end

  // Clock generation
  always begin
    c_clk = ~c_clk;
    #(1); // Toggle clock every 1 time unit
  end

endmodule
