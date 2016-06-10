//---This file contains the agent, environment and configuration classes of the Test bench

`ifndef APB_AGNT_ENV_CONFIG_SV
`define APB_AGNT_ENV_CONFIG_SV

//-------------------------------------
//APB Config class
//-------------------------------------

class apb_config extends uvm_object;
 
 `uvm_object_utils(apb_config)
 
  virtual apb_if vif;
  
  function new(string name = "apb_config");
      super.new(name);
      
  endfunction
  
endclass: apb_config

//------------------------
//APB Agent Class
//------------------------

class apb_agent extends uvm_agent;

  `uvm_component_utils_begin(apb_agent)
    `uvm_field_object(sqr, UVM_ALL_ON)     //Flag set to UVM_ALL_ON to include the variable in all date methods.
    `uvm_field_object(drv,UVM_ALL_ON)
    `uvm_field_object(mon,UVM_ALL_ON)
  `uvm_compnent_utils_end

    apb_sequencer sqr;
    apb_driver    drv;
    apb_monitor   mon;
    
  virtual apb_if  vif;
  
  function new(string name, uvm_component parent - null);
  
     super.new(name,parent);
     
  endfunction
  
  virtual function void build_phase(uvm_phase phase);

    
    sqr = apb_sequencer::type_id::create("sqr",this);
    drv = apb_driver::type_id::create("drv",this);
    mon = apb_monitor::type_id::create("mon",this);
    
  if(!(uvm_config_db)#(virtual apb_if)::get(this,"","vif",vif)) begin
  `uvm_fatal("APB/AGT/NOVIF", "No virtual interface for this agent")
  
  end
  
  uvm_config_db#(virtual apb_if)::set(this,"sqr","vif",vif)
  uvm_config_db#(virtual apb_if)::set(this,"drv","vif",vif)
  uvm_config_db#(virtual apb_if)::set(this,"mon","vif",vif)
  
  endfunction: build_phase
  
  
  virtual fucntion void connect_phase(uvm_phase phase);
  
  drv.seq_item_port.connect(sqr.seq_item_export);
  `uvm_report_info("apb_agent::", "connect phase,driver and sequencer connected")
  
  endfunction: connect_phase
  
  endclass: apb_agent
  
  //----------------------------------------------
  //APB Environment class
  //----------------------------------------------
  
  class apb_env extends uvm_env;
  
  virtual apb_if vif;
  
  apb_agent agnt;
  apb_config cfg;
  
  
  `uvm_component_utils(apb_env)
  
  function new(string name, uvm_component parent= null);
  
  super.new(name,parent);
  
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
  
  agnt = apb_agent::type_id::create("agnt",this) // constructing the agent which is sub component of environment.
  
  if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin      //environment getting its virtual interface handle from test.
  
    `uvm_fatal("APB/ENV/NOVIF","no virtual interface for this environment is specified")
  end
  
  uvm_config_db#(virtual apb_if)::set(this,"agnt","vif".vif)       //Passing the virtual interface handle to the agent.
  endfucntion: build_phase
  
  endclass: apb_env
  
  `endif
     
  
  
  
  
    
    
    
    
    


 


