class dest_agent_top extends uvm_env;
`uvm_component_utils(dest_agent_top)

dest_agent dagent[];
env_config e_cfg;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(env_config)::get(this,"","env_config",e_cfg);
	dagent=new[e_cfg.no_of_dest_agents];
	foreach(dagent[i]) begin
		dagent[i]=dest_agent::type_id::create($sformatf("dagent[%0d]",i),this);
		uvm_config_db #(dest_agent_config)::set(this,$sformatf("dagent[%0d]*",i),"dest_agent_config",e_cfg.dest_agt_cfg[i]);	
	end

endfunction

endclass
