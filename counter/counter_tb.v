module counter_tb;
  reg clk, rst;
  wire [7:0] count;

  counter uut(.clk(clk), .rst(rst), .count(count));

  // free-running clock: 10 time-unit period
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    #12 rst = 0;   // held across the posedge at t=5, so reset actually latches

    repeat(20) begin
      @(posedge clk);
      $display("Time: %t, Count: %d", $time, count);
    end

    $finish;
  end
endmodule