module fifo_if(
  input logic rst,
  input logic clk,
  input logic wr_en,
  input logic rd_en,
  output logic full,
  output logic empty,
  input logic [7:0] wdata,
  output logic [7:0] rdata
);
  
  logic [5:0] w_ptr,r_ptr ; 
  integer i ; 
  logic [7:0] mem [31:0] ;
  
  always@(posedge clk,posedge rst)
    begin
      if(rst)
        begin
          for(i=0;i<=32;i=i+1)
            begin
              mem[i]<=8'b00000000;
              w_ptr<=0;
              r_ptr<=0;
            end
        end
      else 
        begin
          if(wr_en && ~full)
            begin
              mem[w_ptr]<=wdata;
              w_ptr<= w_ptr+1;
            end
        end
    end
  
   always@(posedge clk)
    begin
      if(rd_en&&~empty)
        begin
          rdata<=mem[r_ptr];
          r_ptr<= r_ptr+1;
        end
    end
  
  assign full = ( (w_ptr[5]!=r_ptr[5]) && (w_ptr[4:0]==r_ptr[4:0] ) );
  assign empty = (w_ptr == r_ptr);  
endmodule