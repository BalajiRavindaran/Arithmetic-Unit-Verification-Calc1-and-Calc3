`include "Transactions.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "monitor.sv"

// Include Agent
class environment;
    agent agt; // Assume a single agent for simplicity

    function new(virtual dut_interface vim, mailbox sequencerToDriver, mailbox sequencerToMonitor);
        agt = new(vim, sequencerToDriver, sequencerToMonitor); // Initialize the agent with the DUT interface
    endfunction

    // Start the verification process
    task start();
        agt.run(); // Start running transactions
    endtask
endclass