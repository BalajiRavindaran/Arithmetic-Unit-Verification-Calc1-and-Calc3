//////////////////////////////////////////////////////////////////////////////////
// Sequencer: Verification Component                                            //
// Date: 2024-04-15                                                            //
//                                                                              //
// Description:                                                                 //
// The `sequencer` class is responsible for generating a stream of randomized   //
// transaction objects to mimic stimulus that would be encountered in a real-    //
// world scenario. It is capable of generating various types of transactions    //
// (store, fetch, arithmetic operations, etc.) and directing them to the        //
// appropriate verification components via a mailbox mechanism.                 //
//                                                                              //
// Authors: Balaji Ravindaran, Nitish Sundarraj, Adil Manzoor                  //
//                                                                              //
// Revision History:                                                            //
// - 2024-04-15: Initial release of the `sequencer` class. Provides enhanced   //
//               transaction generation capabilities for thorough verification  //
//               of the DUT.                                                    //
//                                                                              //
// Notes:                                                                       //
// - The `sequencer` is pivotal for producing a varied and randomized sequence  //
//   of operations to effectively challenge the DUT.                            //
// - It interfaces with `TransactionContainer` objects to encapsulate multiple  //
//   transactions and port information for processing by the driver.            //
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// Course: COEN 6541
// Concordia University Montreal
//////////////////////////////////////////////////////////////////////////////

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

    function int generateCmd();
        commandTransaction cx = new();
        assert(cx.randomize()); // Randomize the transaction
        return cx.cmd; // Return the randomized transaction
    endfunction

    task generateStoreFetchTransactionAllPorts();
        storeTransaction sx = generateStoreTransaction();
        fetchTransaction fx = generateFetchTransaction();
        addTransaction ax = generateAddTransaction();
        subTransaction sux = generateSubTransaction();
        sllTransaction slx = generateSLLTransaction();
        srlTransaction srx = generateSRLTransaction();

        fx.d1 = sx.r1;
        ax.d1 = sx.r1;
        ax.d2 = sx.r1;
        sux.d1 = sx.r1;
        sux.d2 = sx.r1;
        slx.d1 = sx.r1;
        slx.d2 = sx.r1;
        srx.d1 = sx.r1;
        srx.d2 = sx.r1;

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
        #200ns;

        bx_list = new[4];
        bx_list[0] = ax;
        bx_list[1] = ax;
        bx_list[2] = ax;
        bx_list[3] = ax;
        ports = new[4];
        ports[0] = 1;
        ports[1] = 2;
        ports[2] = 3;
        ports[3] = 4;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;

        bx_list = new[4];
        bx_list[0] = sux;
        bx_list[1] = sux;
        bx_list[2] = sux;
        bx_list[3] = sux;
        ports = new[4];
        ports[0] = 1;
        ports[1] = 2;
        ports[2] = 3;
        ports[3] = 4;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;

        bx_list = new[4];
        bx_list[0] = slx;
        bx_list[1] = slx;
        bx_list[2] = slx;
        bx_list[3] = slx;
        ports = new[4];
        ports[0] = 1;
        ports[1] = 2;
        ports[2] = 3;
        ports[3] = 4;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;

        bx_list = new[4];
        bx_list[0] = srx;
        bx_list[1] = srx;
        bx_list[2] = srx;
        bx_list[3] = srx;
        ports = new[4];
        ports[0] = 1;
        ports[1] = 2;
        ports[2] = 3;
        ports[3] = 4;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;
    endtask

    task generateAllZeroStoreTransaction();
        for (int i = 0; i < 16; i++) begin
            storeTransaction sx = generateStoreTransaction();
            sx.r1 = i;
            sx.data = 0;
            bx_list = new[1];
            bx_list[0] = sx;
            ports = new[1];
            ports[0] = 1;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #200ns;
        end
    endtask

    task generateConsecutiveBZStoreFetchTransaction(int numCycles);
    for (int p = 1; p < 5; p++) begin
        for (int i = 0; i < numCycles*4; i++) begin
            bzTransaction bx = generateBZTransaction();
            storeTransaction sx = generateStoreTransaction();
            fetchTransaction fx = generateFetchTransaction();
            bx.tag = 0;
            sx.tag = 1;
            fx.tag = 2;
            fx.d1 = sx.r1;
            bx_list = new[1];
            bx_list[0] = bx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #40ns;
            bx_list = new[1];
            bx_list[0] = sx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #40ns;
            bx_list = new[1];
            bx_list[0] = fx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #200ns;
        end
    end
    endtask

    task generateConsecutiveBEStoreFetchTransaction(int numCycles);
    for (int p = 1; p < 5; p++) begin
        for (int i = 0; i < numCycles*4; i++) begin
            beTransaction bx = generateBETransaction();
            storeTransaction sx = generateStoreTransaction();
            fetchTransaction fx = generateFetchTransaction();
            bx.tag = 0;
            sx.tag = 1;
            fx.tag = 2;
            fx.d1 = sx.r1;
            bx_list = new[1];
            bx_list[0] = bx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #40ns;
            bx_list = new[1];
            bx_list[0] = sx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #40ns;
            bx_list = new[1];
            bx_list[0] = fx;
            ports = new[1];
            ports[0] = p;
            container = new(bx_list, ports);
            sequencerToDriver.put(container);
            #200ns;
        end
    end
    endtask

    task generateStoreTransactionSpecificPort(int numCycles);
    for (int p = 1; p < 5; p++) begin
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
    end
    endtask

    task generateTransactionForCommand(int port, int cmd);
    if (cmd == 1) begin
        addTransaction ax = generateAddTransaction();
        bx_list = new[1];
        bx_list[0] = ax;
        ports = new[1];
        ports[0] = port;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;
    end else if (cmd == 2) begin
        subTransaction sx = generateSubTransaction();
        bx_list = new[1];
        bx_list[0] = sx;
        ports = new[1];
        ports[0] = port;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;
    end else if (cmd == 5) begin
        sllTransaction sllx = generateSLLTransaction();
        bx_list = new[1];
        bx_list[0] = sllx;
        ports = new[1];
        ports[0] = port;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;
    end else if (cmd == 6) begin
        srlTransaction srlx = generateSRLTransaction();
        bx_list = new[1];
        bx_list[0] = srlx;
        ports = new[1];
        ports[0] = port;
        container = new(bx_list, ports);
        sequencerToDriver.put(container);
        #200ns;
    end
    endtask

    task generateAddSubSllSrlTransactionRandomOrderRandomPort(int numCycles);
    for (int p = 1; p < 5; p++) begin
        for (int i = 0; i < numCycles*4; i++) begin
            int cmd = generateCmd();
            generateTransactionForCommand(p, cmd);
        end
    end
    endtask

    task generateTransactions(int numCycles);
        
        generateStoreFetchTransactionAllPorts();

        generateAllZeroStoreTransaction();

        generateConsecutiveBZStoreFetchTransaction(numCycles);

        generateConsecutiveBEStoreFetchTransaction(numCycles);

        generateStoreTransactionSpecificPort(numCycles);

        generateAddSubSllSrlTransactionRandomOrderRandomPort(numCycles);
    endtask
endclass

`endif