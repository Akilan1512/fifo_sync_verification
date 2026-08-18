`include "defines.sv"
`uvm_analysis_imp_decl(_active)
`uvm_analysis_imp_decl(_passive)
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction
  virtual fifo_if intrf;
  fifo_config m_cfg;
  uvm_analysis_imp_active#(seq_item,scoreboard)ap_imp;
  uvm_analysis_imp_passive#(seq_item,scoreboard)pass_imp;
  seq_item active[$];
  seq_item passive[$];
  bit[`DATA_WIDTH-1:0]exp_dout[$];
  bit exp_empty;
  bit exp_full;
  bit[`ADDR_WIDTH:0]count;
  bit[`DATA_WIDTH-1:0]exp_data;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_config)::get(this, "", "fifo_config",m_cfg))
      `uvm_fatal(get_type_name(), "Interface Not Received")

    ap_imp   = new("ap_imp", this);
    pass_imp = new("pass_imp", this);
  endfunction
  
  function void write_active(seq_item pkt);
    seq_item cloned;
    if(!$cast(cloned,pkt.clone()))
      `uvm_fatal(get_type_name(),"Not cloned active tx")
    active.push_back(cloned);
    `uvm_info(get_type_name(),$sformatf("Active Monitor Packet Received | QUEUE_SIZE=%0d",active.size()),UVM_HIGH)
  endfunction
  
  function void write_passive(seq_item pkt1);
    seq_item cloned;
    if(!$cast(cloned,pkt1.clone()))
      `uvm_fatal(get_type_name(),"Not cloned passive tx")
    passive.push_back(cloned);
    `uvm_info(get_type_name(),$sformatf("Passive Monitor Packet Received | QUEUE_SIZE=%0d",passive.size()),UVM_HIGH)
  endfunction 
  
  task run_phase(uvm_phase phase);
    seq_item pkt,pkt1;
    forever begin
      wait(active.size()>0 && passive.size()>0);
      pkt=active.pop_front();
      pkt1=passive.pop_front();
      compare(pkt,pkt1);
    end
  endtask
  
  function void compare(seq_item pkt,seq_item pkt1);
    `uvm_info(
    get_type_name(),
    $sformatf(
        "\n==================== FIFO TRANSACTION ====================\nWR_CS=%0b WR_EN=%0b RD_CS=%0b RD_EN=%0b\nDATA_IN=0x%0h DATA_OUT=0x%0h\nFULL=%0b EMPTY=%0b\nSTATUS_COUNT=%0d QUEUE_SIZE=%0d\n============================================================",
        pkt.wr_cs,
        pkt.wr_en,
        pkt.rd_cs,
        pkt.rd_en,
        pkt.data_in,
        pkt.data_out,
        pkt1.full,
        pkt1.empty,
        count,
        exp_dout.size()
    ),
    UVM_HIGH
);
    exp_empty=(count==0);
    
    if(intrf.RST==0) begin
      
      if((pkt.wr_cs && pkt.wr_en && !exp_full) && (pkt.rd_cs && pkt.rd_en && !exp_empty)) begin
        exp_dout.push_back(pkt.data_in);
        exp_data=exp_dout.pop_front();
        
        if(exp_data==pkt1.data_out)
          `uvm_info(get_type_name(),$sformatf("Simultaneous wr/rd pass, exp=0x%0h act=0x%0h count=%0d queue_size=%0d",exp_data, pkt1.data_out, count, exp_dout.size()),UVM_LOW)
          
          else
            `uvm_error(get_type_name(),$sformatf("Simultaneous wr/rd fail, exp=0x%0h act=0x%0h count=%0d queue_size=%0d",exp_data, pkt1.data_out, count, exp_dout.size()));
      end
      else if(pkt.wr_cs && pkt.wr_en && !exp_full) begin
        exp_dout.push_back(pkt.data_in);
        `uvm_info(get_type_name(),$sformatf("Write pass, data_in=0x%0h count=%0d->%0d, queue_size=%0d", pkt.data_in,count,count+1,exp_dout.size()),UVM_LOW);
        count=count+1;
      end
      else if(pkt.rd_cs && pkt.rd_en && !exp_empty) begin
        if(exp_dout.size()==0) begin
          `uvm_error(get_type_name(),"Can't pop from empty ref queue");
        end
        else begin
          exp_data=exp_dout.pop_front();
          if(exp_data==pkt1.data_out)
            `uvm_info(get_type_name(),$sformatf("Read pass,exp=0x%0h,act=0x%0h,count=%0d->%0d,queue_size=%0d",exp_data,pkt1.data_out,count,count+1,exp_dout.size()),UVM_LOW)
            else
              `uvm_error(get_type_name(),$sformatf("Read fail,exp=0x%0h,act=0x%0h,count=%0d->%0d,queue_size=%0d",exp_data,pkt1.data_out,count,count+1,exp_dout.size()))
              end
              count=count+1;
        end
        else begin
          `uvm_info(get_type_name(),$sformatf("No operation on FIFO, count=%0d, queue_size=%0d",count,exp_dout.size()),UVM_LOW);
        end
        exp_full=(count==`DEPTH);
        exp_empty=(count==0);
        
        if(exp_full==pkt1.full)
          `uvm_info(get_type_name(),$sformatf("Flag full-pass, expected=%0b, actual=%0b, count=%0d",exp_full,pkt1.full,count),UVM_LOW)
          else
            `uvm_error(get_type_name(),$sformatf("Flag full fail, expected=%0b, actual=%0b, count=%0d", exp_full,pkt1.full,count));
        
        if(exp_empty==pkt1.empty)
          `uvm_info(get_type_name(),$sformatf("Flag empty pass, expected=%0b, actual=%0b, count=%0d", exp_empty,pkt1.empty,count),UVM_LOW)
          else
            `uvm_error(get_type_name(),$sformatf("Flag empty fail, expected=%0b, actual=%0b, count=%0d", exp_empty,pkt1.empty,count));
        
        `uvm_info(get_type_name(),$sformatf("Scoreboard status, count=%0d, full=%0b, empty=%0b, queue_size=%0d", count,exp_full,exp_empty,exp_dout.size()),UVM_HIGH);
      end
      else begin
        exp_dout.delete();
        count=0;
      end
      endfunction
      endclass
      
        
        

