module collision_unit #(
    parameter int BIRD_X      = 120,
    parameter int BIRD_W      = 24,
    parameter int BIRD_H      = 24,
    parameter int PIPE_WIDTH  = 60,
    parameter int GAP_HEIGHT  = 120,
    parameter int GROUND_Y    = 430
) (
    input  logic signed [10:0] bird_y,
    input  logic [9:0]         pipe_x,
    input  logic [9:0]         gap_y,
    output logic               collision
);

    logic signed [10:0] bird_top, bird_bottom;
    logic [9:0] bird_left, bird_right;
    logic [9:0] pipe_left, pipe_right;
    logic x_overlap;
    logic hit_top_pipe, hit_bottom_pipe;
    logic hit_pipe, hit_floor, hit_ceiling;

    always_comb begin
        bird_top    = bird_y;
        bird_bottom = bird_y + BIRD_H;

        bird_left   = BIRD_X;
        bird_right  = BIRD_X + BIRD_W;

        pipe_left   = pipe_x;
        pipe_right  = pipe_x + PIPE_WIDTH;

        hit_ceiling = (bird_top <= 0);
        hit_floor   = (bird_bottom >= GROUND_Y);

        x_overlap = (bird_right >= pipe_left) && (bird_left <= pipe_right);

        hit_top_pipe    = x_overlap && (bird_top <= gap_y);
        hit_bottom_pipe = x_overlap && (bird_bottom >= (gap_y + GAP_HEIGHT));

        hit_pipe  = hit_top_pipe || hit_bottom_pipe;
        collision = hit_ceiling || hit_floor || hit_pipe;
    end

endmodule