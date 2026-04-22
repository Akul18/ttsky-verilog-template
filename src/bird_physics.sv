module bird_physics #(
    parameter int SCREEN_H      = 480,
    parameter int GROUND_Y      = 430,
    parameter int BIRD_START_Y  = 200,
    parameter int GRAVITY       = 1,
    parameter int JUMP_IMPULSE  = -6
) (
    input  logic        clk,
    input  logic        reset,
    input  logic        tick,
    input  logic        game_active,
    input  logic        flap_pulse,
    output logic signed [10:0] bird_y,
    output logic signed [10:0] bird_vy
);
    logic signed [10:0] next_vy, next_y;

    always_comb begin
        next_vy = bird_vy + GRAVITY;
        if (flap_pulse)
            next_vy = JUMP_IMPULSE;

        next_y = bird_y + next_vy;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            bird_y  <= BIRD_START_Y;
            bird_vy <= 0;
        end else if (!game_active) begin
            bird_y  <= BIRD_START_Y;
            bird_vy <= 0;
        end else if (tick) begin
            bird_y  <= next_y;
            bird_vy <= next_vy;
        end
    end
endmodule
