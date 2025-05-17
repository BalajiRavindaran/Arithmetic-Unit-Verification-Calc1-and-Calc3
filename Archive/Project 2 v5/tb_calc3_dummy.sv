`include "calc3_dummy.sv"
module tb_calc3_dummy();

    bit clk = 0;
    calc3_dummy dut; // Declare dut as an instance of the calc3_dummy class

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        dut = new(); // Correct instantiation of the class

        // Initialize the registers with values 0 to 15
        for (int i = 0; i < 16; i++) begin
            dut.register_file[i] = i;
        end

        // Simulate command execution after setting inputs
        @(posedge clk); // Wait for a positive clock edge to start operations

        // Test CMD_ADD
        dut.req_cmd[0] = dut.CMD_ADD;
        dut.req_d1[0] = 3;  // Register 3 contains value 3
        dut.req_d2[0] = 4;  // Register 4 contains value 4
        dut.req_r1[0] = 1;  // Output register
        dut.req_tag[0] = 2'b01;
        @(posedge clk);
        dut.execute_commands();
        $display("Test ADD: Expected 7, Got %d", dut.register_file[1]);

        // Test CMD_SUBTRACT
        dut.req_cmd[0] = dut.CMD_SUBTRACT;
        dut.req_d1[0] = 5;  // Register 5 contains value 5
        dut.req_d2[0] = 2;  // Register 2 contains value 2
        dut.req_r1[0] = 1;  // Output register
        dut.req_tag[0] = 2'b01;
        @(posedge clk); 
        dut.execute_commands();
        $display("Test SUBTRACT: Expected 3, Got %d", dut.register_file[1]);

        // Test CMD_SHIFT_LEFT
        dut.req_cmd[0] = dut.CMD_SHIFT_LEFT;
        dut.req_d1[0] = 1;  // Register 1 now contains value 7 (from previous addition)
        dut.req_d2[0] = 1;  // Shift by 1 (equiv to multiplying by 2)
        dut.req_r1[0] = 2;  // Output register
        dut.req_tag[0] = 2'b01;
        @(posedge clk);
        dut.execute_commands();
        $display("Test SHIFT LEFT: Expected 14, Got %d", dut.register_file[2]);

        // Test CMD_SHIFT_RIGHT
        dut.req_cmd[0] = dut.CMD_SHIFT_RIGHT;
        dut.req_d1[0] = 2;  // Register 2 now contains value 14
        dut.req_d2[0] = 1;  // Shift by 1 (equiv to dividing by 2)
        dut.req_r1[0] = 3;  // Output register
        dut.req_tag[0] = 2'b01;
        @(posedge clk);
        dut.execute_commands();
        $display("Test SHIFT RIGHT: Expected 7, Got %d", dut.register_file[3]);

        // Test CMD_STORE
        dut.req_cmd[0] = dut.CMD_STORE;
        dut.req_data[0] = 123;  // Data to store
        dut.req_r1[0] = 4;  // Register to store into
        dut.req_tag[0] = 2'b01;
        @(posedge clk);
        dut.execute_commands();
        $display("Test STORE: Expected 123, Got %d", dut.register_file[4]);

        // Test CMD_FETCH
        dut.req_cmd[0] = dut.CMD_FETCH;
        dut.req_d1[0] = 4;  // Register to fetch from (contains 123)
        dut.req_r1[0] = 5;  // Irrelevant for fetch
        dut.req_tag[0] = 2'b01;
        @(posedge clk);
        dut.execute_commands();
        $display("Test FETCH: Expected 123, Got %d", dut.out_data[0]);

        // Clean up and finish
        $finish;
    end
endmodule
