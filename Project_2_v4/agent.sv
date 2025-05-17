`ifndef AGENT_DEFINED
`define AGENT_DEFINED
`include "Transactions.sv"
`include "TransactionContainer.sv"
`include "sequencer.sv"
`include "driver.sv"
// Include Driver
class agent;
    sequencer seq;
    driver drv;
    mailbox sequencerToDriver;
    mailbox sequencerToMonitor;
    event transaction_received_agent;

    function new(virtual dut_interface vim, mailbox sequencerToDriver, mailbox sequencerToMonitor);
        seq = new(sequencerToDriver); // Sequencer doesn't need the interface
        drv = new(vim); // Driver needs the interface to apply transactions
        this.sequencerToDriver = sequencerToDriver;
        this.sequencerToMonitor = sequencerToMonitor;
    endfunction

    // Method to process transactions
    task run();
        fork
            seq.generateTransactions(10);
            transferTransactions();
        join_none
    endtask
    
    task transferTransactions();
        TransactionContainer tx;
        forever begin
            sequencerToDriver.get(tx);
            -> transaction_received_agent;
            sequencerToMonitor.put(tx);
            drv.drive(tx);
        end
    endtask

endclass

`endif