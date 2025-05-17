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
            if (vim.out1_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 1 -> Time: %0t, Tag Out: %d, Data Out: %d, Resp Out: %d", $time, vim.out1_tag, vim.out1_data, vim.out1_resp);
            end
            else if (vim.out2_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 2 -> Time: %0t, Tag Out: %d, Data Out: %d, Resp Out: %d", $time, vim.out2_tag, vim.out2_data, vim.out2_resp);
            end
            else if (vim.out3_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 3 -> Time: %0t, Tag Out: %d, Data Out: %d, Resp Out: %d", $time, vim.out3_tag, vim.out3_data, vim.out3_resp);
            end
            else if (vim.out4_resp != 0) begin
                $display("Monitor -> DUT Output -> PORT 4 -> Time: %0t, Tag Out: %d, Data Out: %d, Resp Out: %d", $time, vim.out4_tag, vim.out4_data, vim.out4_resp);
            end
        end
    endtask

    // Task for handling transactions when they arrive
    task handle_transactions_list();
        forever begin
            sequencerToMonitor.get(tx);  // Blocking get - waits for a transaction
            -> transaction_received;       // Trigger an event upon receiving a transaction
            @(posedge vim.clk);            // Synchronize with the clock edge to display the transaction
            foreach (tx.transactions[i]) begin
                $display("Monitor -> Transaction Received Index %0d -> Cmd=%d, Tag=%d, R1=%d, D1=%d, D2=%d, Data=%d | Port %0d", i, tx.transactions[i].cmd, tx.transactions[i].tag, tx.transactions[i].r1, tx.transactions[i].d1, tx.transactions[i].d2, tx.transactions[i].data, tx.ports[i]);
                scb.receiveTransactionScoreboard(tx);
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