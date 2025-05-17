`ifndef SEQUENCER_DEFINED
`define SEQUENCER_DEFINED
`include "Transactions.sv"
`include "TransactionContainer.sv"

// Include Transaction
class sequencer;
    // Method to generate and randomize a transaction
    baseTransaction bx_list[];
    int ports[];
    TransactionContainer container;
    mailbox sequencerToDriver;

    function new(mailbox sequencerToDriver);
        this.sequencerToDriver = sequencerToDriver;
    endfunction

    function storeTransaction generateStoreTransaction();
        storeTransaction sx = new();
        assert(sx.randomize()); // Randomize the transaction
        sx.display(); // Calculate the expected result for checking
        return sx; // Return the randomized transaction
    endfunction

    function fetchTransaction generateFetchTransaction();
        fetchTransaction fx = new();
        assert(fx.randomize()); // Randomize the transaction
        fx.display(); // Calculate the expected result for checking
        return fx; // Return the randomized transaction
    endfunction

    function int generatePort();
        portTransaction px = new();
        assert(px.randomize()); // Randomize the transaction
        px.display(); // Calculate the expected result for checking
        return px.port; // Return the randomized transaction
    endfunction

    task generateTransactions(int numCycles);
        for (int i = 0; i < numCycles; i++) begin
            storeTransaction sx = generateStoreTransaction();
            int px = generatePort();
            bx_list = new[1];
            bx_list[0] = sx;
            ports = new[1];
            ports[0] = px;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #200ns;
        end
    endtask
endclass

`endif