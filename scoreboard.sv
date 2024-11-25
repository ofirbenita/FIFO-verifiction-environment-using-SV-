class scoreboard;
  mailbox gen2sb;        
  mailbox rcv2sb;      
  queue logic [7:0] wdata_q; 


  function new(mailbox gen2sb, mailbox rcv2sb);
    this.gen2sb = gen2sb;
    this.rcv2sb = rcv2sb;
    wdata_q = {}; 
  endfunction

  task start();
    transactor trans_rcv, trans_gen;
    trans_rcv = new();
    trans_gen = new();

    fork
      forever begin
        gen2sb.get(trans_gen);

        if (trans_gen.wr_en) begin
          wdata_q.push_back(trans_gen.wdata); 
          $display("Write to DUT: wdata=%0h added to queue", trans_gen.wdata);
        end

        rcv2sb.get(trans_rcv);

        if (trans_rcv.rd_en) begin
          if (!wdata_q.empty()) begin
            logic [7:0] expected_data = wdata_q.pop_front();
            if (expected_data == trans_rcv.rdata) begin
              $display("Read successful: rdata=%0h matches wdata=%0h", trans_rcv.rdata, expected_data);
            end else begin
              $display("Error: rdata=%0h does not match expected wdata=%0h", trans_rcv.rdata, expected_data);
            end
          end else begin
            $display("Error: Read attempted but queue is empty!");
          end
        end
      end
    join_none
  endtask
endclass