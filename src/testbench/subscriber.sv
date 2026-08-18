`include "defines.sv"
class subscriber extends uvm_subscriber#(seq_item);
  `uvm_component_utils(subscriber)
  seq_item pkt;
  covergroup cg;
    coverpoint pkt.wr_cs;
    coverpoint pkt.rd_cs;
    coverpoint pkt.wr_en;
    coverpoint pkt.rd_en;
  endgroup
  
  function new(string name="subscriber",uvm_component parent);
    super.new(name,parent);
    cg=new();
  endfunction
  
  function void write(fifo_trans t);
    pkt=t;
    cg.sample();
  endfunction
endclass

