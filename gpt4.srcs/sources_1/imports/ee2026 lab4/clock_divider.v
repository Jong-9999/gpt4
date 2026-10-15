`timescale 1ns / 1ps

// f_out = 100_000_000 / (2 * (M + 1))  ->  M = 100_000_000 / (2 * f_out) - 1
module clock_divider #(parameter [31:0] M = 49_999_999) (
    input CLOCK,
    output reg SLOW_CLOCK = 0
);
    reg [31:0] COUNT = 0;

    always @ (posedge CLOCK) begin
        COUNT <= (COUNT == M) ? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule
