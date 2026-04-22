`default_nettype none


module lfsr16 (
    input  logic       clk,
    input  logic       reset,
    input  logic       en,
    output logic [15:0] rnd
);
    logic feedback;

    assign feedback = rnd[15] ^ rnd[13] ^ rnd[12] ^ rnd[10];

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            rnd <= 16'hACE1;   // nonzero seed
        else if (en)
            rnd <= {rnd[14:0], feedback};
    end
endmodule
