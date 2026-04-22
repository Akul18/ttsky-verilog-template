module renderer #(
    parameter int SCREEN_W    = 640,
    parameter int SCREEN_H    = 480,
    parameter int BIRD_X      = 120,
    parameter int BIRD_W      = 24,
    parameter int BIRD_H      = 24,
    parameter int PIPE_WIDTH  = 60,
    parameter int GAP_HEIGHT  = 120,
    parameter int GROUND_Y    = 430
) (
    input  logic [9:0] row,
    input  logic [9:0] col,
    input  logic       blank,

    input  logic signed [10:0] bird_y,
    input  logic [9:0] pipe0_x,
    input  logic [9:0] pipe1_x,
    input  logic [9:0] gap0_y,
    input  logic [9:0] gap1_y,

    output logic [2:0] r,
    output logic [2:0] g,
    output logic [2:0] b
);

    logic bird_on, ground_on;
    logic pipe0_on, pipe1_on;

    function automatic logic pipe_pixel_on(
        input logic [9:0] x,
        input logic [9:0] y,
        input logic [9:0] pipe_x,
        input logic [9:0] gap_y
    );
        begin
            pipe_pixel_on =
                (x >= pipe_x) && (x < pipe_x + PIPE_WIDTH) &&
                ((y < gap_y) || (y >= gap_y + GAP_HEIGHT));
        end
    endfunction

    always_comb begin
        bird_on = (col >= BIRD_X) && (col < BIRD_X + BIRD_W) &&
                  (row >= bird_y) && (row < bird_y + BIRD_H);

        ground_on = (row >= GROUND_Y);

        pipe0_on = pipe_pixel_on(col, row, pipe0_x, gap0_y);
        pipe1_on = pipe_pixel_on(col, row, pipe1_x, gap1_y);

        if (blank) begin
            r = 3'b000;
            g = 3'b000;
            b = 3'b000;
        end else if (ground_on) begin
            r = 3'b101;
            g = 3'b100;
            b = 3'b000;
        end else if (bird_on) begin
            r = 3'b111;
            g = 3'b111;
            b = 3'b000;
        end else if (pipe0_on || pipe1_on) begin
            r = 3'b000;
            g = 3'b111;
            b = 3'b000;
        end else begin
            r = 3'b010;
            g = 3'b110;
            b = 3'b111;
        end
    end

    wire _unused = &{SCREEN_W[0], SCREEN_H[0], 1'b0};

endmodule