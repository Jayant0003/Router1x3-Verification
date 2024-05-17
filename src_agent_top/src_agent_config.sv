class src_agent_config extends uvm_object;
`uvm_object_utils(src_agent_config)

uvm_active_passive_enum is_active;
virtual router_src_if rif;
static int src_drv_xtn_count;
static int src_mon_xtn_count;

function new(string name=get_type_name());
	super.new(name);
endfunction

endclass
