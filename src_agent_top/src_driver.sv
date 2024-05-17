class src_driver extends uvm_driver#(src_xtn);
`uvm_component_utils(src_driver)
src_agent_config src_agt_cfg;
virtual router_src_if.SRC_DRV_MP rif;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",src_agt_cfg))
		`uvm_fatal(get_type_name(),"error while getting src_agt_cfg");
endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rif=src_agt_cfg.rif;
endfunction
task run_phase(uvm_phase phase);

	super.run_phase(phase);
	@(rif.src_drv_cb);
	rif.src_drv_cb.resetn<=1'b0;
	@(rif.src_drv_cb);
	rif.src_drv_cb.resetn<=1'b1;
	forever begin
	seq_item_port.get_next_item(req);
	drive(req);
	seq_item_port.item_done();
	end
	
endtask
task drive(src_xtn xtn);
	@(rif.src_drv_cb);
		
	while(rif.src_drv_cb.busy===1)//use !==0 if DUV is connected
		@(rif.src_drv_cb);
	
	rif.src_drv_cb.pkt_valid<=1'b1;
	rif.src_drv_cb.din<=xtn.header;
	@(rif.src_drv_cb);

	foreach(xtn.payload[i]) begin
			while(rif.src_drv_cb.busy===1)
			@(rif.src_drv_cb);
		rif.src_drv_cb.din<=xtn.payload[i];
			@(rif.src_drv_cb);
	end
	while(rif.src_drv_cb.busy===1)
		@(rif.src_drv_cb);
	rif.src_drv_cb.pkt_valid<=1'b0;
	rif.src_drv_cb.din<=xtn.parity;

	src_agt_cfg.src_drv_xtn_count++;
	`uvm_info(get_type_name(),$sformatf("data driven from src driver is %s \n src_drv_xtn_count=%0d",xtn.sprint(),src_agt_cfg.src_drv_xtn_count),UVM_LOW)
	repeat(2)
		@(rif.src_drv_cb);
	xtn.error=rif.src_drv_cb.error;	
	xtn.busy=rif.src_drv_cb.busy;
	
	


endtask
endclass
