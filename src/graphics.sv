// Renderer
module renderer #(
    parameter int SCREEN_W   = 640,
    parameter int SCREEN_H   = 480,
    parameter int BIRD_X     = 120,
    parameter int BIRD_W     = 24,
    parameter int BIRD_H     = 24,
    parameter int PIPE_WIDTH = 60,
    parameter int GAP_HEIGHT = 120,
    parameter int GROUND_Y   = 430
) (
    input  logic [9:0] row,
    input  logic [9:0] col,
    input  logic       blank,
    input  logic       game_active,

    input  logic signed [10:0] bird_y,

    input  logic [9:0]  pipe0_x,
    input  logic [9:0]  gap0_y,

    output logic [2:0] r,
    output logic [2:0] g,
    output logic [2:0] b
);
    logic ground_on;
    logic pipe0_on;

    logic signed [10:0] brow, bcol;

    logic body_on, eye_on, pupil_on, beak_on;
    logic bird_on;

    function automatic logic pipe_pixel_on(
        input logic [10:0] col_in,
        input logic [9:0]  row_in,
        input logic [10:0] pipe_x,
        input logic [9:0]  gap_y
    );
        pipe_pixel_on =
            (col_in >= pipe_x) &&
            (col_in <  pipe_x + 11'(PIPE_WIDTH)) &&
            ((row_in < gap_y) || (row_in >= gap_y + GAP_HEIGHT));
    endfunction

    always_comb begin
        brow = $signed({1'b0, row}) - bird_y;
        bcol = $signed({1'b0, col}) - $signed(11'(BIRD_X));

        if (brow >= 0 && brow < BIRD_H && bcol >= 0 && bcol < BIRD_W) begin

            body_on = ( (bcol-11'sd12)*(bcol-11'sd12) +
                        (brow-11'sd12)*(brow-11'sd12) ) <= 11'sd100;

            eye_on  = ( (bcol-11'sd17)*(bcol-11'sd17) +
                        (brow-11'sd8) *(brow-11'sd8)  ) <= 11'sd9;

            pupil_on = ( (bcol-11'sd18)*(bcol-11'sd18) +
                         (brow-11'sd8) *(brow-11'sd8)  ) <= 11'sd1;

            beak_on = (bcol >= 11'sd20) && (bcol <= 11'sd23) &&
                      (brow >= 11'sd10) && (brow <= 11'sd13);

            bird_on = body_on || eye_on || beak_on;

        end else begin
            body_on  = 1'b0;
            eye_on   = 1'b0;
            pupil_on = 1'b0;
            beak_on  = 1'b0;
            bird_on  = 1'b0;
        end

        ground_on = (row >= GROUND_Y);

        pipe0_on = game_active && pipe_pixel_on(11'(col), row, {1'b0, pipe0_x}, gap0_y);

        if (blank) begin
            r = 3'b000; g = 3'b000; b = 3'b000;

        end else if (ground_on) begin
            r = 3'b101; g = 3'b100; b = 3'b000;

        end else if (beak_on) begin
            r = 3'b111; g = 3'b101; b = 3'b000;

        end else if (pupil_on) begin
            r = 3'b000; g = 3'b000; b = 3'b000;

        end else if (eye_on) begin
            r = 3'b111; g = 3'b111; b = 3'b111;

        end else if (body_on) begin
            r = 3'b111; g = 3'b110; b = 3'b000;

        end else if (pipe0_on) begin
            r = 3'b000; g = 3'b111; b = 3'b000;

        end else begin
            r = 3'b010; g = 3'b110; b = 3'b111;
        end
    end
endmodule