`include "defines.sv"
class env extends uvm_env;
  `uvm_component_utils(env)
  agent inp_agt;
  passive_agent out_agt;
  scoreboard sb;
  fifo_config m_cfg;
  function new(string name="env", uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(fifo_config)::get(this,"","fifo_config",m_cfg)))
      `uvm_fatal(get_type_name(),"Couldn't get the interface")
    inp_agt=agent::type_id::create("inp_agt",this);
    out_agt=passive_agent::type_id::create("out_agt",this);
    sb=scoreboard::type_id::create("sb",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    inp_agt.mon.mon_port.connect(sb.ap_imp);
    out_agt.monp.pmon_port.connect(sb.pass_imp);
  endfunction
endclass
    
      
    
  
