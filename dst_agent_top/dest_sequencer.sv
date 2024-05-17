class dest_sequencer extends uvm_sequencer#(dest_xtn);
`uvm_component_utils(dest_sequencer)

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

endclass
