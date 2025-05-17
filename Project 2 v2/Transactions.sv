///////////////////////////////////////////////////////////////////////////////////
// File: Transactions.sv
// Author: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor
// Date: 2024-04-15
// Description: Defines various transaction classes for use in a verification environment,
// including basic transactions and specific commands like store, fetch, add, etc.
///////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: baseTransaction
// Description: Base class for all transaction types, containing common properties
// and methods that can be extended for specific transaction types.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: storeTransaction
// Description: Extends baseTransaction for store operations, implementing specific
// constraints and functionality related to store commands.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: fetchTransaction
// Description: Extends baseTransaction for fetch operations, implementing specific
// constraints and functionality related to fetch commands.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: addTransaction
// Description: Extends baseTransaction for addition operations, specific to
// arithmetic addition commands.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: subTransaction
// Description: Extends baseTransaction for subtraction operations, specific to
// arithmetic subtraction commands.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: sllTransaction
// Description: Extends baseTransaction for shift-left logical operations, specific to
// bitwise shift-left commands.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: srlTransaction
// Description: Extends baseTransaction for shift-right logical operations, specific to
// bitwise shift-right commands.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: bzTransaction
// Description: Extends baseTransaction for branch-if-zero operations, specific to
// branching commands when a condition is zero.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: beTransaction
// Description: Extends baseTransaction for branch-if-equal operations, specific to
// branching commands when two values are equal.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: portTransaction
// Description: Defines a transaction type for port operations, managing port assignments
// within the verification environment.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// Class: commandTransaction
// Description: Manages the generation of command values for dynamic testing scenarios,
// ensuring valid command operations are used.
///////////////////////////////////////////////////////////////////////////////////


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

`ifndef COMMAND_TRANSACTION_DEFINED
`define COMMAND_TRANSACTION_DEFINED

class commandTransaction;
    rand int cmd;

    constraint valid_command { cmd inside {1 ,2, 5, 6}; } 
endclass

`endif