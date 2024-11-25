interface fifo_if(input logic clk);
  logic rst;
  logic wr_en;
  logic rd_en;
  logic full;
  logic empty;
  logic [7:0] wdata;
  logic [7:0] rdata;

  clocking DRIVER_cb @(posedge clk);
  default input #1 output #1;
    output wr_en;
    output wdata;
    input  full;
    output rd_en;
    input  rdata;
    input  empty;
  endclocking

  clocking MONITOR_cb @(posedge clk);
  default input #1 output #1;
    input wr_en;
    input wdata;
    input full;
    input rd_en;
    input rdata;
    input empty;
  endclocking
  
  
endinterface