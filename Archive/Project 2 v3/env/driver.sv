`ifndef DRIVER_DEFINED
`define DRIVER_DEFINED
`include "storeTransaction.sv"
// Include Sequencer
class driver;
    virtual dut_interface vim; // Assume `add_if` is your interface

    function new(virtual dut_interface vim);
        this.vim = vim;
    endfunction

    // Drive a transaction to the DUT
    task drive(storeTransaction sx);
        vim.req1_cmd = sx.cmd;
        vim.req1_r1 = sx.r1;
        vim.req1_tag = sx.tag;
        vim.req1_data = sx.data;
        // Add timing control or signal toggles as required by your protocol
    endtask
endclass

`endif