`include "Transactions.sv"
`ifndef CONTAINER_DEFINED
`define CONTAINER_DEFINED

class TransactionContainer;
    baseTransaction transactions[];
    int ports[];

    function new(baseTransaction txns[], int prts[]);
        this.transactions = txns;
        this.ports = prts;
    endfunction
endclass

`endif