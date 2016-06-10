// This file contains the Top level test class which instantiates environment and other agents.

`ifndef APB_TEST_SV
`define APB_TEST_SV

//--------------------
//APB TEST
//--------------------

class apb_test extends uvm_test;

`uvm_component_utils(apb_test)

apb_env env;
apb_config cfg;
virtual apb_if vif;
 
 function new(string name = "apb_test", uvm_compnent parent = null);
 super.new(name, parent);
 
 endfucntion
 
 virtual function void build_phase(uvm_phase phase)   //build_phase is used to construct environment and cofiguration object and pass the virtual interface handle to the environment.
 
 env = apb_env::type_id::create("env",this);
 cfg = apb_config::type_id::create("cfg",this)
 
 if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
 `uvm_fatal("APB/TEST/NOVIF","no virtual interface for Top level test specified")
 
 end
 
 uvm_config_db#(virtual apb_if)::set(this, "env,"vif",vif)
 
 endfunction: build_phase
 
 
 task run_phase(uvm_phase phase);  // run task is set to construct sequences and run the sequences on a sequencer.
 
 apb_base_seq apb_seq;
 
 apb_seq = apb_base_seq::type_id::create("apb_seq");

phase.raise_objection(this," starting apb_seq main phase");
$display("%t apb_seq run time starting at ",$time);
apb_seq.start(env.agnt.sqr);
#100ns
phase.drop_objection(this," droping main phase");

endtask: run_phase

endclass

`endif
