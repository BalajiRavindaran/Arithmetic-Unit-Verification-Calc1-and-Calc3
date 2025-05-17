`ifndef BASE_TRANSACTION_DEFINED
`define BASE_TRANSACTION_DEFINED

class baseTransaction;
    rand bit [0:1] tag;
    rand bit [0:3] r1 = 0; // Initialize with default values
    rand bit [0:31] data = 0;
    bit [0:3] cmd = 0;
    rand bit [0:3] d1 = 0; 
    rand bit [0:3] d2 = 0;

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
    constraint valid_data { data < 4095; }
    constraint valid_d1 { d1 == 0; }
    constraint valid_d2 { d2 == 0; }

    function void display();
        $display("Transaction Created -> Store Transaction -> Cmd=%h, Data=%d, R1=%d, D1=%d, D2=%d, Tag=%d", cmd, data, r1, d1, d2, tag);
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
        $display("Transaction Created -> Fetch Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef ADD_TRANSACTION_DEFINED
`define ADD_TRANSACTION_DEFINED

class addTransaction extends baseTransaction;
    function new();
        cmd = 4'b0001; // Specific command for fetch transactions
    endfunction

    constraint valid_d1 { d1 < 16; } 
    constraint valid_d2 { d2 < 16; }
    constraint valid_r1 { r1 < 16; }
    constraint valid_data { data == 0; }

    function void display();
        $display("Transaction Created -> ADD Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef SUB_TRANSACTION_DEFINED
`define SUB_TRANSACTION_DEFINED

class subTransaction extends baseTransaction;
    function new();
        cmd = 4'b0010; // Specific command for fetch transactions
    endfunction

    constraint valid_d1 { d1 < 16; } 
    constraint valid_d2 { d2 < 16; }
    constraint valid_r1 { r1 < 16; }
    constraint valid_data { data == 0; }

    function void display();
        $display("Transaction Created -> SUB Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef SLL_TRANSACTION_DEFINED
`define SLL_TRANSACTION_DEFINED

class sllTransaction extends baseTransaction;
    function new();
        cmd = 4'b0101; // Specific command for fetch transactions
    endfunction

    constraint valid_d1 { d1 < 16; } 
    constraint valid_d2 { d2 < 16; }
    constraint valid_r1 { r1 < 16; }
    constraint valid_data { data == 0; }

    function void display();
        $display("Transaction Created -> SUB Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef SRL_TRANSACTION_DEFINED
`define SRL_TRANSACTION_DEFINED

class srlTransaction extends baseTransaction;
    function new();
        cmd = 4'b0110; // Specific command for fetch transactions
    endfunction

    constraint valid_d1 { d1 < 16; } 
    constraint valid_d2 { d2 < 16; }
    constraint valid_r1 { r1 < 16; }
    constraint valid_data { data == 0; }

    function void display();
        $display("Transaction Created -> SUB Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef BZ_TRANSACTION_DEFINED
`define BZ_TRANSACTION_DEFINED

class bzTransaction extends baseTransaction;
    function new();
        cmd = 4'b1100; // Specific command for fetch transactions
    endfunction

    constraint valid_d1 { d1 < 16; } 
    constraint valid_d2 { d2 == 0; }
    constraint valid_r1 { r1 == 0; }
    constraint valid_data { data == 0; }

    function void display();
        $display("Transaction Created -> SUB Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
    endfunction
endclass

`endif

`ifndef BE_TRANSACTION_DEFINED
`define BE_TRANSACTION_DEFINED

class beTransaction extends baseTransaction;
    function new();
        cmd = 4'b1101; // Specific command for fetch transactions
    endfunction

    constraint valid_d1 { d1 < 16; } 
    constraint valid_d2 { d2 < 16; }
    constraint valid_r1 { r1 == 0; }
    constraint valid_data { data == 0; }

    function void display();
        $display("Transaction Created -> SUB Transaction -> Cmd=%h, Data=%h, R1=%h, D1=%h, D2=%h, Tag=%h", cmd, data, r1, d1, d2, tag);
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