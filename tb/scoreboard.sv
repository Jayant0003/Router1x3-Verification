class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
uvm_tlm_analysis_fifo#(src_xtn) fifo_src[];
uvm_tlm_analysis_fifo#(dest_xtn) fifo_dest[];

env_config env_cfg;
int addr;
src_xtn s_xtn;
dest_xtn d_xtn;
src_xtn src_cov_data;
dest_xtn dest_cov_data;
static int p;
int no_of_cycles;
dest_seq4 d_seq;
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);

	s_xtn=new;
	d_xtn=new;
	cov1=new;
	cov2=new;
endfunction

covergroup cov1;
option.per_instance=1;
header: coverpoint src_cov_data.header[1:0]{ bins zero={2'b00};
						bins one={2'b01};
						bins two={2'b10};}
payload: coverpoint src_cov_data.header[7:2] { bins small_pkt={[1:13]};
						bins medium_pkt={[14:30]};
						bins large_pkt={[31:63]};}
err: coverpoint src_cov_data.error {bins error={1};}
headerxpayload: cross header,payload;
endgroup

covergroup cov2;
	option.per_instance=1;
header: coverpoint dest_cov_data.header[1:0]{ bins zero={2'b00};
						bins one={2'b01};
						bins two={2'b10};}
payload: coverpoint dest_cov_data.header[7:2] { bins small_pkt={[1:13]};
						bins medium_pkt={[14:30]};
						bins large_pkt={[31:63]};}
//cycles: coverpoint dest_cov_data.no_of_cycles {bins low30={[0:29]};
//						bins high30 ={[30:31]};}
						
headerxpayload: cross header,payload;


endgroup

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal(get_type_name(),"error while getting env_cfg")
//	if(!uvm_config_db #(int)::get(this,"","addr",addr))		
//		`uvm_fatal(get_type_name(),"error while getting addr")

	fifo_src=new[env_cfg.no_of_src_agents];
	fifo_dest=new[env_cfg.no_of_dest_agents];
	if(env_cfg.has_src_agent) begin
		for(int i=0;i<env_cfg.no_of_src_agents;i++)
			fifo_src[i]=new($sformatf("fifo_src[%0d]",i),this);		
			end
	if(env_cfg.has_dest_agent) begin
		for(int i=0;i<env_cfg.no_of_dest_agents;i++)		
			fifo_dest[i]=new($sformatf("fifo_dest[%0d]",i),this);
		end
endfunction

task run_phase(uvm_phase phase);
	$display("IN SB");
	super.run_phase(phase);
   d_seq=new();
   
//	index=int'(addr);
	forever begin
   
   
	uvm_config_db #(int)::wait_modified(this,"","addr");
	if(!uvm_config_db #(int)::get(this,"","addr",addr))
		`uvm_error(get_type_name(),"error while getting addr")
	$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ addr in sb =",addr);

fork
	begin
	fifo_src[0].get(s_xtn);
	src_cov_data=s_xtn;
	cov1.sample();	
	end
	begin
	fifo_dest[addr].get(d_xtn);
// no_of_cycles=d_seq.send();s
	//	$display("in SB run_phase no_of_cycles=%0d",d_seq.send());
  // d_xtn.no_of_cycles=no_of_cycles;
	dest_cov_data=d_xtn;
	cov2.sample();
	end
join
	compare(s_xtn,d_xtn);

end
	
endtask
function void report_phase(uvm_phase phase);
		$display("========================================================");
	$display("src_coverage = %f",cov1.get_coverage());
	$display("dest_coverage = %0f",cov2.get_coverage());
endfunction
function void compare(src_xtn s_xtn,dest_xtn d_xtn);
int k=0;
	if(s_xtn.header==d_xtn.header ) begin
		foreach(s_xtn.payload[i]) begin
			if(s_xtn.payload[i]!=d_xtn.payload[i]) begin
				k++;
			`uvm_info(get_type_name(),$sformatf("payload ITEM %0d MIS_MATCHED",i),UVM_LOW)
      end
			end
		if(s_xtn.parity!=d_xtn.parity) begin
				k++;
			`uvm_info(get_type_name(),"parity MIS_MATCHED",UVM_LOW)			
		end

     	if(k==0) begin
	 	p++;
		`uvm_info(get_type_name(),$sformatf("ITEM MATCHED COUNT = %0d %0d",p,k),UVM_LOW)
	 	end
		
		
    
	end			
	else
		`uvm_info(get_type_name(),"header MIS_MATCHED",UVM_LOW);
endfunction
endclass
