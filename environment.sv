`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"



class environment;
  generator gen;
  driver driv;
  monitor rcv;
  scoreboard sb;
  mailbox gen2driv;
  mailbox rcv2sb;
  virtual fifo_if vif;

  function new(virtual fifo_if vif);
    this.vif = vif;
  endfunction

  task build();
    gen2driv = new();
    rcv2sb = new();
    gen = new(gen2driv);
    driv = new(vif, gen2driv);
    rcv = new(vif, rcv2sb);
    sb = new(gen2driv, rcv2sb);
  endtask

  task pre_test();
    driv.reset();
  endtask
  
   task test();
    fork
      gen.main();
      rcv.start();
      sb.start();
    join
  endtask

  task run();
    pre_test();
    test();
    $finish();
  endtask
endclass