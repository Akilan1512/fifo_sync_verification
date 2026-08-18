`include "defines.sv"
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name="monitor", uvm_component parent);
    super.new(name,parent);
  endfunction
  uvm_analysis_port#(seq_item)mon_port;
  virtual fifo_if.inp_mon vif;
  fifo_config m_cfg;
  seq_item drv2mon;
  
   function void build_phase(uvm_phase phase);
	super.build_phase(phase);
     if(!uvm_config_db#(fifo_config)::get(this,"","fifo_config",m_cfg))
	  `uvm_fatal(get_type_name(),"Input_Monitor Getting Failed")
     mon_port=new("mon_port",this);
 endfunction

 function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
 	vif=m_cfg.vif;
 endfunction

 task run_phase(uvm_phase phase);
   forever begin
	drv2mon=seq_item::type_id::create("drv2mon");
	    collect_input_monitor();
		`uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR\n%s",drv2mon.sprint()),UVM_NONE)
	end		    
 endtask

 virtual task collect_input_monitor();
	begin
		repeat(7)
        	@(vif.inp_mon_cb);

	    drv2mon.wr_cs        =   vif.inp_mon_cb.wr_cs; 
	    drv2mon.rd_cs =   vif.inp_mon_cb.rd_cs;
      drv2mon.wr_en        =   vif.inp_mon_cb.wr_en;
	    drv2mon.rd_en        =   vif.inp_mon_cb.rd_en;
            drv2mon.data_in      =   vif.inp_mon_cb.data_in;
	   // drv2mon.rst       =   vif.inp_mon_cb.rst;
       	   
		mon_port.write(drv2mon);
	    end
 endtask

endclass

  
