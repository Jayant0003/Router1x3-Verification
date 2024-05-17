class dest_agent_config extends uvm_object;
`uvm_object_utils(dest_agent_config)

uvm_active_passive_enum is_active;
virtual router_dest_if rif;
static int dest_drv_xtn_count;
static int dest_mon_xtn_count;

function new(string name=get_type_name());
	super.new(name);
endfunction

endclass
