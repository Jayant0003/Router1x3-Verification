class custom_phase extends uvm_component;

function new(string name="",uvm_component parent);
  super.new(name,parent);
  endfunction
  
  virtual task user_phase(uvm_phase phase);  

  endtask
endclass