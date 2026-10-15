`timescale 1ns / 1ps

// A0322207U
// 1st rightmost digit = 7 (Subtask A), 2nd rightmost digit = 0 (Subtask B)
module gpt4_top (
    input clk,
    input [15:0] sw,
    input btnC, btnU, btnL, btnR, btnD,
    output [15:0] led,
    output [6:0] seg,
    output dp,
    output [3:0] an
);
    wire [7:0] seq_leds;
    wire done;
    wire unlocked;
    wire clk_0p25hz, clk_5hz, clk_23hz;

    // Subtask A: LD0 to LD7 turn ON every 1.75 s
    led_sequence subtask_a (.CLOCK(clk), .LEDS(seq_leds), .DONE(done));

    // M = 100_000_000 / (2 * f) - 1
    clock_divider #(.M(32'd199_999_999)) div_0p25hz (.CLOCK(clk), .SLOW_CLOCK(clk_0p25hz));
    clock_divider #(.M(32'd9_999_999))   div_5hz    (.CLOCK(clk), .SLOW_CLOCK(clk_5hz));
    clock_divider #(.M(32'd2_173_912))   div_23hz   (.CLOCK(clk), .SLOW_CLOCK(clk_23hz));   // 22.99999 Hz

    // Subtask B
    button_lock subtask_b (
        .CLOCK(clk), .ENABLE(done),
        .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .btnC(btnC),
        .seg(seg), .an(an), .UNLOCKED(unlocked)
    );

    assign led[0] = seq_leds[0];
    assign led[1] = seq_leds[1];
    assign led[2] = (done && !sw[4] && !sw[3] && sw[2]) ? clk_0p25hz : seq_leds[2];
    assign led[3] = (done && !sw[4] && sw[3]) ? clk_5hz : seq_leds[3];
    assign led[4] = (done && sw[4]) ? clk_23hz : seq_leds[4];
    assign led[7:5] = seq_leds[7:5];
    assign led[14:8] = 7'b0;
    assign led[15] = unlocked;

    assign dp = 1'b1;  
endmodule
