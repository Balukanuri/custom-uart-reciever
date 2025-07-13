// Code your design here
`timescale 1ns/1ps

module uart_rx (
    input clk,
    input reset,
    input rx,
    output reg [7:0] data_out,
    output reg rx_done
);
    parameter BIT_TIME = 16;

    reg [7:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [7:0] shift_reg = 0;
    reg [2:0] state = 0;

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3, DONE = 4;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= 0;
            data_out <= 0;
            rx_done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    rx_done <= 0;
                    if (rx == 0) begin // start bit detected
                        clk_count <= 0;
                        state <= START;
                    end
                end

                START: begin
                    clk_count <= clk_count + 1;
                    if (clk_count == (BIT_TIME / 2)) begin
                        clk_count <= 0;
                        bit_index <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    clk_count <= clk_count + 1;
                    if (clk_count == BIT_TIME) begin
                        clk_count <= 0;
                        shift_reg[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                        if (bit_index == 7)
                            state <= STOP;
                    end
                end

                STOP: begin
                    clk_count <= clk_count + 1;
                    if (clk_count == BIT_TIME) begin
                        clk_count <= 0;
                        state <= DONE;
                    end
                end

                DONE: begin
                    data_out <= shift_reg;
                    rx_done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
Added design from EDA Playground
