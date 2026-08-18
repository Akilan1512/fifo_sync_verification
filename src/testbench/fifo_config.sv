class fifo_config extends uvm_object;
  `uvm_object_utils(fifo_config)
  //virtual
  virtual fifo_if vif;

  uvm_active_passive_enum input_agent_is_active;
  uvm_active_passive_enum output_agent_is_active;

  
  function new(string name="fifo_config");
	super.new(name);
  endfunction

endclass

