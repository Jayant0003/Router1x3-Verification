class test_lib extends uvm_test;
`uvm_component_utils(test_lib)
env envh;
env_config e_cfg;
src_agent_config src_agt_cfg[];
dest_agent_config dest_agt_cfg[];
int no_of_src_agents=1;
int no_of_dest_agents=3;
bit has_virtual_sequencer=1;
bit has_src_agent=1;
bit has_dest_agent=1;
bit has_scoreboard=1;
int  addr;
virtual_seqs v_seq;
vseq1x1 vseq1;
vseq2x1 vseq2;
vseq3x1 vseq3;
vseq4x1 vseq4;
vseq0x1 vseq9;
extended_custom_phase ex_phase;


function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
  add_my_phase();
endfunction

function void build_phase(uvm_phase phase);
	
// uvm_phase schedule; 
	
	e_cfg=new;
	if(has_src_agent)
	e_cfg.src_agt_cfg=new[no_of_src_agents];
	
	if(has_dest_agent)
	e_cfg.dest_agt_cfg=new[no_of_dest_agents];
	
	config_tb();

	uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
	super.build();
	envh=env::type_id::create("envh",this);
 

ex_phase=extended_custom_phase::type_id::create("ex_phase",this);
 

  
  
   
  /*    schedule = uvm_domain::get_uvm_schedule(); // The predefined UVM Run-Time schedule
      schedule.add(uvm_user_phase::get(), .after_phase(uvm_configure_phase::get()), 
                                             .before_phase(uvm_main_phase::get()));

  */    

          
    super.build_phase(phase);
endfunction
function void config_tb();
	if(has_src_agent)
		src_agt_cfg=new[no_of_src_agents];
	
	foreach(src_agt_cfg[i]) begin
		src_agt_cfg[i]=new;
		if(!uvm_config_db #(virtual router_src_if)::get(this,"",$sformatf("s_if%0d",i),src_agt_cfg[i].rif))
			`uvm_fatal(get_type_name(),"error while getting router_if")
		src_agt_cfg[i].is_active=UVM_ACTIVE;
		e_cfg.src_agt_cfg[i]=src_agt_cfg[i];
	end
	
	if(has_dest_agent)
		dest_agt_cfg=new[no_of_dest_agents];
	foreach(dest_agt_cfg[i]) begin
		dest_agt_cfg[i]=new;
		if(!uvm_config_db #(virtual router_dest_if)::get(this,"",$sformatf("d_if%0d",i),dest_agt_cfg[i].rif))
			`uvm_fatal(get_type_name(),"error while getting router_if")
		dest_agt_cfg[i].is_active=UVM_ACTIVE;
	
		e_cfg.dest_agt_cfg[i]=dest_agt_cfg[i];
	end
	e_cfg.has_src_agent=has_src_agent;
	e_cfg.has_dest_agent=has_dest_agent;
	e_cfg.no_of_src_agents=no_of_src_agents;
	e_cfg.no_of_dest_agents=no_of_dest_agents;	
	e_cfg.has_virtual_sequencer=has_virtual_sequencer;
	e_cfg.has_scoreboard=has_scoreboard;

endfunction

function void add_my_phase();
   uvm_domain dm=uvm_domain::get_common_domain();
    uvm_phase ph=dm.find(uvm_connect_phase::get());
    dm.add(uvm_user_phase::get(),null,ph,null);
endfunction
    


function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction
function construct();
  v_seq=virtual_seqs::type_id::create("v_seq");
endfunction


endclass

class test extends test_lib;
`uvm_component_utils(test)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	//	 addr=$urandom_range(0,2);
	//	$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
	//	uvm_config_db #(int)::set(this,"*","addr",addr);


endfunction

task run_phase(uvm_phase phase);
	$display("in TEST run_phase");
	super.run_phase(phase);////////////TEST RUN_PHASE IS NOT STARTING AT 0 SIM TIME,,,IT HAS SOME DELAY THAN THAT OF LOWER COMP START TIME OF RUN PHASE
				// that why if i am setting addr in config_db in run phase and getting addr in run_phase of scoreboard the first 3 addr i am 					// not getting in scoreboard;
	phase.raise_objection(this);

 virtual_seqs::type_id::set_type_override(vseq1x1::get_type());
  super.construct();
	//vseq1=vseq1x1::type_id::create("vseq1");
	repeat(4) begin
		 addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);

		v_seq.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask


endclass
class test1 extends test_lib;
`uvm_component_utils(test1)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 


endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
//	vseq2=vseq2x1::type_id::create("vseq2");
 virtual_seqs::type_id::set_type_override(vseq2x1::get_type());
  super.construct();

	repeat(4) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);
		v_seq.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass

class test2 extends test_lib;
`uvm_component_utils(test2)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
//	vseq3=vseq3x1::type_id::create("vseq3");
 virtual_seqs::type_id::set_type_override(vseq3x1::get_type());
  super.construct();

	repeat(4) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);

		v_seq.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass

class test3 extends test_lib;
`uvm_component_utils(test3)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
//	vseq4=vseq4x1::type_id::create("vseq4");
 virtual_seqs::type_id::set_type_override(vseq4x1::get_type());
  super.construct();

	repeat(4) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);

		v_seq.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass

/*class test4 extends test_lib;
`uvm_component_utils(test4)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
	vseq5=vseq1x2::type_id::create("vseq5");
	repeat(3) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);

		vseq5.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass

class test5 extends test_lib;
`uvm_component_utils(test5)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 


endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
	vseq6=vseq2x2::type_id::create("vseq6");
	repeat(3) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);
		vseq6.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass

class test6 extends test_lib;
`uvm_component_utils(test6)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
	vseq7=vseq3x2::type_id::create("vseq7");
	repeat(3) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);

		vseq7.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass

class test7 extends test_lib;
`uvm_component_utils(test7)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
	vseq8=vseq4x2::type_id::create("vseq8");
	repeat(3) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);

		vseq8.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass
*/
class test4 extends test_lib;
`uvm_component_utils(test4)
function new(string name=get_type_name(),uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		 

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);
//	vseq9=vseq0x2::type_id::create("vseq9");
 virtual_seqs::type_id::set_type_override(vseq0x1::get_type());
  super.construct();

	repeat(5) begin
		addr=$urandom_range(0,2);
		$display("$$$$$$$$$$$$$$$$$$$$$ addr in test =",addr);
		uvm_config_db #(int)::set(this,"*","addr",addr);

		v_seq.start(envh.v_sequencer);
	end
	phase.drop_objection(this);

endtask
endclass




			
  	
