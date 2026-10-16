wire clock_1hz;
wire clock_2hz;

clock_divider #(.M(49_999_999)) divider_1hz (
    .CLOCK(clk),        // 100 MHz input
    .SLOW_CLOCK(clock_1hz)
);

clock_divider #(.M(24_999_999)) divider_2hz (
    .CLOCK(clk),        // 100 MHz input
    .SLOW_CLOCK(clock_2hz)
);

usage of clock scaler
