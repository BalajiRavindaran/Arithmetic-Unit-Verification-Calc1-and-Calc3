`ifndef AGENT_DEFINED
`define AGENT_DEFINED
`include "storeTransaction.sv"
`include "sequencer.sv"
`include "driver.sv"
// Include Driver
class agent;
    sequencer seq;
    driver drv;
    mailbox storeTransaction_mbx;

    function new(virtual dut_interface vim, mailbox mbx);
        seq = new(); // Sequencer doesn't need the interface
        drv = new(vim); // Driver needs the interface to apply transactions
        storeTransaction_mbx = mbx;
    endfunction

    // Method to process transactions
    task run();
     storeTransaction sx;
        sx = seq.generateStoreTransaction(); // Generate transaction
        drv.drive(sx); // Drive transaction to DUT
        storeTransaction_mbx.put(sx);
    endtask
endclass

`endif