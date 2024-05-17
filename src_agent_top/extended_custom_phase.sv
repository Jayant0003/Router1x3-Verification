class extended_custom_phase extends custom_phase;
`uvm_component_utils(extended_custom_phase)

function new(string name=get_type_name(),uvm_component parent);
  super.new(name,parent);
  endfunction
  
  task user_phase(uvm_phase phase);
     phase.raise_objection(this);
     //#1;  //run_phase must start at 0 sim time otherwise fatal error
  `uvm_info(get_type_name(),$sformatf("in %s phase ++++++++++++++++++++++++++====================",phase.get_name()),UVM_LOW)
  phase.drop_objection(this);
  endtask
  
  
  
  endclass