
//A few flavours of apb sequences

`ifndef APB_SEQUENCES_SV
`define APB_SEQUENCES_SV

//------------------------
//Base APB sequence derived from uvm_sequence and parameterized with sequence item of type apb_rw
//------------------------
class apb_base_seq extends uvm_sequence#(apb_rw);

  `uvm_object_utils(apb_base_seq)

  function new(string name ="");
    super.new(name);
  endfunction

apb_rw apb_rw_item;
  //Main Body method that gets executed once sequence is started
  task body();
    repeat(10) begin
    apb_rw_item = apb_rw::type_id::create("apb_rw_item");
    start_item(apb_rw_item);
    if(!item.randomize() with {address inside [0:32'h4FFF_FFFF]};}) begin
      `uvm_error("body", "randomizaton failure for item")
    end
    end
    finish_item(apb_rw_item);
    
    
  endtask: body
  
endclass
