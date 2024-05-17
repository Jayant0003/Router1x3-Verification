class src_agent_top extends uvm_env;
`uvm_component_utils(src_agent_top)

src_agent sagent[];
env_config e_cfg;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(env_config)::get(this,"","env_config",e_cfg);
	sagent=new[e_cfg.no_of_src_agents];

	foreach(sagent[i]) begin
		sagent[i]=src_agent::type_id::create($sformatf("sagent[%0d]",i),this);
		uvm_config_db #(src_agent_config)::set(this,$sformatf("sagent[%0d]*",i),"src_agent_config",e_cfg.src_agt_cfg[i]);
	end
	
endfunction

endclass
