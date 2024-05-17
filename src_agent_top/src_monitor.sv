class src_monitor extends uvm_monitor;
`uvm_component_utils(src_monitor)
virtual router_src_if.SRC_MON_MP rif;
src_agent_config src_agt_cfg;
src_xtn xtn;
uvm_analysis_port #(src_xtn) ap;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
	ap=new("ap",this);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",src_agt_cfg))
		`uvm_fatal(get_type_name(),"getting error while src_agt_cfg");
endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rif=src_agt_cfg.rif;
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever 
		collect_data();
endtask
task collect_data();
	xtn=src_xtn::type_id::create("xtn");
	@(rif.src_mon_cb);

	while(rif.src_mon_cb.busy===1)
		@(rif.src_mon_cb);

	while(rif.src_mon_cb.pkt_valid!==1)
		@(rif.src_mon_cb);
	xtn.header=rif.src_mon_cb.din;

	@(rif.src_mon_cb);
	xtn.payload=new[xtn.header[7:2]];
		
	foreach(xtn.payload[i]) begin
		while(rif.src_mon_cb.busy===1)
			@(rif.src_mon_cb);
		xtn.payload[i]=rif.src_mon_cb.din;
		@(rif.src_mon_cb);
	end
	
	while(rif.src_mon_cb.busy===1|| rif.src_mon_cb.pkt_valid==1) 
		@(rif.src_mon_cb);
	xtn.parity=rif.src_mon_cb.din;

//	@(rif.src_mon_cb);//1st data will be lost if commented 
//either use case equality operator or give delay here
	xtn.error=rif.src_mon_cb.error;
	xtn.busy=rif.src_mon_cb.busy;
	ap.write(xtn);
	if(xtn.header!=0) begin
	src_agt_cfg.src_mon_xtn_count++;
//	`uvm_info(get_type_name(),$sformatf("data in src monitor %s src_mon_xtn_count=%0d",xtn.sprint(),src_agt_cfg.src_mon_xtn_count),UVM_LOW)
	end
endtask

endclass


