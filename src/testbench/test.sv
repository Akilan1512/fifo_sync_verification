`include "defines.sv"
class test extends uvm_test;
  `uvm_component_utils(test)
  env env1;
  fifo_config m_cfg;
  
  function new(string name="test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_cfg=fifo_config::type_id::create("m_cfg");
    if(!(uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",m_cfg)))
      `uvm_fatal(get_type_name(),"Couldn't get the interface");
    m_cfg.input_agent_is_active=UVM_ACTIVE;
    m_cfg.output_agent_is_active=UVM_PASSIVE;
    uvm_config_db#(fifo_config)::set(this,"*","fifo_config",m_cfg);
    env1=env::type_id::create("env1",this);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

  
class test1 extends test;
 `uvm_component_utils(test)
 seq s1;
 reset_seq s2;
 write_seq s3;
 read_seq s4;

function new(string name="test1",uvm_component parent);
	super.new(name,parent);
 endfunction


 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
 endfunction    
    
task run_phase(uvm_phase phase);

	phase.raise_objection(this);
	s1=seq::type_id::create("s1");
        s2=reset_seq::type_id::create("s2");
        s3=write_seq::type_id::create("s3");
        s4=read_seq::type_id::create("s4");

        fork
         s1.start(env1.inp_agt.seqr);
         s2.start(env1.inp_agt.seqr);
         s3.start(env1.inp_agt.seqr);
         s4.start(env1.inp_agt.seqr);
        join
        #50;
        phase.drop_objection(this);
    endtask
endclass

