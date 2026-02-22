module RangeFinder
   #(parameter WIDTH=8)
    (input  logic [WIDTH-1:0] data_in,
     input  logic             clock, reset,
     input  logic             go, finish,
     output logic [WIDTH-1:0] range,
     output logic             error);


// Put your code here

enum logic [1:0] {WAIT, ERROR, CHECK, DONE} cs, ns;
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end

logic [WIDTH-1:0] min, max, nextMin, nextMax;

logic almostDone, almostDoneReg;

// Next State and Output Generation
always_comb begin
   case (cs)
      WAIT: begin
         if (finish) begin
            nextMin <= -1;
            nextMax <= 0;
            ns = ERROR;
            error = 1'b1;
         end
         else if (go) begin
            nextMin = (data_in < min) ? data_in : min;
            nextMax = (data_in > max) ? data_in : max;
            ns = CHECK;
            error = 1'b0;
         end
         else begin
            nextMin <= -1;
            nextMax <= 0;
            ns = WAIT;
            error = 1'b0;
         end
      end
      ERROR: begin
         error = 1'b1;
         if (finish) begin
            nextMin <= -1;
            nextMax <= 0;
            ns = ERROR;
         end
         else if (go) begin
            nextMin = (data_in < min) ? data_in : min;
            nextMax = (data_in > max) ? data_in : max;
            ns = CHECK;
         end
         else begin
            nextMin <= -1;
            nextMax <= 0;
            ns = ERROR;
         end
      end
      CHECK: begin
         if (finish) begin
            almostDone <= 1'b1;
            nextMin = (data_in < min) ? data_in : min;
            nextMax = (data_in > max) ? data_in : max;
            ns = DONE;
            error = 1'b0;
         end
         else begin
            nextMin = (data_in < min) ? data_in : min;
            nextMax = (data_in > max) ? data_in : max;
            ns = CHECK;
            error = 1'b0;
         end
      end
      DONE: begin
         if (finish) begin
            nextMin <= min;
            nextMax <= max;
            ns = ERROR;
            error = 1'b1;
         end
         else if (go) begin
            nextMin <= min;
            nextMax <= max;
            ns = CHECK;
            error = 1'b0;
         end
         else begin
            nextMin <= min;
            nextMax <= max;
            ns = WAIT;
            error = 1'b0;
         end
      end
   endcase
end

assign range = nextMax - nextMin;

// Sequential components
always_ff @(posedge clock, posedge reset) begin
   if (reset) begin
      min <= -1;
      max <= 0;
      cs <= WAIT;
   end
   else begin
      min <= nextMin;
      max <= nextMax;
      cs <= ns;
   end
end

endmodule: RangeFinder