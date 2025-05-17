//////////////////////////////////////////////////////////////////////////////
// Module Name: PortChecker
// File Name: checker.sv
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor
// Date: 2024-04-15
// Description: This class is designed to validate the outputs of a device under
//              test (DUT) by comparing the expected results against the actual
//              outputs observed on various ports. It tracks and reports the
//              correctness of data, response, and tags across multiple ports.
//
//              The PortChecker class provides methods to set expected values,
//              update actual results as they are observed, and check for
//              discrepancies between expected and actual values. It reports
//              detailed information about mismatches and maintains counts of
//              correct and incorrect validations to assist in debugging and
//              verifying the DUT's functionality.
//
//              The checker is a crucial component of the testbench for ensuring
//              the reliability and accuracy of the verification process.
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

`ifndef CHECKER_DEFINED
`define CHECKER_DEFINED

class PortChecker;
    // Member variables to store expected and actual results for data, response, and tags
    logic [0:31] expected_data[4];
    logic [0:1] expected_response[4];
    logic [0:31] expected_tag[4];

    logic [0:31] actual_data[4];
    logic [0:1] actual_response[4];
    logic [0:1] actual_tag[4];

    // Counters for tracking correct and incorrect outputs
    int correct_count = 0;
    int error_count = 0;

    // Constructor
    function new();
    endfunction

    // Method to set expected results
    function void set_expected(int port, logic [0:31] data, logic [0:1] response, logic [0:1] tag);
        expected_data[port] = data;
        expected_response[port] = response;
        expected_tag[port] = tag;
    endfunction

    // Method to set actual results
    function void set_actual(int port, logic [0:31] data, logic [0:1] response, logic [0:1] tag);
        actual_data[port] = data;
        actual_response[port] = response;
        actual_tag[port] = tag;
    endfunction

    // Method to check results and print mismatches
    task check_results();
        for (int i = 0; i < 4; i++) begin
            if ($isunknown(expected_data[i]) || $isunknown(expected_response[i]) || $isunknown(expected_tag[i])) begin
            $display("Skipping Port %0d, Expected values are unknown", i+1);
            continue;  // Skip this iteration of the loop
            end
            
            if ((expected_data[i] !== actual_data[i]) || 
                (expected_response[i] !== actual_response[i]) || 
                (expected_tag[i] !== actual_tag[i])) begin
                // Print mismatch information
                $display("ERROR: Mismatch detected at Port %0d", i+1);
                error_count++; // Increment the error counter
            end else begin
                // Print match information
                $display("CORRECT: Outputs are matching at Port %0d", i+1);
                correct_count++; // Increment the correct counter
            end
            // Always print the values checked
            $display("Port %0d Checked Values:", i+1);
            $display("  Expected Data: %0d, Actual Data: %0d", expected_data[i], actual_data[i]);
            $display("  Expected Response: %0d, Actual Response: %0d", expected_response[i], actual_response[i]);
            $display("  Expected Tag: %0d, Actual Tag: %0d", expected_tag[i], actual_tag[i]);
        end
        // Display total correct and error counts
        $display("Time: %t Total correct outputs: %0d, Total errors detected: %0d", $time, correct_count, error_count);
        
    endtask

endclass

`endif