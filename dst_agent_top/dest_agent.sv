class dest_agent extends uvm_agent;
`uvm_component_utils(dest_agent)

dest_driver drvh;
dest_monitor monh;
dest_sequencer seqrh;
 
dest_agent_config dest_agt_cfg;
env_config e_cfg;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(dest_agent_config)::get(this,"","dest_agent_config",dest_agt_cfg))
		`uvm_fatal(get_type_name(),"error while getting dest_agent_config")
	monh=dest_monitor::type_id::create("monh",this);
	if(dest_agt_cfg.is_active==UVM_ACTIVE) begin
		drvh=dest_driver::type_id::create("drvh",this);
		seqrh=dest_sequencer::type_id::create("seqrh",this);
	end
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(dest_agt_cfg.is_active==UVM_ACTIVE)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
endclass
