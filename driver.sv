class driver;
  virtual fifo_if vif;
  mailbox gen2driv;

  function new(virtual fifo_if vif, mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction

  task reset();
    vif.DRIVER_cb.rst <= 1;
    repeat(40) @(posedge vif.DRIVER_cb.clk);
    vif.DRIVER_cb.rst <= 0;
  endtask

  task main();
    fork
      forever begin
        transactor trans;
        gen2driv.get(trans);
        @(posedge vif.DRIVER_cb.clk);
        if (trans.wr_en) begin
          vif.driver.DRIVER_cb.wr_en <= trans.wr_en;
          vif.driver.DRIVER_cb.wdata <= trans.wdata;
        end else begin
          vif.DRIVER_cb.rd_en <= trans.rd_en;
          trans.rdata <= vif.DRIVER_cb.rdata;
        end
      end
    join_none
  endtask
endclass