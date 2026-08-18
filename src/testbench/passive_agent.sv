`include "defines.sv"
class passive_agent extends uvm_agent;
  `uvm_component_utils(passive_agent)
  function new(string name="agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  fifo_config m_cfg;
  passive_monitor monp;
  function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(fifo_config)::get(this,"","fifo_config",m_cfg))
      `uvm_fatal(get_type_name(),"Couldn't get the interface")
    monp=passive_monitor::type_id::create("monp",this);
  endfunction
endclass

  
