class transactor;
  rand bit rd_en;
  rand bit wr_en;
  bit [7:0] wdata;
  bit [7:0] rdata;
  bit full;
  bit empty;

  constraint data_size {wdata < 256 };
endclass