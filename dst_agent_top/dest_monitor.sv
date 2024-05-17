class dest_monitor extends uvm_monitor;
`uvm_component_utils(dest_monitor)
int i;
//int busy=1;
//int ending;
virtual router_dest_if.DEST_MON_MP rif;
dest_agent_config dest_agt_cfg;
dest_xtn xtn;
uvm_analysis_port #(dest_xtn) ap;

function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
	ap=new("ap",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(dest_agent_config)::get(this,"","dest_agent_config",dest_agt_cfg))
		`uvm_fatal(get_type_name(),"error while getting dest_agt_cfg")
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rif=dest_agt_cfg.rif;
endfunction
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
   i=0;
		collect_data();
//	if(ending)
//		begin
//      #2;
//			busy=0;      
//		phase.drop_objection(this);	end
 end
endtask

/*virtual function void phase_ready_to_end(uvm_phase phase);
  if(phase.get_name=="run") begin
      ending=1;
        if(busy)
            phase.raise_objection(this);
        end
endfunction
*/

task collect_data();
//	i++;
	xtn=dest_xtn::type_id::create("xtn");
	//@(rif.dest_mon_cb);
 
//	$display("entered in collect data read_enb= %b %0t i=%0d",rif.dest_mon_cb.read_en,$time,i);

	while(rif.dest_mon_cb.read_en!==1'b1 ) 
			@(rif.dest_mon_cb);	
      
//	$display("1 read_enb= %b %0t i=%0d",rif.dest_mon_cb.read_en,$time,i);
 
	@(rif.dest_mon_cb);
	xtn.header=rif.dest_mon_cb.dout;
 
	xtn.payload=new[xtn.header[7:2]];
	@(rif.dest_mon_cb);
 
//	$display("2 read_enb= %b %0t i=%0d",rif.dest_mon_cb.read_en,$time,i);

	foreach(xtn.payload[i]) begin
			
		xtn.payload[i]=rif.dest_mon_cb.dout;
		@(rif.dest_mon_cb);
	end
//	$display("3 read_enb= %b %0t i=%0d",rif.dest_mon_cb.read_en,$time,i);

	xtn.parity=rif.dest_mon_cb.dout;
     xtn.no_of_cycles=i;
		`uvm_info(get_type_name(),$sformatf("data from dest_monitor%s \n dest_mon_xtn_count=%0d",xtn.sprint(),dest_agt_cfg.dest_mon_xtn_count),UVM_LOW)
		ap.write(xtn);

	@(rif.dest_mon_cb);
	dest_agt_cfg.dest_mon_xtn_count++;
//	if(xtn.header!=0)
	
endtask

endclass

