class src_agent extends uvm_agent;
`uvm_component_utils(src_agent)

src_driver drvh;
src_monitor monh;
src_sequencer seqrh;
 
src_agent_config src_agt_cfg;

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",src_agt_cfg))
		`uvm_fatal(get_type_name(),"error while getting src_agent_config")
	monh=src_monitor::type_id::create("monh",this);

	if(src_agt_cfg.is_active==UVM_ACTIVE) begin
		drvh=src_driver::type_id::create("drvh",this);
		seqrh=src_sequencer::type_id::create("seqrh",this);
	end
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
endclass
