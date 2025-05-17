`include "TransactionContainer.sv"
`include "calc3_dummy.sv"
`include "Transactions.sv"

`include "checker.sv"

class scoreboard;
    virtual dut_interface vim;
    TransactionContainer tx;
    calc3_dummy cl3d;
    baseTransaction bx;

    PortChecker pc;

    logic [0:31] regdata [0:2];

    logic [0:1] dum_tag;

    function new(virtual dut_interface vim);
        this.vim = vim;
        this.cl3d = new();
        this.pc = new();
        this.bx = new();
    endfunction

    task receiveTransactionScoreboard(TransactionContainer tx);
        
        //this.tx = tx;
        foreach (tx.transactions[i]) begin
            bx = tx.transactions[i];
            $display("This is the value of i: %d", tx.ports[i]);
            cl3d.req_cmd[tx.ports[i-1]] = bx.cmd;
            cl3d.req_data[tx.ports[i-1]] = bx.data;  // Data to store
            cl3d.req_r1[tx.ports[i-1]] = bx.r1;  // Register to store into
            cl3d.req_tag[tx.ports[i-1]] = bx.tag;
            cl3d.req_d1[tx.ports[i-1]] = bx.d1;  // Register to read from
            cl3d.req_d2[tx.ports[i-1]] = bx.d2;  // Register to read from
            //#20ns;
        
            // if (tx.ports[i] == 1) begin
            // wait (vim.out1_resp == 2'b01 || vim.out1_resp == 2'b10 || vim.out1_resp == 2'b11);
            // end
            // else if (tx.ports[i] == 2) begin
            // wait (vim.out2_resp == 2'b01 || vim.out2_resp == 2'b10 || vim.out2_resp == 2'b11);
            // end
            // else if (tx.ports[i] == 3) begin
            // wait (vim.out3_resp == 2'b01 || vim.out3_resp == 2'b10 || vim.out3_resp == 2'b11);
            // end
            // else if (tx.ports[i] == 4) begin
            // wait (vim.out4_resp == 2'b01 || vim.out4_resp == 2'b10 || vim.out4_resp == 2'b11);
            // end
            cl3d.execute_commands(regdata, dum_tag);

            if (tx.ports[i] == 1) begin
            pc.set_actual(i, vim.out1_data, vim.out1_resp, vim.out1_tag);
            end
            else if (tx.ports[i] == 2) begin
            pc.set_actual(i, vim.out2_data, vim.out2_resp, vim.out2_tag);
            end
            else if (tx.ports[i] == 3) begin
            pc.set_actual(i, vim.out3_data, vim.out3_resp, vim.out3_tag);
            end
            else if (tx.ports[i] == 4) begin
            pc.set_actual(i, vim.out4_data, vim.out4_resp, vim.out4_tag);
            end


            pc.set_expected(i, cl3d.out_data[i], cl3d.out_resp[i], cl3d.out_tag[i]);
            $display("COMMAND SENT: %h", cl3d.req_cmd[i]);
            $display("Scoreboard -> Time: %t Data Sent to Dummy DUT -> Cmd=%b, Data=%d, R1=%d, D1=%d, D2=%d, Tag=%d", $time, bx.cmd, bx.data, bx.r1, bx.d1, bx.d2, bx.tag);
            $display("Scoreboard -> Time: %t Current Register Values in Dummy DUT: Command: %b, D1 = %d, D2 = %d, R1 = %d, Tag: %d",$time, bx.cmd, regdata[0], regdata[1], regdata[2], cl3d.req_tag[i]);
            //$display("Command Sent %b", cl3d.req_cmd[i]);
            pc.check_results();
            
        end

    endtask
endclass