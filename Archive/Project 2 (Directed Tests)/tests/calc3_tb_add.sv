module calc3_tb_add;

   // Declarations
   logic [0:1] out_resp;
   logic [0:31] out_data;
   logic [0:3] req_cmd;
   logic [0:31] req_data;
   logic [0:4] req_d1, req_d2, req_r1;
   logic clk, reset;
    logic [0:1] req_tag;

   // Instantiate your DUT here
   calc3_top dut (
      .req1_tag(req_tag),
      .a_clk(clk), .b_clk(clk), .c_clk(clk), .reset(reset),
      .req1_cmd(req_cmd), .req1_d1(req_d1), .req1_d2(req_d2), .req1_r1(req_r1),
      .req1_data(req_data),
      .out1_resp(out_resp),
      .out1_data(out_data)
   );

   // Clock generation
   always begin
     clk = 1'b0;
     #5;
     clk = 1'b1;
     #5;
   end

   initial begin
     reset = 1'b1;
     #20;
     reset = 1'b0;
     #20;

resetAllInputPorts();

     // Step 1: Store the first value
     req_cmd = 4'b1001; // Store command
     req_data = 10;     // First value
     req_d1 = 1;        // Index of the first register
     #10;               // Wait for the command to process
     $display("Stored %0d in register %0d", req_data, req_d1);

     // Step 2: Store the second value
     req_cmd = 4'b1001; // Store command
     req_data = 15;     // Second value
     req_d1 = 2;        // Index of the second register
     #10;               // Wait for the command to process
     $display("Stored %0d in register %0d", req_data, req_d1);

     // Step 3: Perform addition
     req_cmd = 4'b0001; // ADD command
     req_d1 = 1;        // First register index
     req_d2 = 2;        // Second register index
     req_r1 = 3;        // Result register index
     #10;               // Wait for the command to process
     $display("Performed addition: Register %0d (value %0d) + Register %0d (value %0d)", req_d1, 10, req_d2, 15);

     // Step 4: Fetch the result
     req_cmd = 4'b1010; // Fetch command
     req_d1 = 3;        // Index of the result register
     #10;               // Wait for the command to process

     // Display the result
     if (out_resp == 2'b01) begin  // Check if the fetch was successful
         $display("Correctly fetched %0d from register %0d", out_data, req_d1);
     end else begin
         $display("Error in fetching result from register %0d", req_d1);
     end
   end

   task setAllInputPortsToZero();
       req_cmd = 0;
       req_d1 = 0;
       req_d2 = 0;
       req_r1 = 0;
       req_tag = 0;
       req_data = 0;
   endtask

endmodule
