`include "Transactions.sv"
`include "TransactionContainer.sv"
`include "scoreboard.sv"

class monitor;
    virtual dut_interface vim;
    mailbox sequencerToMonitor;

    TransactionContainer tx;
    event transaction_received;

    scoreboard scb;

    function new(virtual dut_interface vim, mailbox sequencerToMonitor);
        scb = new(vim);
        this.vim = vim;
        this.sequencerToMonitor = sequencerToMonitor;
    endfunction

    // Task for continuous monitoring of DUT outputs
    task continuous_monitor();
        forever begin
            @(posedge vim.clk);  // Trigger at every positive edge of the clock
            $display("Monitor -> DUT Output -> Time: %0t, Tag Out: %0h, Data Out: %0h, Resp Out: %0h", 
                     $time, vim.out1_tag, vim.out1_data, vim.out1_resp);
        end
    endtask

    // Task for handling transactions when they arrive
    task handle_transactions_list();
        forever begin
            sequencerToMonitor.get(tx);  // Blocking get - waits for a transaction
            -> transaction_received;       // Trigger an event upon receiving a transaction
            scb.receiveTransactionScoreboard(tx);
            @(posedge vim.clk);            // Synchronize with the clock edge to display the transaction
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