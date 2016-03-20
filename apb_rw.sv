// Code your design here
// basic read write transaction class definition
// this is the sequence item which passes through the sequencer and monitor
 //--------------------------------------
`ifdef APB_RW_SV      //conditional compiler directives
`DEFINE APB_RW_SV     


class apb_rw extends uvm_sequence_item;
  
    //typedef for READ/write transaction type
  typedef enum {READ, WRITE} kind_inst;
  rand bit [31:0] addr;
  rand logic [31:0] data;
  rand kind_inst apb_cmd;
  
     //register with factory for dynamic creation
  `uvm_object_utils(apb_rw)
  
  
  function new (string name = "apb_rw")
    super.new(name)
  endfunction
  
  function void do_copy(uvm_object rhs);
    bus_item rhs_;
    
    if(!$cast(rhs_,rhs) begin
      uvm_report_error("do_copy cast failed");
      return;
    end
       
     addr = rhs_.addr;
     data = rhs_.data;
     apb_cmd = rhs_apb_cmd;
       endfunction:do_copy
       
       function bit do_compare(uvm_object rhs , uvm_comparer comparer);
         bus_item rhs_;
         
         if(!$cast(rhs_,rhs)) begin
           return 0;
         end
         
         return((super.do_compare(rhs,comparer) && (addr == rhs_.addr) && (data == rhs_.data) && (apb_cmd == rhs_.apb_cmd));
                
       endfunction:do_compare
                
                function string convert2string();   //actually prints the sequence item as a string
                  string s;
                  
                  $sformat(s, "%s\n apb_cmd \t%0d\n data \t%0d\n addr \t%0h\n ", s,  apb_cmd, data , addr);
                  
                  foreach (data[i]) begin
                    $sformat(s , "%s data[%0d] \t%0h\n ", s, i, data[i]);
                  end
                  $sformat( s, "%s response \t%0b\n ", s, response);
                  return s;
                endfunction:convert2string
                
                endclass: apb_rw
                
