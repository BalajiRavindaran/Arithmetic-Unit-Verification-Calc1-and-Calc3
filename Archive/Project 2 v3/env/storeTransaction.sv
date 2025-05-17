// Create Transaction
`ifndef STORE_TRANSACTION_DEFINED
`define STORE_TRANSACTION_DEFINED

class storeTransaction;
    bit [3:0] cmd = 4'b1001; // Command, with specific values for different operations
    rand bit [3:0] r1;       // Result of the addition, for expected result checking
    rand bit [1:0] tag; // Tag for transaction tracking
    rand bit [31:0] data;

    // Optional: Constraints for randomization
    constraint valid_r1 { r1 < 16; } // Example constraints
    constraint valid_tag { tag < 4; } // Example constraints
    constraint valid_data { data < 2147483647; } // Example constraints

    // Method to randomize and display transaction for debugging
    function void display();
        $display("Transaction: cmd=%h, r1=%h, tag=%h, data=%h", cmd, r1, tag, data);
    endfunction

    // Constructor
    function new();
    endfunction
endclass

`endif