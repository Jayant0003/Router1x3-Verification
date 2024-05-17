class dest_driver extends uvm_driver#(dest_xtn);
`uvm_component_utils(dest_driver)
virtual router_dest_if.DEST_DRV_MP rif;
dest_agent_config dest_agt_cfg;

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);

endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(dest_agent_config)::get(this,"","dest_agent_config",dest_agt_cfg))
		`uvm_fatal(get_type_name(),"error while getting dest_agt_Cfg");
endfunction
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rif=dest_agt_cfg.rif;
endfunction
task run_phase(uvm_phase phase);
	$display("IN DRIVER");
	super.run_phase(phase);
	forever begin
	seq_item_port.get_next_item(req);
	drive(req);
	seq_item_port.item_done();
	end
endtask
task drive(dest_xtn xtn);
	@(rif.dest_drv_cb);
	while(rif.dest_drv_cb.vld_out!==1)// dut is not here so vld_out is x .... x !==1 is always true  but x !=1 is false
		@(rif.dest_drv_cb);
	repeat(xtn.no_of_cycles)
		@(rif.dest_drv_cb);
	rif.dest_drv_cb.read_en<=1'b1;


	while(rif.dest_drv_cb.vld_out===1'b1)
		@(rif.dest_drv_cb);
	rif.dest_drv_cb.read_en<=1'b0;
//	$display("@@@@@@@@@@@@ read_en=0 at %0t",$time);
	$display("no_of_cycles=%0d",xtn.no_of_cycles);
	dest_agt_cfg.dest_drv_xtn_count++;
 	$display("######################################### no of cycles = 0d",xtn.no_of_cycles);

//	`uvm_info(get_type_name(),$sformatf("data from dest_driver %s  dest_drv_xtn_count=%0d",xtn.sprint(),dest_agt_cfg.dest_drv_xtn_count),UVM_LOW)
endtask

endclass
