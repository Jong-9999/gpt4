`timescale 1ns / 1ps

// SUBTASK B (2nd rightmost digit = 0)

module button_lock (
    input CLOCK,
    input ENABLE,           
    input btnU, btnD, btnL, btnR, btnC,
    output reg [6:0] seg,
    output reg [3:0] an,
    output UNLOCKED
);
    localparam [6:0] CHAR_U = 7'b1100011;   // seg c, d, e
    localparam [6:0] CHAR_D = 7'b0100001;   // seg b, c, d, e, g
    localparam [6:0] CHAR_L = 7'b1001111;   // seg e, f
    localparam [6:0] CHAR_R = 7'b0101111;   // seg e, g
    localparam [6:0] BLANK  = 7'b1111111;

    
    reg [4:0] btn_sync1 = 0, btn_sync2 = 0, btn_prev = 0;
    wire [4:0] btn_press = btn_sync2 & ~btn_prev;   

    reg [2:0] STEP = 0;    

    always @ (posedge CLOCK) begin
        btn_sync1 <= {btnC, btnR, btnL, btnD, btnU};
        btn_sync2 <= btn_sync1;
        btn_prev <= btn_sync2;

        if (ENABLE) begin
            case (STEP)
                3'd0: if (btn_press[0]) STEP <= 3'd1;   // BTNU
                3'd1: if (btn_press[1]) STEP <= 3'd2;   // BTND
                3'd2: if (btn_press[2]) STEP <= 3'd3;   // BTNL
                3'd3: if (btn_press[3]) STEP <= 3'd4;   // BTNR
                3'd4: if (btn_press[2]) STEP <= 3'd5;   // BTNL
                default: STEP <= 3'd5;
            endcase
        end
    end

    assign UNLOCKED = (STEP == 3'd5);

    always @ (*) begin
        if (!ENABLE) begin
            seg = BLANK;
            an = 4'b1111;
        end
        else begin
            case (STEP)
                3'd1: begin seg = CHAR_D; an = 4'b1101; end
                3'd2: begin seg = CHAR_L; an = 4'b1011; end
                3'd3: begin seg = CHAR_R; an = 4'b0111; end
                3'd4: begin seg = CHAR_L; an = 4'b1011; end
                default: begin seg = CHAR_U; an = 4'b1110; end   
            endcase
        end
    end
endmodule
