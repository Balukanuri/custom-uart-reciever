// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module uart_rx_tb;

    reg clk = 0;
    reg reset = 1;
    reg rx = 1;
    wire [7:0] data_out;
    wire rx_done;

    uart_rx uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    always #5 clk = ~clk; // 10ns clock

    integer i;
    reg [7:0] byte_to_send;

    initial begin
        $dumpfile("uart_rx_wave.vcd");
        $dumpvars(0, uart_rx_tb);

        byte_to_send = 8'hA5;

        #100;
        reset = 0;
        #200;

        // Start bit
        rx = 0;
        #(160);

        // Send LSB-first bits
        for (i = 0; i < 8; i = i + 1) begin
            rx = byte_to_send[i];
            #(160);
        end

        // Stop bit
        rx = 1;
        #(160);

        #500;

        $display("DEBUG: Time=%0t | rx_done=%b | data_out=%h | expected=%h", $time, rx_done, data_out, byte_to_send);

        if (rx_done == 1'b1 && data_out == byte_to_send) begin
            $display("✅ PASS: Received = %h", data_out);
        end else begin
            $display("❌ FAIL: Got = %h | Expected = %h", data_out, byte_to_send);
        end

        $finish;
    end
endmodule
Added testbench from EDA Playground
