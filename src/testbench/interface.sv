`include "defines.sv"
interface fifo_if(input bit clk);
  logic wr_cs;
  logic rd_cs;
  logic wr_en;
  logic rd_en;
  logic [`DATA_WIDTH-1:0]data_in;
  logic [`DATA_WIDTH-1:0]data_out;
  logic full;
  logic empty;
  logic rst;
  
  clocking drv_cb@(posedge clk);
    default input#1 output#1;
    output wr_cs;
    output rd_cs;
    output wr_en;
    output rd_en;
    output data_in;
    output rst;
  endclocking
  
  clocking inp_mon_cb@(posedge clk);
    default input#1 output#1;
    input wr_cs;
    input rd_cs;
    input wr_en;
    input rd_en;
    input data_in;
    input rst;
  endclocking
  
  clocking out_mon_cb@(posedge clk);
    default input#1 output#1;
    input wr_cs;
    input rd_cs;
    input wr_en;
    input rd_en;
    input data_in;
    input data_out;
    input full;
    input empty;
    input rst;
  endclocking
  
  modport drv(input clk,clocking drv_cb);
    modport inp_mon(input clk,clocking inp_mon_cb);
      modport out_mon(input clk,clocking out_mon_cb);
        
        endinterface
        
    
    
