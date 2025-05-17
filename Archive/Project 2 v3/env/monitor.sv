`include "storeTransaction.sv"

class monitor;
    virtual dut_interface vim;
    mailbox storeTransaction_mbx;
    storeTransaction tx;
    event transaction_received;

    function new(virtual dut_interface vim, mailbox mbx);
        this.vim = vim;
        this.storeTransaction_mbx = mbx;
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
    task handle_transactions();
        forever begin
            storeTransaction_mbx.get(tx);  // Blocking get - waits for a transaction
            -> transaction_received;       // Trigger an event upon receiving a transaction
            @(posedge vim.clk);            // Synchronize with the clock edge to display the transaction
            $display("Monitor -> Transaction Available -> Time: %0t, Cmd: %0h, Tag: %0h, Data: %0h, R1: %0h", 
                     $time, tx.cmd, tx.tag, tx.data, tx.r1);
        end
    endtask

    // Main run task that starts both monitoring processes
    task run();
        fork
            continuous_monitor();  // Start continuous monitoring in a parallel fork
            handle_transactions(); // Handle transactions concurrently
        join_none  // Using join_none to allow both tasks to run indefinitely
    endtask
endclass