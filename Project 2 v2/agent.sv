//////////////////////////////////////////////////////////////////////////////////
// Agent: Verification Component                                                //
// Date: 2024-04-15                                                            //
//                                                                              //
// Description:                                                                 //
// The `agent` class is responsible for the generation, execution, and transfer  //
// of transactions in the verification environment. It encapsulates a sequencer //
// for transaction generation and a driver to apply these transactions to the   //
// DUT (Device Under Test). The `agent` controls the flow of transactions       //
// between these components using mailboxes and synchronization events.         //
//                                                                              //
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor                  //
//                                                                              //
// Revision History:                                                            //
// - 2024-04-15: Initial release of the `agent` class. Provides infrastructure //
//               for transaction generation and driving to the DUT while        //
//               facilitating inter-component communication.                     //
//                                                                              //
// Notes:                                                                       //
// - The `agent` uses mailboxes for transaction queuing and ensures correct     //
//   synchronization between the sequencer and driver.                          //
// - The `transaction_received_agent` event signals the availability of new     //
//   transactions for the driver to process.                                    //
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

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
        seq = new(sequencerToDriver);
        drv = new(vim);
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