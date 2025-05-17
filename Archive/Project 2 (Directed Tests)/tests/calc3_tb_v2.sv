module calc3_tb_v2;

   // Define arrayed structures for handling multiple ports
   logic [0:1] out_resp[4], out_tag[4];
   logic [0:31] out_data[4];
   logic [0:3] req_cmd[4], req_d1[4], req_d2[4], req_r1[4];
   logic [0:1] req_tag[4];
   logic [0:31] req_data[4];

   logic clk, reset;
   calc3_top dut (
      .req1_tag(req_tag[0]), .req2_tag(req_tag[1]), .req3_tag(req_tag[2]), .req4_tag(req_tag[3]),
      .a_clk(clk), .b_clk(clk), .c_clk(clk), .reset(reset),
      .req1_cmd(req_cmd[0]), .req1_d1(req_d1[0]), .req1_d2(req_d2[0]), .req1_r1(req_r1[0]),
      .req2_cmd(req_cmd[1]), .req2_d1(req_d1[1]), .req2_d2(req_d2[1]), .req2_r1(req_r1[1]),
      .req3_cmd(req_cmd[2]), .req3_d1(req_d1[2]), .req3_d2(req_d2[2]), .req3_r1(req_r1[2]),
      .req4_cmd(req_cmd[3]), .req4_d1(req_d1[3]), .req4_d2(req_d2[3]), .req4_r1(req_r1[3]),
      .req1_data(req_data[0]), .req2_data(req_data[1]), .req3_data(req_data[2]), .req4_data(req_data[3]),
      .out1_resp(out_resp[0]), .out2_resp(out_resp[1]), .out3_resp(out_resp[2]), .out4_resp(out_resp[3]),
      .out1_data(out_data[0]), .out2_data(out_data[1]), .out3_data(out_data[2]), .out4_data(out_data[3]),
      .out1_tag(out_tag[0]), .out2_tag(out_tag[1]), .out3_tag(out_tag[2]), .out4_tag(out_tag[3])
   );

   // Clock definition
   always begin
     clk = 1'b0;
     #20;
     clk = 1'b1;
     #20;
   end

    int initial_values[16] = '{default:0};
    int src_reg1, src_reg2, dst_reg, shift_amount;
    int tag_counter[4]; // Array to keep track of tags for each port
    int tag_counter2 = 0; // Tag counter for sequential operations
    int result_index = 0; // Index to store the result of an operation

   initial begin
     reset = 1'b1;
     #140;
     reset = 1'b0;

     // Reset all ports
     setAllInputPortsToZero();
     #100;
      $display("STORE AND FETCH TESTS");
     // Store and fetch tests across all ports
     foreach (req_cmd[i]) begin
       $display("Starting store and fetch tests for Port %0d", i+1);

       // Store values in all registers
       for (int j = 0; j < 16; j++) begin
         @(posedge clk);
         req_cmd[i] = 4'b1001;  // Store command
         req_d1[i] = 0;         // Ignored for store
         req_d2[i] = 0;         // Ignored for store
         req_r1[i] = j;         // Register to store
         req_tag[i] = j % 4;    // Loop around tags for four ports
         req_data[i] = j;       // Example data to store
         wait (out_tag[i] == req_tag[i] && out_resp[i] == 2'b01);
         @(negedge clk);
         resetInputPort(i);
       end

       // Fetch and verify values from all registers
       for (int j = 0; j < 16; j++) begin
         @(posedge clk);
         req_cmd[i] = 4'b1010;  // Fetch command
         req_d1[i] = j;         // Register to fetch from
         req_tag[i] = j % 4;    // Loop around tags for four ports
         wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
         @(negedge clk);
         if (out_data[i] == j) begin
           $display("Port %0d - Data from register %d: %d, correct.", i+1, j, out_data[i]);
         end else begin
           $display("Port %0d - Error: Data from register %d: %d, expected: %d.", i+1, j, out_data[i], j);
         resetInputPort(i);
         end

       $display("Store and fetch tests completed for Port %0d.", i+1);
       end
   

   // Reset all ports
     setAllInputPortsToZero();
     #100;

     $display("BRANCH TESTS");

      // Branch tests across all ports

      // Test Branch if Zero
     @(posedge clk);
     req_cmd[i] = 4'b1001; // Store zero to trigger branch
     req_d1[i] = 5;
     req_data[i] = 0; // Data to store (zero)
     req_r1[i] = 5;
     req_tag[i] = 0;
     wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
     @(negedge clk);
     resetInputPort(i);

     @(posedge clk);
     req_cmd[i] = 4'b1100; // Branch if Zero
     req_d1[i] = 5;
     req_r1[i] = 0; // Not used
     req_tag[i] = 1;
     wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
     @(negedge clk);
     resetInputPort(i);

     // Command that should be skipped
     @(posedge clk);
     req_cmd[i] = 4'b1001; // Store command that should be skipped
     req_r1[i] = 6;
     req_data[i] = 123; // Arbitrary data
     req_d1[i] = 6;
     req_tag[i] = 2;
     wait (out_resp[i] == 2'b11 && out_tag[i] == req_tag[i]); // Check if this command is skipped
     @(negedge clk);
     if (out_resp[i] == 2'b11) begin
         $display("Command skipped correctly.");
     end else begin
         $display("Error: Command was not skipped as expected.");
     end
     resetInputPort(i);

     // Fetch and verify if register 6 was not modified
     @(posedge clk);
     req_cmd[i] = 4'b1010; // Fetch command to verify skipping
     req_d1[i] = 6;
     req_tag[i] = 3;
     wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
     @(negedge clk);
     if (out_data[i] != 123) begin
         $display("Correct: Register 6 was not modified. %d", out_data[i]);
     end else begin
         $display("Error: Register 6 was modified. %d", out_data[i]);
     end
     resetInputPort(i);

     // Branch if Equal
     @(posedge clk);
      req_cmd[i] = 4'b1001; // Store value to trigger branch
      req_d1[i] = 7;
      req_data[i] = 123; // Data to store
      req_r1[i] = 7;
      req_tag[i] = 0;
      wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
      @(negedge clk);
      resetInputPort(i);

      @(posedge clk);
      req_cmd[i] = 4'b1001; // Store value to trigger branch
      req_d1[i] = 8;
      req_data[i] = 123; // Data to store
      req_r1[i] = 8;
      req_tag[i] = 1;
      wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
      @(negedge clk);
      resetInputPort(i);

      @(posedge clk);
      req_cmd[i] = 4'b1101; // Branch if Equal
      req_d1[i] = 7;
      req_d2[i] = 8;
      req_r1[i] = 0; // Not used
      req_tag[i] = 2;
      wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
      @(negedge clk);
      resetInputPort(i);

      // Command that should be skipped
      @(posedge clk);
      req_cmd[i] = 4'b1001; // Store command that should be skipped
      req_r1[i] = 9;
      req_data[i] = 123; // Arbitrary data
      req_d1[i] = 9;
      req_tag[i] = 3;
      wait (out_resp[i] == 2'b11 && out_tag[i] == req_tag[i]); // Check if this command is skipped
      @(negedge clk);
      if (out_resp[i] == 2'b11) begin
          $display("Command skipped correctly.");
      end else begin
          $display("Error: Command was not skipped as expected.");
      end
      resetInputPort(i);

      // Fetch and verify if register 9 was not modified
      @(posedge clk);
      req_cmd[i] = 4'b1010; // Fetch command to verify skipping
      req_d1[i] = 9;
      req_tag[i] = 0;
      wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
      @(negedge clk);
      if (out_data[i] != 123) begin
          $display("Correct: Register 9 was not modified. %d", out_data[i]);
      end else begin
          $display("Error: Register 9 was modified. %d", out_data[i]);
      end
      resetInputPort(i);

      // Reset all ports
     setAllInputPortsToZero();
     #100;

     end

     foreach (req_cmd[i]) begin
      $display("Testing Addition Functionality for Port %0d", i+1);

    // ADDITION OPERATION

     // Store values in all registers
     $display("Storing initial values into all registers");
     for (int i = 0; i < 16; i++) begin
         initial_values[i] = $urandom_range(1, 100);  // Generate random initial values
         @(posedge clk);
         req_cmd[i] = 4'b1001;  // Store command
         req_d1[i] = i;         // Register index
         req_r1[i] = 0;         // Not used in store operation
         req_data[i] = initial_values[i];  // Data to store
         req_tag[i] = i % 4;    // Use a round-robin tag assignment
         wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]); // Wait for response and check tag
         @(negedge clk);
         resetInputPort(i);
     end

     // Perform ADD operations across all register pairs and verify
     $display("Starting addition tests");
     for (int j = 0; j < 16; j+=2) begin  // Use pairs of registers
         result_index = j + 1;
         @(posedge clk);
         req_cmd[i] = 4'b0001; // ADD command
         req_d1[i] = j;   // Source register 1
         req_d2[i] = j+1; // Source register 2
         req_r1[i] = result_index; // Store result in the next register
         req_data[i] = 0; // Not needed for ADD
         req_tag[i] = (result_index) % 4; // Use a round-robin tag assignment
         wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]); // Wait for response and check tag
         @(negedge clk);
         resetInputPort(i);

         // Fetch and verify the result
         @(posedge clk);
         req_cmd[i] = 4'b1010; // Fetch command
         req_d1[i] = result_index; // Register to fetch
         req_tag[i] = (result_index + 1) % 4; // Increment tag for fetch
         wait (out_resp[i] == 2'b01 && out_tag[i] == req_tag[i]);
         @(negedge clk);
         if (out_data[i] === (initial_values[j] + initial_values[j+1])) begin
             $display("Correct result for R%d: %0d (R%d + R%d)", result_index, out_data[i], j, j+1);
         end else begin
             $display("Error: Incorrect result for R%d: %0d, expected: %0d", result_index, out_data[i], (initial_values[j] + initial_values[j+1]));
         end
         resetInputPort(i);
     end

     // Reset all ports
     setAllInputPortsToZero();
end
   end
   // Function to reset a specific port's inputs
   task resetInputPort(int idx);
     req_cmd[idx] = 0;
     req_d1[idx] = 0;
     req_d2[idx] = 0;
     req_r1[idx] = 0;
     req_tag[idx] = 0;
     req_data[idx] = 0;
   endtask

   // Function to reset all input ports to zero
   task setAllInputPortsToZero();
     foreach (req_cmd[i]) begin
       req_cmd[i] = 0;
       req_d1[i] = 0;
       req_d2[i] = 0;
       req_r1[i] = 0;
       req_tag[i] = 0;
       req_data[i] = 0;
     end
   endtask
endmodule