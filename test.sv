`include "environment.sv"
program test(fifo_if inf);
  environment env;

  initial begin
    env = new(inf);
    env.build();
    env.gen.repeat_count = 40;
    env.run();
  end
endprogram