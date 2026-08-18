`include "defines.sv"
class passive_monitor extends uvm_monitor;
  `uvm_component_utils(passive_monitor)
  fifo_config m_cfg;
  uvm_analysis_port#(seq_item)pmon_port;
  virtual fifo_if.out_mon vif;
  function new(string name="passive_monitor", uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(virtual fifo_config)::get(this,"","fifo_config",m_cfg)))
      `uvm_fatal(get_type_name(),"No interface")
    pmon_port=new("pmon_port",this);
  endfunction
  task run_phase(uvm_phase phase);
    seq_item pkt;
    repeat(2)@(vif.out_mon_cb)
      forever begin
        @(vif.out_mon_cb)
        pkt=seq_item::type_id::create("pkt",this);
        pkt.data_out=vif.out_mon_cb.data_out;
        pkt.full=vif.out_mon_cb.full;
        pkt.empty=vif.out_mon_cb.empty;
        pmon_port.write(pkt);
      end
  endtask
endclass

        
      
