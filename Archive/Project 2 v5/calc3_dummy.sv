class calc3_dummy;

    logic [3:0] req_cmd[4], req_d1[4], req_d2[4], req_r1[4];
    logic [1:0] req_tag[4];
    logic [31:0] req_data[4];
    logic [1:0] out_resp[4], out_tag[4];
    logic [31:0] out_data[4];
    logic [31:0] register_file [15:0];
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
    function void execute_commands();
        for (int i = 0; i < 4; i++) begin
            if (!skip_next_command[i]) begin
                case (req_cmd[i])
                    CMD_ADD: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] + register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                    end
                    CMD_SUBTRACT: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] - register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                    end
                    CMD_SHIFT_LEFT: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] << register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                    end
                    CMD_SHIFT_RIGHT: begin
                        register_file[req_r1[i]] = register_file[req_d1[i]] >> register_file[req_d2[i]];
                        out_resp[i] = 2'b01;
                    end
                    CMD_STORE: begin
                        register_file[req_r1[i]] = req_data[i];
                        out_resp[i] = 2'b01;
                    end
                    CMD_FETCH: begin
                        out_data[i] = register_file[req_d1[i]];
                        out_resp[i] = 2'b01;
                    end
                    CMD_BRANCH_IF_ZERO: begin
                        skip_next_command[i] = (register_file[req_d1[i]] == 0);
                        out_resp[i] = 2'b01;
                    end
                    CMD_BRANCH_IF_EQUAL: begin
                        skip_next_command[i] = (register_file[req_d1[i]] == register_file[req_d2[i]]);
                        out_resp[i] = 2'b01;
                    end
                    default: begin
                        out_resp[i] = 2'b10; // Invalid command
                    end
                endcase
            end else begin
                // Skip this cycle's command
                skip_next_command[i] = 0;
                out_resp[i] = 2'b11;
            end
            out_tag[i] = req_tag[i]; // Echo back the tag
        end
    endfunction

endclass
