`ifndef BASE_TRANSACTION_DEFINED
`define BASE_TRANSACTION_DEFINED

class baseTransaction;
    rand bit [1:0] tag;
    rand bit [3:0] r1 = 0; // Initialize with default values
    rand bit [31:0] data = 0;
    bit [3:0] cmd = 0;
    rand bit [3:0] d1 = 0; 
    rand bit [3:0] d2 = 0;

    // Common constraint for all transactions
    constraint valid_tag { tag < 4; }
endclass

`endif

`ifndef STORE_TRANSACTION_DEFINED
`define STORE_TRANSACTION_DEFINED

// Extend baseTransaction for specific functionality
class storeTransaction extends baseTransaction;
    function new();
        cmd = 4'b1001; // Specific command for store transactions
    endfunction

    constraint valid_r1 { r1 < 16; } // Additional constraints specific to this transaction
    constraint valid_data { data < 2147483647; }
    constraint valid_d1 { d1 == 0; }
    constraint valid_d2 { d2 == 0; }

    function void display();
        $display("Transaction Created -> Store Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef FETCH_TRANSACTION_DEFINED
`define FETCH_TRANSACTION_DEFINED

class fetchTransaction extends baseTransaction;
    function new();
        cmd = 4'b1010; // Specific command for fetch transactions
    endfunction

    constraint valid_d1 { d1 < 16; } 
    constraint valid_d2 { d2 == 0; }
    constraint valid_r1 { r1 == 0; }
    constraint valid_data { data == 0; }

    function void display();
        $display("Transaction Created -> Store Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef PORTS_TRANSACTION_DEFINED
`define PORTS_TRANSACTION_DEFINED

class portTransaction;
    rand int port;

    constraint valid_port { port < 5 && port > 0; } 

    function void display();
        $display("Transaction Created -> Port: %d", port);
    endfunction
endclass

`endif