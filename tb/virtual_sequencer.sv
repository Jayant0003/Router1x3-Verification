class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
`uvm_component_utils(virtual_sequencer)
src_sequencer src_seqrh[];
dest_sequencer dest_seqrh[];
env_config env_cfg;

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"error while getting env_cfg");
	if(env_cfg.has_src_agent)
	src_seqrh=new[env_cfg.no_of_src_agents];

	if(env_cfg.has_dest_agent)
	dest_seqrh=new[env_cfg.no_of_dest_agents];
endfunction
endclass
