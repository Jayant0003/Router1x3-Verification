class dest_seqs extends uvm_sequence#(dest_xtn);
`uvm_object_utils(dest_seqs)
int no_of_cycles;
function new(string name=get_type_name());
	super.new(name);
endfunction

endclass

class dest_seq4 extends dest_seqs;
`uvm_object_utils(dest_seq4)

function new(string name=get_type_name());
	super.new(name);
endfunction

task body();

	req=dest_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles<30;});
 // no_of_cycles=req.no_of_cycles;
  // $display("in seq^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ no_of_cyles=%d",no_of_cycles);
	finish_item(req);

endtask

virtual function int send();
return no_of_cycles;
endfunction

endclass


class dest_seq30 extends dest_seqs;
`uvm_object_utils(dest_seq30)

function new(string name=get_type_name());
	super.new(name);
endfunction

task body();

	req=dest_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles==30;});
  
	finish_item(req);

endtask



endclass
