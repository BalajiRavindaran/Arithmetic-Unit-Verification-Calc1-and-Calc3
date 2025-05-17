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

    function addTransaction generateAddTransaction();
        addTransaction ax = new();
        assert(ax.randomize()); // Randomize the transaction
        ax.display(); // Calculate the expected result for checking
        return ax; // Return the randomized transaction
    endfunction

    function subTransaction generateSubTransaction();
        subTransaction sx = new();
        assert(sx.randomize()); // Randomize the transaction
        sx.display(); // Calculate the expected result for checking
        return sx; // Return the randomized transaction
    endfunction

    function sllTransaction generateSLLTransaction();
        sllTransaction slx = new();
        assert(slx.randomize()); // Randomize the transaction
        slx.display(); // Calculate the expected result for checking
        return slx; // Return the randomized transaction
    endfunction

    function srlTransaction generateSRLTransaction();
        srlTransaction srx = new();
        assert(srx.randomize()); // Randomize the transaction
        srx.display(); // Calculate the expected result for checking
        return srx; // Return the randomized transaction
    endfunction

    function bzTransaction generateBZTransaction();
        bzTransaction bz = new();
        assert(bz.randomize()); // Randomize the transaction
        bz.display(); // Calculate the expected result for checking
        return bz; // Return the randomized transaction
    endfunction

    function beTransaction generateBETransaction();
        beTransaction be = new();
        assert(be.randomize()); // Randomize the transaction
        be.display(); // Calculate the expected result for checking
        return be; // Return the randomized transaction
    endfunction

    function int generatePort();
        portTransaction px = new();
        assert(px.randomize()); // Randomize the transaction
        px.display(); // Calculate the expected result for checking
        return px.port; // Return the randomized transaction
    endfunction

    task generateStoreFetchTransactionAllPorts();
        storeTransaction sx = generateStoreTransaction();
        fetchTransaction fx = generateFetchTransaction();
        fx.d1 = sx.r1;
        bx_list = new[4];
        bx_list[0] = sx;
        bx_list[1] = sx;
        bx_list[2] = sx;
        bx_list[3] = sx;
        ports = new[4];
        ports[0] = 1;
        ports[1] = 2;
        ports[2] = 3;
        ports[3] = 4;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);

        #200ns;

        bx_list = new[4];
        bx_list[0] = fx;
        bx_list[1] = fx;
        bx_list[2] = fx;
        bx_list[3] = fx;
        ports = new[4];
        ports[0] = 1;
        ports[1] = 2;
        ports[2] = 3;
        ports[3] = 4;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
    endtask

    task generateStoreTransactionSpecificPort(int p, int numCycles);
        for (int i = 0; i < numCycles*4; i++) begin
            storeTransaction sx = generateStoreTransaction();
            fetchTransaction fx = generateFetchTransaction();
            fx.d1 = sx.r1;
            bx_list = new[1];
            bx_list[0] = sx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #200ns;
            bx_list = new[1];
            bx_list[0] = fx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #200ns;
        end
    endtask

    task generateTransactions(int numCycles);
        
        generateStoreFetchTransactionAllPorts();

        #200ns;

        for (int i = 1; i < 5; i++) begin
            generateStoreTransactionSpecificPort(i, numCycles);
        end
    endtask
endclass

`endif