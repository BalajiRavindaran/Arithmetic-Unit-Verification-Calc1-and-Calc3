///////////////////////////////////////////////////////////////////////////////////
// File: monitor.sv
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor
// Date: 2024-04-15
// Description: Implements the monitoring functionality within the verification environment.
// The monitor observes DUT outputs, logs transaction details, and communicates with
// the scoreboard to validate transaction execution based on expected results.
//
// Features:
// - Continuous monitoring of DUT outputs across multiple ports.
// - Receives and handles transactions via a mailbox interface.
// - Triggers events upon receiving transactions for further processing.
// - Integrates with a scoreboard to verify transactions against expected outcomes.
///////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

`include "Transactions.sv"
`include "TransactionContainer.sv"
`include "scoreboard.sv"

class monitor;
    virtual dut_interface vim;
    mailbox sequencerToMonitor;

    TransactionContainer tx;
    event transaction_received;

    scoreboard scb;

    function new(virtual dut_interface vim, mailbox sequencerToMonitor, scoreboard scb);
        this.scb = scb;
        this.vim = vim;
        this.sequencerToMonitor = sequencerToMonitor;
    endfunction

    // Task for continuous monitoring of DUT outputs
    task continuous_monitor();
        forever begin
            @(posedge vim.clk);  // Trigger at every positive edge of the clock
            if (vim.out1_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 1 -> Time: %0t, Tag Out: %0h, Data Out: %0h, Resp Out: %0h", $time, vim.out1_tag, vim.out1_data, vim.out1_resp);
            end
            if (vim.out2_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 2 -> Time: %0t, Tag Out: %0h, Data Out: %0h, Resp Out: %0h", $time, vim.out2_tag, vim.out2_data, vim.out2_resp);
            end
            if (vim.out3_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 3 -> Time: %0t, Tag Out: %0h, Data Out: %0h, Resp Out: %0h", $time, vim.out3_tag, vim.out3_data, vim.out3_resp);
            end
            if (vim.out4_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 4 -> Time: %0t, Tag Out: %0h, Data Out: %0h, Resp Out: %0h", $time, vim.out4_tag, vim.out4_data, vim.out4_resp);
            end
        end
    endtask

    // Task for handling transactions when they arrive
    task handle_transactions_list();
        forever begin
            sequencerToMonitor.get(tx);  // Blocking get - waits for a transaction
            -> transaction_received;       // Trigger an event upon receiving a transaction
            scb.receiveTransactionScoreboard(tx);
            foreach (tx.transactions[i]) begin
                $display("Monitor -> Transaction Received Index %0d -> Cmd=%h, Tag=%h, R1=%h, D1=%h, D2=%h, Data=%h | Port %0d", i, tx.transactions[i].cmd, tx.transactions[i].tag, tx.transactions[i].r1, tx.transactions[i].d1, tx.transactions[i].d2, tx.transactions[i].data, tx.ports[i]);
            end
        end
    endtask

    // Main run task that starts both monitoring processes
    task run();
        fork
            continuous_monitor();  // Start continuous monitoring in a parallel fork
            handle_transactions_list();
        join_none  // Using join_none to allow both tasks to run indefinitely
    endtask
endclass

