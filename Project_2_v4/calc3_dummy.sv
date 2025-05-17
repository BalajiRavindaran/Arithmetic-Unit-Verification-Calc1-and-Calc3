class calc3_dummy;

    logic [0:3] req_cmd[4], req_d1[4], req_d2[4], req_r1[4];
    logic [0:1] req_tag[4];
    logic [0:31] req_data[4];
    logic [0:1] out_resp[4], out_tag[4];
    logic [0:31] out_data[4];
    logic [0:31] register_file [0:15];
    bit skip_next_command[4]; // Array to indicate skipping the next command for each port

    localparam CMD_ADD = 4'b0001;
    localparam CMD_SUBTRACT = 4'b0010;
    localparam CMD_SHIFT_LEFT = 4'b0101;
    localparam CMD_SHIFT_RIGHT = 4'b0110;
    localparam CMD_STORE = 4'b1001;
    localparam CMD_FETCH = 4'b1010;
    localparam CMD_BRANCH_IF_ZERO = 4'b1100;
    localparam CMD_BRANCH_IF_EQUAL = 4'b1101;

    function new();
        skip_next_command = '{default:0};
        register_file = '{default:0};
    endfunction

    // Simulate command execution per clock cycle
    task execute_commands(ref logic [0:31] regdata [0:2], ref logic [0:1] dum_tag);
    $display("%t Dummy DUT Last Known Input Values: Req Tag: %p, Command: %p", $time, req_tag, req_cmd);
        for (int i = 0; i < 4; i++) begin
            if (!skip_next_command[i]) begin
                case (req_cmd[i])
                    CMD_ADD: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] + register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                        regdata[2] = register_file[req_r1[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        out_data[i] = 0;
                    end
                    CMD_SUBTRACT: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] - register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                        regdata[2] = register_file[req_r1[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        out_data[i] = 0;
                    end
                    CMD_SHIFT_LEFT: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] << register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                        regdata[2] = register_file[req_r1[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        out_data[i] = 0;
                    end
                    CMD_SHIFT_RIGHT: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] >> register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                        regdata[2] = register_file[req_r1[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        out_data[i] = 0;
                    end
                    CMD_STORE: begin
                        register_file[req_r1[i]] = req_data[i];
                        out_resp[i] = 2'b01;
                        //$display("DUMMY -> RECEIVED DATA, DATA: %d", register_file[req_r1[i]]);
                        regdata[2] = register_file[req_r1[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        //$display("%t Outtag in DUT is %d", $time, out_tag[i]);
                        //$display("%t Dumtag in DUT is %d", $time, dum_tag);
                        out_data[i] = 0;
                    end
                    CMD_FETCH: begin
                        out_data[i] = register_file[req_d1[i]];
                        out_resp[i] = 2'b01;
                        regdata[0] = register_file[req_d1[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        //$display("%t Outtag in DUT is %d", $time, out_tag[i]);
                        //$display("%t Dumtag in DUT is %d", $time, dum_tag);
                    end
                    CMD_BRANCH_IF_ZERO: begin
                        skip_next_command[i] = (register_file[req_d1[i]] == 0);
                        out_resp[i] = 2'b01;
                        regdata[0] = register_file[req_d1[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        out_data[i] = 1;
                    end
                    CMD_BRANCH_IF_EQUAL: begin
                        skip_next_command[i] = (register_file[req_d1[i]] == register_file[req_d2[i]]);
                        out_resp[i] = 2'b01;
                        regdata[0] = register_file[req_d1[i]];
                        regdata[1] = register_file[req_d2[i]];
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        out_data[i] = 1;
                    end
                    default: begin
                        out_resp[i] = 2'b00; // Invalid command
                        out_tag[i] = req_tag[i]; // Echo back the tag
                        dum_tag = out_tag[i];
                        out_data[i] = 0;
                    end
                endcase
            end else begin
                // Skip this cycle's command
                skip_next_command[i] = 0;
                out_resp[i] = 2'b11;
                out_tag[i] = req_tag[i]; // Echo back the tag
                dum_tag = out_tag[i];
                out_data[i] = 0;
            end
        end
    endtask

endclass
