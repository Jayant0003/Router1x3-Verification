class src_seqs extends uvm_sequence #(src_xtn);
`uvm_object_utils(src_seqs)
int addr;
function new(string name=get_type_name());
	super.new(name);
endfunction


endclass 

class src_small extends src_seqs;
`uvm_object_utils(src_small)

function new(string name=get_type_name());
	super.new(name);
	
endfunction

task body();
//	repeat(2) begin
	if(!uvm_config_db #(int) ::get(null, get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")
	req=src_xtn::type_id::create("req");
//	$display("in seqs^^^^^^^^^^^^^^^");
	start_item(req);
	assert(req.randomize() with {header[1:0]==addr;header[7:2] inside {[1:13]};});
	finish_item(req);
//	end
endtask

endclass
class src_medium extends src_seqs;
`uvm_object_utils(src_medium)

function new(string name=get_type_name());
	super.new(name);
	
endfunction

task body();
	if(!uvm_config_db #(int) ::get(null, get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")
	req=src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[1:0]==addr;header[7:2] inside {[13:29]};});
	finish_item(req);
endtask

endclass
class src_big extends src_seqs;
`uvm_object_utils(src_big)

function new(string name=get_type_name());
	super.new(name);
	
endfunction

task body();
	if(!uvm_config_db #(int) ::get(null, get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")
	req=src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[1:0]==addr;header[7:2] inside {[30:63]};});
	finish_item(req);
endtask

endclass
class src_random extends src_seqs;
`uvm_object_utils(src_random)

function new(string name=get_type_name());
	super.new(name);
	
endfunction

task body();
	if(!uvm_config_db #(int) ::get(null, get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")
	req=src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[1:0]==addr;});
	finish_item(req);
endtask

endclass
class src_err extends src_seqs;
`uvm_object_utils(src_err)

function new(string name=get_type_name());
	super.new(name);
	
endfunction

task body();
	if(!uvm_config_db #(int) ::get(null, get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")
	req=src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[1:0]==addr;});
   req.parity=5;
	finish_item(req);
endtask

endclass






































































































































































































































