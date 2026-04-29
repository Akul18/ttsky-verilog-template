module flappy_top (
    input  logic       CLOCK_50,
    input  logic       reset,
    input  logic       btn_start,
    input  logic       btn_jump,

    output logic       HS,
    output logic       VS,
    output logic       blank,
    output logic [2:0] r,
    output logic [2:0] g,
    output logic [2:0] b
);

    localparam int PIPE_SPACING = 360;
    localparam int INIT0        = 640;
    localparam int INIT1        = INIT0 + PIPE_SPACING;

    logic [9:0]  row, col;
    logic        tick;

    logic        start_pulse, jump_pulse;

    logic [15:0] rnd0, rnd1;

    logic signed [10:0] bird_y, bird_vy;

    logic [10:0] pipe0_x, pipe1_x;
    logic [9:0]  gap0_y,  gap1_y;
    logic        wrap0, wrap1;

    logic        hit0, hit1;
    logic        collision;

    logic        game_active, clear_game;
    logic [1:0]  state;

    vga vga_inst (
        .row(row), .col(col), .HS(HS), .VS(VS), .blank(blank),
        .CLOCK_50(CLOCK_50), .reset(reset)
    );

    button_sync_onepulse start_btn (
        .clk(CLOCK_50), .reset(reset), .btn_in(btn_start), .btn_pulse(start_pulse)
    );

    button_sync_onepulse jump_btn (
        .clk(CLOCK_50), .reset(reset), .btn_in(btn_jump), .btn_pulse(jump_pulse)
    );

    game_tick #(.DIV(833333)) tick_gen (
        .clk(CLOCK_50), .reset(reset), .tick(tick)
    );

    lfsr16 #(.SEED(16'hACE1)) rand0 (
        .clk(CLOCK_50), .reset(reset), .en(tick), .rnd(rnd0)
    );
    lfsr16 #(.SEED(16'h1234)) rand1 (
        .clk(CLOCK_50), .reset(reset), .en(tick), .rnd(rnd1)
    );

    game_fsm fsm (
        .clk(CLOCK_50), .reset(reset), .tick(tick),
        .start_pulse(start_pulse),
        .collision(collision),
        .game_active(game_active),
        .clear_game(clear_game),
        .state(state)
    );

    bird_physics bird (
        .clk(CLOCK_50), .reset(reset), .tick(tick),
        .game_active(game_active),
        .flap_pulse(jump_pulse && game_active),
        .bird_y(bird_y), .bird_vy(bird_vy)
    );

    pipe_unit pipe0 (
        .clk(CLOCK_50), .reset(reset), .tick(tick), .game_active(game_active),
        .rnd(rnd0),
        .init_x(11'(INIT0)),
        .spawn_x(pipe1_x + 11'(PIPE_SPACING)),
        .pipe_x(pipe0_x), .gap_y(gap0_y), .wrapped(wrap0)
    );

    pipe_unit pipe1 (
        .clk(CLOCK_50), .reset(reset), .tick(tick), .game_active(game_active),
        .rnd(rnd1),
        .init_x(11'(INIT1)),
        .spawn_x(pipe0_x + 11'(PIPE_SPACING)),
        .pipe_x(pipe1_x), .gap_y(gap1_y), .wrapped(wrap1)
    );

    collision_unit col0 (
        .bird_y(bird_y), .pipe_x(pipe0_x), .gap_y(gap0_y),
        .hit_pipe(), .hit_floor(), .hit_ceiling(), .collision(hit0)
    );
    collision_unit col1 (
        .bird_y(bird_y), .pipe_x(pipe1_x), .gap_y(gap1_y),
        .hit_pipe(), .hit_floor(), .hit_ceiling(), .collision(hit1)
    );

    assign collision = hit0 | hit1;

    renderer draw (
        .row(row), .col(col), .blank(blank),
        .game_active(game_active),
        .bird_y(bird_y),
        .bird_vy(bird_vy),
        .pipe0_x(pipe0_x[9:0]), .pipe1_x(pipe1_x[9:0]),
        .gap0_y(gap0_y),        .gap1_y(gap1_y),
        .r(r), .g(g), .b(b)
    );

endmodule