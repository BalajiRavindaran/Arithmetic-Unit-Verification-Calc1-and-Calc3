module Calculator_DUT (
    input logic clk,
    input logic reset,
    input logic [0:1] req_tag,
    input logic [0:3] req_cmd,
    input logic [0:3] req_d1,
    input logic [0:3] req_d2,
    input logic [0:3] req_r1,
    input logic [0:31] req_data,
    output logic [0:1] out_resp,
    output logic [0:1] out_tag,
    output logic [0:31] out_data
);

    logic [0:31] register_file [0:15]; // 16 registers of 32 bits each
    logic skip_next_command; // Flag to indicate skipping the next command

    localparam CMD_ADD = 4'b0001;
    localparam CMD_SUBTRACT = 4'b0010;
    localparam CMD_SHIFT_LEFT = 4'b0101;
    localparam CMD_SHIFT_RIGHT = 4'b0110;
    localparam CMD_STORE = 4'b1001;
    localparam CMD_FETCH = 4'b1010;
    localparam CMD_BRANCH_IF_ZERO = 4'b1100;
    localparam CMD_BRANCH_IF_EQUAL = 4'b1101;

    assign out_tag = req_tag;

    //initial begin
        //for (int i = 0; i < 16; i++) begin
            //register_file[i] = i;
        //end
    //end

    always_ff @(posedge clk or posedge reset) begin
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
            case (req_cmd)
                CMD_ADD, CMD_SUBTRACT, CMD_SHIFT_LEFT, CMD_SHIFT_RIGHT, CMD_STORE, CMD_FETCH: begin
                    if (req_cmd == CMD_ADD) begin
                        if (register_file[req_d1] + register_file[req_d2] > 32'hFFFFFFFF) begin
                            out_resp <= 2'b10; // Overflow error
                        end else begin
                            register_file[req_r1] = register_file[req_d1] + register_file[req_d2];
                            out_data <= register_file[req_r1];
                            out_resp <= 2'b01;
                        end
                    end
                    else if (req_cmd == CMD_SUBTRACT) begin
                        if (register_file[req_d1] < register_file[req_d2]) begin
                            out_resp <= 2'b10; // Underflow error
                        end else begin
                            register_file[req_r1] = register_file[req_d1] - register_file[req_d2];
                            out_data <= register_file[req_r1];
                            out_resp <= 2'b01;
                        end
                    end
                    else if (req_cmd == CMD_SHIFT_LEFT) begin
                        register_file[req_r1] = register_file[req_d1] << req_d2;
                        out_data <= register_file[req_r1];
                        out_resp <= 2'b01;
                    end
                    else if (req_cmd == CMD_SHIFT_RIGHT) begin
                        register_file[req_r1] = register_file[req_d1] >> req_d2;
                        out_data <= register_file[req_r1];
                        out_resp <= 2'b01;
                    end
                    else if (req_cmd == CMD_STORE) begin
                        register_file[req_r1] = req_data;
                        out_data <= register_file[req_r1];
                        out_resp <= 2'b01;
                    end
                    else if (req_cmd == CMD_FETCH) begin
                        out_data <= register_file[req_d1];
                        out_resp <= 2'b01;
                    end
                end
                CMD_BRANCH_IF_ZERO: begin
                    if (register_file[req_d1] == 0) begin
                        skip_next_command <= 1;
                        out_resp <= 2'b11;
                    end else begin
                        out_resp <= 2'b01;
                    end
                end
                CMD_BRANCH_IF_EQUAL: begin
                    if (register_file[req_d1] == register_file[req_d2]) begin
                        skip_next_command <= 1;
                        out_resp <= 2'b11;
                    end else begin
                        out_resp <= 2'b01;
                    end
                end
                default: begin
                    out_resp = 2'b00; // Invalid command
                end
            endcase
        end
    end

endmodule
