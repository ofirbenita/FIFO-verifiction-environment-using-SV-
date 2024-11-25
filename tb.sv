`include "interface.sv"
`include "test.sv"

module tb_top();
  bit clk;

  fifo_if inf(clk);
  test t1(inf);
  fifo DUT(.wdata(inf.wdata),
          .full(inf.full),
          .empty(inf.empty),
           .rdata(inf.rdawa),
          .wr_en(inf.wr_en),
          .rd_en(inf.rd_en),
          .clk(inf.clk),
          .rst(inf.rst));

  initial begin
    clk = 1'b1;
  end

  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule