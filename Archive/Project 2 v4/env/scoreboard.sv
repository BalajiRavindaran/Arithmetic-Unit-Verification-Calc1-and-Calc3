`include "TransactionContainer.sv"

class scoreboard;
    virtual dut_interface vim;
    TransactionContainer tx; 

    function new(virtual dut_interface vim);
        this.vim = vim;
    endfunction

    function void receiveTransactionScoreboard(TransactionContainer tx);
        this.tx = tx;
        $display("Scoreboard -> Transaction Received -> Size: %0d", tx.transactions.size());
    endfunction
endclass