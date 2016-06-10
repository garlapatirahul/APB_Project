//Top level test module used to instantiate the virtual interface and the DUT slave



import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_if.svh"
`include "apb_rw.sv"
`include "apb_drv_seq_mon.sv"
`include "apb_agent_env_config.sv"
`include "apb_sequences.svh"
`include "apb_test.sv"


module test

logic pclk;

initial begin
 pclk = 0;
 
 end
 
 always begin
 #10 pclk = ~pclk;
 
 end

apb_if apb_if(.pclk(pclk));

intital begin

uvm_config_db#(virtual apb_if)::set(null,"uvm_test_top","vif",apb_if); //pass the virtual interface handle down the test bench hierarchy using uvm_test_top.

run_test();   //pass the test using the command line using +UVM_TEST

end

endmodule

 
