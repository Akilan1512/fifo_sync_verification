`include "defines.sv"
class agent extends uvm_agent;
  `uvm_component_utils(agent)
  function new(string name="agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  fifo_config m_cfg;
  driver drv;
  monitor mon;
  sequencer seqr;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(fifo_config)::get(this,"","fifo_config",m_cfg))
      `uvm_fatal(get_type_name(),"Couldn't get the interface")
    drv=driver::type_id::create("drv",this);
    mon=monitor::type_id::create("mon",this);
    seqr=sequencer::type_id::create("seqr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
    
    
