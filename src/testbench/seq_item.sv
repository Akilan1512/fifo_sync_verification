`include "defines.sv"
class seq_item extends uvm_sequence_item;
  `uvm_object_utils(seq_item)
  function new(string name="seq_item");
    super.new(name);
  endfunction
  rand bit wr_cs,rd_cs,wr_en,rd_en;
  rand bit[`DATA_WIDTH-1:0]data_in;
  logic [`DATA_WIDTH-1:0]data_out;
  logic full,empty;
endclass

