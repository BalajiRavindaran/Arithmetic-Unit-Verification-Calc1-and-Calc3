`include "Transactions.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "monitor.sv"

// Include Agent
class environment;
    agent agt;

    function new(virtual dut_interface vim, mailbox sequencerToDriver, mailbox sequencerToMonitor);
        this.agt = new(vim, sequencerToDriver, sequencerToMonitor);
    endfunction

    task start();
        agt.run();
    endtask
endclass