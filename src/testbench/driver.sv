`include "defines.sv"
class driver extends uvm_driver#(seq_item);
  `uvm_component_utils(driver)
  fifo_config m_cfg;
  virtual fifo_if vif;
  function new(string name="driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(virtual fifo_if)::get(this,"","fifo_config",m_cfg)))
      `uvm_fatal(get_type_name(),"Couldn't get the interface")
    else
      `uvm_info(get_type_name(),"Got it",UVM_NONE)
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  task run_phase(uvm_phase phase);
    begin
      @(vif.drv_cb);
       vif.drv_cb.rst=1;
      @(vif.drv_cb);
       vif.drv_cb.rst=0;
      forever begin
        seq_item_port.get_next_item(req);
        drive(req);
        seq_item_port.item_done(req);
      end
    end
  endtask
  task drive(seq_item drv2dut);
    begin
      `uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",drv2dut.sprint()),UVM_NONE)
      @(vif.drv_cb);
       vif.drv_cb.wr_cs<=drv2dut.wr_cs;
       vif.drv_cb.rd_cs<=drv2dut.rd_cs;
       vif.drv_cb.wr_en<=drv2dut.wr_en;
       vif.drv_cb.rd_en<=drv2dut.rd_en;
       vif.drv_cb.data_in<=drv2dut.data_in;
    end
  endtask
endclass

    
