//////////////////////////////////////////////////////////////////////////////////
// Class: environment                                                           //
// Date: 2024-04-15                                                            //
//                                                                              //
// Description:                                                                 //
// The `environment` class acts as a container for the verification environment //
// components, including the agent, monitor, and scoreboard. It manages the     //
// interconnection between these components and the DUT via mailboxes and the   //
// interface. The start task within this class triggers the execution of test   //
// sequences by running the agent and monitor concurrently.                     //
//                                                                              //
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor                  //
//                                                                              //
// Revision History:                                                            //
// - 2024-04-15: Initial creation and setup of the environment. It coordinates //
//               the activities of the agent, monitor, and scoreboard for       //
//               functional verification.                                        //
//                                                                              //
// Notes:                                                                       //
// - This class is essential for setting up the testbench and integrating the   //
//   components for simulation.                                                 //
// - It uses two mailboxes to facilitate communication between the sequencer,   //
//   driver, and monitor.                                                       //
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

`include "Transactions.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "monitor.sv"
`include "scoreboard.sv"

// Include Agent
class environment;
    agent agt;
    monitor mon;
    scoreboard scb;
    mailbox sequencerToDriver = new();
    mailbox sequencerToMonitor = new();

    function new(virtual dut_interface vim);
        this.agt = new(vim, sequencerToDriver, sequencerToMonitor);
        this.scb = new(vim);
        this.mon = new(vim, sequencerToMonitor, scb);
    endfunction

    task start();
        fork
            agt.run();
            mon.run();
        join
    endtask
endclass
