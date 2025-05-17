`include "storeTransaction.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "monitor.sv"

// Include Agent
class environment;
    agent agt; // Assume a single agent for simplicity

    function new(virtual dut_interface vim, mailbox storeTransaction_mbx);
        agt = new(vim, storeTransaction_mbx); // Initialize the agent with the DUT interface
    endfunction

    // Start the verification process
    task start();
        agt.run(); // Start running transactions
    endtask
endclass