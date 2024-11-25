class monitor;
  virtual fifo_if vif;
  mailbox rcv2sb;

  
  covergroup fifo_coverage @(posedge vif.monitor.MONITOR_cb.clk);
    coverpoint vif.monitor.MONITOR_cb.wr_en;         
    coverpoint vif.monitor.MONITOR_cb.rd_en;         
    coverpoint vif.monitor.MONITOR_cb.full;          
    coverpoint vif.monitor.MONITOR_cb.empty;        
    cross vif.monitor.MONITOR_cb.wr_en, vif.monitor.MONITOR_cb.full; 
    cross vif.monitor.MONITOR_cb.rd_en, vif.monitor.MONITOR_cb.empty; 
    cross vif.monitor.MONITOR_cb.wr_en, vif.monitor.MONITOR_cb.rd_en; 
  endgroup

  function new(virtual fifo_if vif, mailbox rcv2sb);
    this.vif = vif;
    this.rcv2sb = rcv2sb;
    fifo_coverage = new(); 
  endfunction

  task start();
    fork
      forever begin
        transactor trans;
        trans = new();
        @(posedge vif.monitor.MONITOR_cb.clk);

       
        fifo_coverage.sample();

       
        if (vif.monitor.MONITOR_cb.wr_en) begin
          trans.wr_en = vif.monitor.MONITOR_cb.wr_en;
          trans.wdata = vif.monitor.MONITOR_cb.wdata;
          trans.full = vif.monitor.MONITOR_cb.full;
          trans.empty = vif.monitor.MONITOR_cb.empty;
          rcv2sb.put(trans);
        end

     
        if (vif.monitor.MONITOR_cb.rd_en) begin
          trans.rd_en = vif.monitor.MONITOR_cb.rd_en;
          trans.rdata = vif.monitor.MONITOR_cb.rdata;
          trans.full = vif.monitor.MONITOR_cb.full;
          trans.empty = vif.monitor.MONITOR_cb.empty;
          rcv2sb.put(trans);
        end
      end
    join_none
  endtask

 
  property write_when_full;
    @(posedge vif.monitor.MONITOR_cb.clk) vif.monitor.MONITOR_cb.wr_en && vif.monitor.MONITOR_cb.full |-> 
      $error("Illegal write when FIFO is full!");
  endproperty
  assert property(write_when_full);

  
  property read_when_empty;
    @(posedge vif.monitor.MONITOR_cb.clk) vif.monitor.MONITOR_cb.rd_en && vif.monitor.MONITOR_cb.empty |-> 
      $error("Illegal read when FIFO is empty!");
  endproperty
  assert property(read_when_empty);

 
  property write_and_read_stable;
    @(posedge vif.monitor.MONITOR_cb.clk) vif.monitor.MONITOR_cb.wr_en && vif.monitor.MONITOR_cb.rd_en |-> 
      (vif.monitor.MONITOR_cb.full == vif.monitor.MONITOR_cb.empty);
  endproperty
  assert property(write_and_read_stable);
endclass