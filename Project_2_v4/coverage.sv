// Create Coverage

`include "interface.sv"

module coverage_model(dut_interface vim);
    covergroup cg_with @(negedge vim.clk);
        // Request tag coverpoints
        cp_req_tag_1: coverpoint vim.req1_tag {
            bins responses[] = {[0:3]};
        }
        cp_req_tag_2: coverpoint vim.req2_tag {
            bins responses[] = {[0:3]};
        }
        cp_req_tag_3: coverpoint vim.req3_tag {
            bins responses[] = {[0:3]};
        }
        cp_req_tag_4: coverpoint vim.req4_tag {
            bins responses[] = {[0:3]};
        }

        // R1 coverpoints for each port
        cp_r1_1: coverpoint vim.req1_r1 {
            bins r1_bins[] = {[0:15]};
        }
        cp_r1_2: coverpoint vim.req2_r1 {
            bins r1_bins[] = {[0:15]};
        }
        cp_r1_3: coverpoint vim.req3_r1 {
            bins r1_bins[] = {[0:15]};
        }
        cp_r1_4: coverpoint vim.req4_r1 {
            bins r1_bins[] = {[0:15]};
        }

        cp_d1_1: coverpoint vim.req1_d1 {
            bins d1_bins[] = {[0:15]};
        }
        cp_d1_2: coverpoint vim.req2_d1 {
            bins d1_bins[] = {[0:15]};
        }
        cp_d1_3: coverpoint vim.req3_d1 {
            bins d1_bins[] = {[0:15]};
        }
        cp_d1_4: coverpoint vim.req4_d1 {
            bins d1_bins[] = {[0:15]};
        }

        cp_d2_1: coverpoint vim.req1_d2 {
            bins d2_bins[] = {[0:15]};
        }
        cp_d2_2: coverpoint vim.req2_d2 {
            bins d2_bins[] = {[0:15]};
        }
        cp_d2_3: coverpoint vim.req3_d2 {
            bins d2_bins[] = {[0:15]};
        }
        cp_d2_4: coverpoint vim.req4_d2 {
            bins d2_bins[] = {[0:15]};
        }

        // Response tag coverpoints
        cp_resp_tag_1: coverpoint vim.out1_tag {
            bins responses[] = {[0:3]};
        }
        cp_resp_tag_2: coverpoint vim.out2_tag {
            bins responses[] = {[0:3]};
        }
        cp_resp_tag_3: coverpoint vim.out3_tag {
            bins responses[] = {[0:3]};
        }
        cp_resp_tag_4: coverpoint vim.out4_tag {
            bins responses[] = {[0:3]};
        }
    endgroup

    cg_with cg;  // Declare the covergroup instance

    initial begin
        cg = new();  // Instantiate the covergroup
    end
endmodule