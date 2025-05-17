module calc3_dummy (
    input logic clk,
    input logic reset,
    input logic [0:3] req_cmd[4], req_d1[4], req_d2[4], req_r1[4];
    input logic [0:1] req_tag[4];
    input logic [0:31] req_data[4];

    output logic [0:1] out_resp[4], out_tag[4];
    output logic [0:31] out_data[4];
);

    logic [0:31] register_file [0:15];

    logic skip_next_command; // Flag to indicate skipping the next command

    localparam CMD_ADD = 4'b0001;
    localparam CMD_SUBTRACT = 4'b0010;
    localparam CMD_SHIFT_LEFT = 4'b0101;
    localparam CMD_SHIFT_RIGHT = 4'b0110;
    localparam CMD_STORE = 4'b1001;
    localparam CMD_FETCH = 4'b1010;
    localparam CMD_BRANCH_IF_ZERO = 4'b1100;
    localparam CMD_BRANCH_IF_EQUAL = 4'b1101;

    //always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 16; i++) begin
                register_file[i] <= 0;
            end
            skip_next_command <= 0;
        end 
        else if (skip_next_command) begin
            out_resp <= 2'b11; // Command skipped
            skip_next_command <= 0; // Reset skip flag
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                case (req_cmd[i])
                    CMD_ADD, CMD_SUBTRACT, CMD_SHIFT_LEFT, CMD_SHIFT_RIGHT, CMD_STORE, CMD_FETCH: begin
                        if (req_cmd[i] == CMD_ADD) begin
                            if (register_file[req_d1[i]] + register_file[req_d2[i]] > 32'hFFFFFFFF) begin
                                out_resp[i] <= 2'b10; // Overflow error
                                out_tag[i] <= req_tag[i];
                            end else begin
                                register_file[req_r1[i]] = register_file[req_d1[i]] + register_file[req_d2[i]];
                                out_data[i] <= register_file[req_r1[i]];
                                out_resp[i] <= 2'b01;
                                out_tag[i] <= req_tag[i];
                            end
                        end
                        else if (req_cmd[i] == CMD_SUBTRACT) begin
                            if (register_file[req_d1[i]] < register_file[req_d2[i]]) begin
                                out_resp[i] <= 2'b10; // Underflow error
                                out_tag[i] <= req_tag[i];
                            end else begin
                                register_file[req_r1[i]] = register_file[req_d1[i]] - register_file[req_d2[i]];
                                out_data[i] <= register_file[req_r1[i]];
                                out_resp[i] <= 2'b01;
                                out_tag[i] <= req_tag[i];
                            end
                        end
                        else if (req_cmd[i] == CMD_SHIFT_LEFT) begin
                            register_file[req_r1[i]] = register_file[req_d1[i]] << register_file[req_d2[i][27:31]];
                            out_data[i] <= register_file[req_r1[i]];
                            out_resp[i] <= 2'b01;
                            out_tag[i] <= req_tag[i];
                        end
                        else if (req_cmd[i] == CMD_SHIFT_RIGHT) begin
                            register_file[req_r1[i]] = register_file[req_d1[i]] >> register_file[req_d2[i][27:31]];
                            out_data[i] <= register_file[req_r1[i]];
                            out_resp[i] <= 2'b01;
                            out_tag[i] <= req_tag[i];
                        end
                        else if (req_cmd[i] == CMD_STORE) begin
                            register_file[req_r1[i]] = req_data[i];
                            out_resp[i] <= 2'b11;
                            out_tag[i] <= req_tag[i];
                        end
                        else if (req_cmd[i] == CMD_FETCH) begin
                            out_data[i] <= register_file[req_d1[i]];
                            out_resp[i] <= 2'b01;
                            out_tag[i] <= req_tag[i];
                        end
                    end
                    CMD_BRANCH_IF_ZERO: begin
                        if (register_file[req_d1[i]] == 0) begin
                            skip_next_command <= 1;
                            out_tag[i] <= req_tag[i];
                        end
                    end
                    CMD_BRANCH_IF_EQUAL: begin
                        if (register_file[req_d1[i]] == register_file[req_d2[i]]) begin
                            skip_next_command <= 1;
                            out_tag[i] <= req_tag[i];
                        end
                    end
                    default: begin
                        out_resp[i] <= 2'b00; // Invalid commands
                    end
                endcase
            end
        end
    //end


endmodule