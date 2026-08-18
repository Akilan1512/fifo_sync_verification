`include "defines.sv"
class seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(seq);
  seq_item seq1;
    function new(string name="seq");
      super.new(name);
    endfunction
    task body();
        repeat(100) begin
          seq1=seq_item::type_id::create("seq1");
          start_item(seq1);
          assert(seq1.randomize());
          finish_item(seq1);
        end
        endtask
endclass
     
class reset_seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(reset_seq)
  seq_item seq2;
  function new(string name = "reset_seq");
    super.new(name);
  endfunction
  task body();
    seq2 = seq_item::type_id::create("seq2");
    start_item(seq2);
    assert(seq2.randomize() with
    {wr_cs   == 0;
    wr_en   == 0;
    rd_cs   == 0;
    rd_en   == 0;
    data_in == 0 };)
    finish_item(seq2);
  endtask
endclass    

class write_seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(write_seq)
  seq_item seq3;
  function new(string name = "write_seq");
    super.new(name);
  endfunction
  task body();
    seq3 = seq_item::type_id::create("seq3");
    start_item(seq3);
    assert(seq2.randomize() with
    {wr_cs   == 1;
    wr_en   == 1;
    rd_cs   == 0;
    rd_en   == 0;
    data_in == 25 };)
    finish_item(seq3);
  endtask
endclass

class read_seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(read_seq)
  seq_item seq4;
  function new(string name = "read_seq");
    super.new(name);
  endfunction
  task body();
    seq4 = seq_item::type_id::create("seq4");
    start_item(seq4);
    assert(seq2.randomize() with
    {wr_cs   == 0;
    wr_en   == 0;
    rd_cs   == 1;
    rd_en   == 1;
    data_in == 0 };)
    finish_item(seq4);
  endtask
endclass

