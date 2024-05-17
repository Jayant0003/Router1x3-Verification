class env_config extends uvm_object;
`uvm_object_utils(env_config)

int no_of_src_agents;
int no_of_dest_agents;

bit has_src_agent;
bit has_dest_agent;
bit has_virtual_sequencer;
bit has_scoreboard;

src_agent_config src_agt_cfg[];
dest_agent_config dest_agt_cfg[];

function new(string name=get_type_name());
	super.new(name);
endfunction
endclass
