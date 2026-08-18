`include "uvm_macros.svh"
`include "defines.sv"
`include "interface.sv"
`include "test_pkg.sv"
module top;
  import uvm_pkg::*;
 // import test_pkg::*;

  bit clk;
  bit rst;

  always #5 clk = ~clk;

  fifo_if inf(clk);

  syn_fifo dut(.clk(clk),.rst(rst),.wr_cs(inf.wr_cs),.rd_cs(inf.rd_cs),.data_in(inf.data_in),.rd_en(inf.rd_en),.wr_en(inf.wr_en),.data_out(inf.data_out),.empty(inf.empty),.full(inf.full));
  
  task apply_reset;
    rst=1'b1;
    repeat(2)
    rst=1'b0;
  endtask

  initial begin
    uvm_config_db #(virtual fifo_if)::set(null,"*","vif",inf);
  end

  initial begin
    apply_reset;
    #30;
    apply_reset;
  end

  initial begin
    run_test();
  end

endmodule
