module calc3_tb;

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

   initial begin
     reset = 1'b1;
     #140;
     reset = 1'b0;

     // Reset all ports
     setAllInputPortsToZero();
     #100;

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
         wait (out_resp[i] == 2'b01);
         @(negedge clk);
         resetInputPort(i);
       end

       // Fetch and verify values from all registers
       for (int j = 0; j < 16; j++) begin
         @(posedge clk);
         req_cmd[i] = 4'b1010;  // Fetch command
         req_d1[i] = j;         // Register to fetch from
         req_tag[i] = j % 4;    // Loop around tags for four ports
         wait (out_resp[i] == 2'b01);
         @(negedge clk);
         if (out_data[i] == j) begin
           $display("Port %0d - Data from register %d: %d, correct.", i+1, j, out_data[i]);
         end else begin
           $display("Port %0d - Error: Data from register %d: %d, expected: %d.", i+1, j, out_data[i], j);
         resetInputPort(i);
         end

       $display("Store and fetch tests completed for Port %0d.", i+1);
       end
   end

   // Reset all ports
     setAllInputPortsToZero();
     #100;

     // Branch tests across all ports
     foreach (req_cmd[i]) begin
       $display("Starting branching tests for Port %0d", i+1);

       // Set register to zero for Branch if Zero condition
       @(posedge clk);
       req_cmd[i] = 4'b1001;
       req_r1[i] = 8;  // Use register 0
       req_data[i] = 0;
       req_tag[i] = i % 4;
       wait (out_resp[i] == 2'b01);
       @(negedge clk);
       resetInputPort(i);

       // Test Branch if Zero - should skip the next command
       @(posedge clk);
       req_cmd[i] = 4'b1100;  // Branch if Zero
       req_d1[i] = 8;
       req_tag[i] = i % 4;         // Check if register 0 is zero
       wait (out_resp[i] == 2'b01);
       @(negedge clk);
       resetInputPort(i);

       // Issue a command that should be skipped
       @(posedge clk);
       req_cmd[i] = 4'b1001;  // Attempt to store
       req_r1[i] = 1;         // Use register 1
       req_data[i] = 123;     // Arbitrary data
       req_tag[i] = i % 4;  
       wait (out_resp[i] == 2'b11);  // This command should be skipped
       if (out_resp[i] == 2'b11) begin
           $display("Port %0d: Command correctly skipped due to branch condition.", i+1);
       end else begin
           $display("Port %0d: Error, command was not skipped as expected.", i+1);
       @(negedge clk);
       resetInputPort(i);
       end
       // Check if register 1 was not modified
       @(posedge clk);
       req_cmd[i] = 4'b1010;
       req_d1[i] = 1;
       req_tag[i] = i % 4;  
       wait (out_resp[i] == 2'b01);
       if (out_data[i] != 123) begin
           $display("Port %0d: Correct, register 1 was not modified after skip.", i+1);
     end else begin
           $display("Port %0d: Error, register 1 was modified after skip.", i+1);
       @(negedge clk);
       resetInputPort(i);
     end
     end
     $display("Branching if Zero tests completed for all ports.");

     #100ns;

     // Branch if Equal tests across all ports
     foreach (req_cmd[i]) begin
       // Precondition: Set two registers to the same value
       @(posedge clk);
       req_cmd[i] = 4'b1001;
       req_r1[i] = 0;  // Register 0
       req_data[i] = 100;  // Data to set
       req_tag[i] = i % 4;  
       wait (out_resp[i] == 2'b01);
       @(negedge clk);
       resetInputPort(i);

       @(posedge clk);
       req_cmd[i] = 4'b1001;
       req_r1[i] = 1;  // Register 1, same value as Register 0
       req_data[i] = 100;  // Same data
       req_tag[i] = i % 4;  
       wait (out_resp[i] == 2'b01);
       @(negedge clk);
       resetInputPort(i);

       // Issue Branch if Equal command
       @(posedge clk);
       req_cmd[i] = 4'b1101;
       req_d1[i] = 0;
       req_d2[i] = 1;  // Compare Register 0 and Register 1
       req_tag[i] = i % 4;  
       wait (out_resp[i] == 2'b01);
       @(negedge clk);
       resetInputPort(i);

       // Command that should be skipped
       @(posedge clk);
       req_cmd[i] = 4'b1001;  // Any command
       req_r1[i] = 2;         // Another register
       req_data[i] = 200;     // Arbitrary data
       req_tag[i] = i % 4;  
       wait (out_resp[i] == 2'b11);  // This command should be skipped
       if (out_resp[i] == 2'b11) begin
           $display("Port %0d: Command correctly skipped due to Branch if Equal.", i+1);
       end else begin
           $display("Port %0d: Error, command was not skipped as expected.", i+1);
       @(negedge clk);
       resetInputPort(i);
       end

     $display("Branch if Equal tests completed for all ports.");
        
     end

     setAllInputPortsToZero();
     #100;
          // Initialize tag counters to zero for all ports
     foreach (tag_counter[idx]) tag_counter[idx] = 0;

     // Fill initial_values with random values and store them in the DUT
    for (int i = 0; i < 16; i++) begin
         initial_values[i] = $urandom_range(1, 1000);  // Randomize initial values
         foreach (req_cmd[port]) begin  // Iterate over each port
             @(posedge clk);
             req_cmd[port] = 4'b1001;  // Store command
             req_data[port] = initial_values[i];
             req_d1[port] = i;  // Register index to store the value
             req_r1[port] = 0;  // Not used in store operation
             req_d2[port] = 0;  // Not used in store operation
             req_tag[port] = tag_counter[port];
             wait (out_resp[port] == 2'b01);  // Wait for the store operation to complete
             @(negedge clk);
             $display("Stored %0d in register %0d via port %0d", initial_values[i], i, port);
             resetInputPort(port);
             tag_counter[port] = (tag_counter[port] + 1) % 4;  // Increment tag
         end
   end

   // Fetch and verify each stored value
     for (int i = 0; i < 16; i++) begin
         foreach (req_cmd[port]) begin
             @(posedge clk);
             req_cmd[port] = 4'b1010; // Fetch command
             req_d1[port] = i;  // Register index to fetch
             req_r1[port] = 0;  // Not used in fetch operation
             req_d2[port] = 0;  // Not used in fetch operation
             req_tag[port] = tag_counter[port];
             wait (out_resp[port] == 2'b01);
             @(negedge clk);
             if (out_data[port] === initial_values[i]) begin
                 $display("Correctly fetched %0d from register %0d via port %0d", out_data[port], i, port);
             end else begin
                 $display("Error: Fetched %0d, expected %0d from register %0d via port %0d", out_data[port], initial_values[i], i, port);
             end
             resetInputPort(port);
             tag_counter[port] = (tag_counter[port] + 1) % 4;
         end
     end

     // Perform operations with unique and sequential tagging
     foreach (req_cmd[i]) begin
       $display("Starting operations for Port %0d", i+1);

       // Randomized operations
       for (int k = 0; k < 16; k++) begin
         src_reg1 = $urandom_range(0, 15);
         src_reg2 = $urandom_range(0, 15);
         dst_reg = $urandom_range(0, 15);
         shift_amount = $urandom_range(1, 31); // For shift operations
       
         // ADD operation
         @(posedge clk);
         req_cmd[i] = 4'b0001; // ADD command
         req_d1[i] = src_reg1;
         req_d2[i] = src_reg2;
         req_r1[i] = dst_reg;
         req_tag[i] = tag_counter[i];
         wait (out_resp[i] == 2'b01);
         @(negedge clk);
         $display("Port %0d - ADD: R%d = R%d + R%d, Tag: %0d, Expected: %0d, Result: %0d",
                  i+1, dst_reg, src_reg1, src_reg2, tag_counter[i], initial_values[src_reg1] + initial_values[src_reg2], out_data[i]);
         resetInputPort(i);
         tag_counter[i] = (tag_counter[i] + 1) % 4; // Increment and wrap tag

         // SUB operation
         @(posedge clk);
         req_cmd[i] = 4'b0010; // SUB command
         req_d1[i] = src_reg1;
         req_d2[i] = src_reg2;
         req_r1[i] = dst_reg;
         req_tag[i] = tag_counter[i];
         wait (out_resp[i] == 2'b01);
         @(negedge clk);
         $display("Port %0d - SUB: R%d = R%d - R%d, Tag: %0d, Expected: %0d, Result: %0d",
                  i+1, dst_reg, src_reg1, src_reg2, tag_counter[i], initial_values[src_reg1] - initial_values[src_reg2], out_data[i]);
         resetInputPort(i);
         tag_counter[i] = (tag_counter[i] + 1) % 4;

         // SLL operation
         @(posedge clk);
         req_cmd[i] = 4'b0101; // SLL command
         req_d1[i] = src_reg1;
         req_d2[i] = shift_amount; // Using random shift amount
         req_r1[i] = dst_reg;
         req_tag[i] = tag_counter[i];
         wait (out_resp[i] == 2'b01);
         @(negedge clk);
         $display("Port %0d - SLL: R%d = R%d << %0d, Tag: %0d, Expected: %0d, Result: %0d",
                  i+1, dst_reg, src_reg1, shift_amount, tag_counter[i], initial_values[src_reg1] << shift_amount, out_data[i]);
         resetInputPort(i);
         tag_counter[i] = (tag_counter[i] + 1) % 4;

         // SRL operation
         @(posedge clk);
         req_cmd[i] = 4'b0110; // SRL command
         req_d1[i] = src_reg1;
         req_d2[i] = shift_amount; // Using random shift amount
         req_r1[i] = dst_reg;
         req_tag[i] = tag_counter[i];
         wait (out_resp[i] == 2'b01);
         @(negedge clk);
         $display("Port %0d - SRL: R%d = R%d >> %0d, Tag: %0d, Expected: %0d, Result: %0d",
                  i+1, dst_reg, src_reg1, shift_amount, tag_counter[i], initial_values[src_reg1] >> shift_amount, out_data[i]);
         resetInputPort(i);
         tag_counter[i] = (tag_counter[i] + 1) % 4;
       end

       $display("Operations completed for Port %0d.", i+1);
     begin

       $display("Arithmetic and shift operations completed for Port %0d.", i+1);
     end
   end
        // Assuming previous storage code as discussed, moving to fetch operation
     // Fetch and verify each stored value using only port 0 to avoid concurrent operations
     for (int i = 0; i < 16; i++) begin
         @(posedge clk);
         req_cmd[0] = 4'b1010; // Fetch command
         req_d1[0] = i;  // Register index to fetch
         req_r1[0] = 0;  // Not used in fetch operation
         req_d2[0] = 0;  // Not used in fetch operation
         req_tag[0] = tag_counter2; // Use sequential tags
         wait (out_resp[0] == 2'b01);
         @(negedge clk);
         if (out_data[0] === initial_values[i]) begin
             $display("Correctly fetched %0d from register %0d via port 0", out_data[0], i);
         end else begin
             $display("Error: Fetched %0d, expected %0d from register %0d via port 0", out_data[0], initial_values[i], i);
         end
         resetInputPort(0);
         tag_counter2 = (tag_counter2 + 1) % 4; // Increment tag for next operation
     end

        $display("Starting the Simple Functionality tests for Port 1");

    setAllInputPortsToZero();
     #100;

     // Store first value in register 0
     @(posedge clk);
     req_cmd[0] = 4'b1001; // Store command
     req_d1[0] = 0;
     req_r1[0] = 7;
     req_data[0] = 10; // Example value
     req_tag[0] = 0;
     wait (out_resp[0] == 2'b01);
     @(negedge clk);
     resetInputPort(0);

     // Store second value in register 1
     @(posedge clk);
     req_cmd[0] = 4'b1001; // Store command
     req_d1[0] = 0;
     req_r1[0] = 8;
     req_data[0] = 20; // Example value
     req_tag[0] = 1;
     wait (out_resp[0] == 2'b01);
     @(negedge clk);
     resetInputPort(0);

     // Perform ADD operation: R2 = R0 + R1
     @(posedge clk);
     req_cmd[0] = 4'b0001; // ADD command
     req_d1[0] = 7; // Source register 1
     req_d2[0] = 8; // Source register 2
     req_r1[0] = 9; // Destination register
     req_tag[0] = 2;
     wait (out_resp[0] == 2'b01);
     @(negedge clk);
     resetInputPort(0);

     // Fetch and verify the result from register 2
     @(posedge clk);
     req_cmd[0] = 4'b1010; // Fetch command
     req_d1[0] = 9; // Register to fetch
     req_tag[0] = 3;
     wait (out_tag[0] == 2'b11 && out_resp[0] == 2'b01);
     @(negedge clk);
     if (out_data[0] === 30) begin
         $display("Correct result: %0d", out_data[0]);
     end else begin
         $display("Incorrect result: %0d, expected: 30", out_data[0]);
     end
     resetInputPort(0);
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