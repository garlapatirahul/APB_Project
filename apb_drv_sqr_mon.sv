//This file contains the Driver ,Sequencer and Monitor components of the test bench for APB protocol.

`ifndef APB_DRV_SQR_MON_SV
`define APB_DRV_SQR_MON_SV

//----------------------------------
//APB_DRIVER
//---------------------------------


class apb_driver extends uvm_driver;

`uvm_component_utils(apb_driver)

virtual apb_if vif;
apb_config cfg;

function new(string name = "apb_driver", uvm_component parent = null)
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase)
apb_agent agnt;
super.build_phase(phase);

if($cast(agnt,get_parent())&& agent != null) begin
vif = agnt.vif;
end
else begin

if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin

`uvm_fatal("APB/TEST/ENV/AGNT/DRV/NOVIF:", "no virtual interface for the driver specified")
end
end

endfunction: build_phase


virtual task run_phase(uvm_phase phase);

super.run_phase(phase);

this.vif.master_cb.psel <= '0;
this.vif.master_cb.penable = '0;

forever begin

apb_rw tr;

@(this.vif.master_cb);

seq_item_port.get_next_item(tr);

@(this.vif.master_cb)

`uvm_report_info("APB_DRIVER", $psprintf("Got transaction %s", tr.convert2string()));

case(tr.apb_cmd)

apb_rw::READ:   drive_read(tr.addr,tr.data);
apb_rw::WRITE:  drive_write(tr.addr,tr.data);

endcase

seq_item_port.item_done();

end
endtask: run_phase

virtual protected task drive_read( input bit [31:0]addr,
output logic [31:0]data);

this.vif.master_cb.psel <= '1;
this.vif.master_cb.paddr <= addr;
this.vif.master_cb.pwrite <= '0;

@(this.vif.master_cb);
this.vif.master_cb.penable <= '1;
@(this.vif.master_cb);
data = this.vif.master_cb.prdata;
this.vif.master_cb.psel <= '0;
this.vif.master_cb.penable <= '0;

endtask: drive_read

virtual protected task drive_write( input bit [31:0]addr, input logic [31:0]data);

this.vif.master_cb.psel <= '1;
this.vif.master_cb.paddr <= addr;
this.vif.master_cb.pdata <= data;
this.vif.master_cb.pwrite <= '1;

@(this.vif.master_cb)
this.vif.master_cb.penable <= '1;
@(this.vif.master_cb)
this.vif.master_cb.psel <= '0;
this.vif.master_cb.penable <= '0;

endtask: drive_write

endclass: apb_driver


//-------------------------------
//APB_SEQUENCER
//-------------------------------

class apb_sequencer extends uvm_sequencer#(apb_rw);

function new(input string name, uvm_component parent=null);
 super.new(name, parent);
 
endfucntion: new

endclass: apb_sequencer

//---------------------------------
//APB_MONITOR
//--------------------------------

class apb_monitor extends uvm_monitor#(apb_rw);

virtual apb_if 











