`timescale 1ns / 1ps

module led_sequence (
    input CLOCK,
    output [7:0] LEDS,
    output DONE
);
    localparam [27:0] TIME_COUNT = 28'd175_000_000; // 1.75 s

    reg [27:0] COUNT = 0;
    reg [3:0] NUM_ON = 0;

    always @ (posedge CLOCK) begin
        if (NUM_ON < 8) begin
            if (COUNT == TIME_COUNT - 1) begin
                COUNT <= 0;
                NUM_ON <= NUM_ON + 1;
            end
            else begin
                COUNT <= COUNT + 1;
            end
        end
    end

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_leds
            assign LEDS[i] = (NUM_ON > i);
        end
    endgenerate

    assign DONE = (NUM_ON == 8);
endmodule
