`ifndef SEQUENCER_DEFINED
`define SEQUENCER_DEFINED
`include "storeTransaction.sv"
// Include Transaction
class sequencer;
    // Method to generate and randomize a transaction
    function storeTransaction generateStoreTransaction();
        storeTransaction sx = new();
        assert(sx.randomize()); // Randomize the transaction
        sx.display(); // Calculate the expected result for checking
        return sx; // Return the randomized transaction
    endfunction
endclass

`endif