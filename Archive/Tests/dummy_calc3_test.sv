module Calculator_DUT_tb;

    logic clk;
    logic reset;
    logic [0:1] req_tag;
    logic [0:3] req_cmd;
    logic [0:3] req_d1;
    logic [0:3] req_d2;
    logic [0:3] req_r1;
    logic [0:31] req_data;
    logic [0:1] out_resp;
    logic [0:1] out_tag;
    logic [0:31] out_data;

    // Instance of the Calculator_DUT module
    Calculator_DUT DUT (
        .clk(clk),
        .reset(reset),
        .req_tag(req_tag),
        .req_cmd(req_cmd),
        .req_d1(req_d1),
        .req_d2(req_d2),
        .req_r1(req_r1),
        .req_data(req_data),
        .out_resp(out_resp),
        .out_tag(out_tag),
        .out_data(out_data)
    );

    // Clock generation
    initial begin
        clk = 1;
    end

    // Test sequence
    initial begin
        // Initial reset
        reset = 1;
        #10; // Wait for the reset to take effect
        reset = 0;
        #10; // End of reset

        // Initialize registers with values 0 to 15
        for (int i = 0; i < 16; i++) begin
            req_cmd = 4'b1001; // CMD_STORE command
            req_r1 = i; // Register index, ensuring 4 bits are used
            req_data = i; // Correct value to store, from 0 up to 15 for the last register
            req_tag = 2'b00; // Optionally set a tag if needed for your test logic
            #10; // Allow some time for the command to be processed
            clk = 1; #5; clk = 0; #5; // Manually toggle the clock to simulate clock edge
        end

        req_cmd = 4'b0000;

        #10;

        clk = 1; #5;

        // Test ADD command
        req_cmd = 4'b0001; // CMD_ADD
        req_d1 = 4; // Register 4
        req_d2 = 5; // Register 5
        req_r1 = 6; // Result stored in Register 6

clk = 0; #5;
clk = 1; #5;
        // Test SUBTRACT command
        req_cmd = 4'b0010; // CMD_SUBTRACT
        req_d1 = 7; // Register 7
        req_d2 = 8; // Register 8
        req_r1 = 9; // Result stored in Register 9

clk = 0; #5;
clk = 1; #5;
        // Test SHIFT_LEFT command
        req_cmd = 4'b0101; // CMD_SHIFT_LEFT
        req_d1 = 2; // Register 2
        req_d2 = 1; // Shift amount
        req_r1 = 3; // Result stored in Register 3

clk = 0; #5;
clk = 1; #5;
        // Test SHIFT_RIGHT command
        req_cmd = 4'b0110; // CMD_SHIFT_RIGHT
        req_d1 = 10; // Register 10
        req_d2 = 1; // Shift amount
        req_r1 = 11; // Result stored in Register 11

clk = 0; #5;
clk = 1; #5;
        // Test FETCH command
        req_cmd = 4'b1010; // CMD_FETCH
        req_d1 = 3; // Register 3 (value to fetch)

clk = 0; #5;
clk = 1; #5;
        // Test BRANCH_IF_ZERO command
        // Assuming this command alters the flow based on the zero condition
        req_cmd = 4'b1100; // CMD_BRANCH_IF_ZERO
        req_d1 = 12; // Register 12 (test for zero)

clk = 0; #5;
clk = 1; #5;
        // Test BRANCH_IF_EQUAL command
        req_cmd = 4'b1101; // CMD_BRANCH_IF_EQUAL
        req_d1 = 13; // Register 13
        req_d2 = 14; // Register 14 (test for equality with Register 13)


    end

endmodule
