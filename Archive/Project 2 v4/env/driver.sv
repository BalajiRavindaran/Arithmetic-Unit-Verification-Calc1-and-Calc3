`ifndef DRIVER_DEFINED
`define DRIVER_DEFINED
`include "Transactions.sv"
// Include Sequencer
class driver;
    virtual dut_interface vim; // Assume `add_if` is your interface

    function new(virtual dut_interface vim);
        this.vim = vim;
    endfunction

    task setAllPortsToZero();
        vim.req1_cmd = 0;
        vim.req1_d1 = 0;
        vim.req1_d2 = 0;
        vim.req1_r1 = 0;
        vim.req1_tag = 0;
        vim.req1_data = 0;
        vim.req2_cmd = 0;
        vim.req2_d1 = 0;
        vim.req2_d2 = 0;
        vim.req2_r1 = 0;
        vim.req2_tag = 0;
        vim.req2_data = 0;
        vim.req3_cmd = 0;
        vim.req3_d1 = 0;
        vim.req3_d2 = 0;
        vim.req3_r1 = 0;
        vim.req3_tag = 0;
        vim.req3_data = 0;
        vim.req4_cmd = 0;
        vim.req4_d1 = 0;
        vim.req4_d2 = 0;
        vim.req4_r1 = 0;
        vim.req4_tag = 0;
        vim.req4_data = 0;
    endtask

    task driveToPort(baseTransaction sx, int port);
        if (port == 1) begin
            vim.req1_cmd = sx.cmd;
            vim.req1_d1 = sx.d1;
            vim.req1_d2 = sx.d2;
            vim.req1_r1 = sx.r1;
            vim.req1_tag = sx.tag;
            vim.req1_data = sx.data;
        end else if (port == 2) begin
            vim.req2_cmd = sx.cmd;
            vim.req2_d1 = sx.d1;
            vim.req2_d2 = sx.d2;
            vim.req2_r1 = sx.r1;
            vim.req2_tag = sx.tag;
            vim.req2_data = sx.data;
        end else if (port == 3) begin
            vim.req3_cmd = sx.cmd;
            vim.req3_d1 = sx.d1;
            vim.req3_d2 = sx.d2;
            vim.req3_r1 = sx.r1;
            vim.req3_tag = sx.tag;
            vim.req3_data = sx.data;
        end else begin
            vim.req4_cmd = sx.cmd;
            vim.req4_d1 = sx.d1;
            vim.req4_d2 = sx.d2;
            vim.req4_r1 = sx.r1;
            vim.req4_tag = sx.tag;
            vim.req4_data = sx.data;
        end
        $display("Driver -> Transaction Pushed to DUT on Port: %0d", port);
    endtask

    task drive(baseTransaction sx, int port);
        @(posedge vim.clk)
        driveToPort(sx, port);
        @(negedge vim.clk)
        setAllPortsToZero();
    endtask
endclass

`endif