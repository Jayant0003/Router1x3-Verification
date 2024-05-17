class env extends uvm_env;
`uvm_component_utils(env)
env_config e_cfg;
src_agent_top sagt_top;
dest_agent_top dagt_top;
virtual_sequencer v_sequencer;
scoreboard sb;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
	//uvm_default_printer=uvm_default_tree_printer;
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
		`uvm_fatal(get_type_name(),"error while getting env_config")

	if(e_cfg.has_src_agent)
		sagt_top=src_agent_top::type_id::create("sagt_top",this);
	if(e_cfg.has_dest_agent)
		dagt_top=dest_agent_top::type_id::create("dagt_top",this);

	if(e_cfg.has_virtual_sequencer)
		v_sequencer=virtual_sequencer::type_id::create("v_sequencer",this);
	if(e_cfg.has_scoreboard)
		sb=scoreboard::type_id::create("sb",this);
endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(e_cfg.has_virtual_sequencer) begin
		if(e_cfg.has_src_agent)
			foreach(sagt_top.sagent[i])
				v_sequencer.src_seqrh[i]=sagt_top.sagent[i].seqrh;
		if(e_cfg.has_dest_agent)
			foreach(dagt_top.dagent[i])
				v_sequencer.dest_seqrh[i]=dagt_top.dagent[i].seqrh;
	end
	if(e_cfg.has_scoreboard) begin

	if(e_cfg.has_src_agent ) begin
		for(int i=0;i<e_cfg.no_of_src_agents;i++)
		sagt_top.sagent[i].monh.ap.connect(sb.fifo_src[i].analysis_export);
		end
	if(e_cfg.has_dest_agent) begin
		for(int i=0;i<e_cfg.no_of_dest_agents;i++)
		dagt_top.dagent[i].monh.ap.connect(sb.fifo_dest[i].analysis_export);

		end

	end
	
endfunction



endclass
		
