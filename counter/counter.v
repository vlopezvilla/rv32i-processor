// declaring a counter module
module counter(
  input clk,                // clock input
  input rst,                // reset input
  output reg [7:0] count    // 8-bit counter output
);

// timing logic for the counter 
// always = do this forever every clock cycle
// posedge = positive edge of the clock
always @(posedge clk) begin
  if (rst)  // if reset signal is high (logic 1)
    count <= 8'b0;  // set count to 0
  else
    count <= count + 1; // if reset is NOT high then increment the count
end

endmodule


/*
Summary: 
On every clock edge, when the clock ticks
- The counter checks if the reset signal is high. If it is, the counter resets to 0.
- If reset is high -> set the count to 0
- If reset is low -> add 1 to count

*/