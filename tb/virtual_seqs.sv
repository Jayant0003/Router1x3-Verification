class virtual_seqs extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(virtual_seqs)

env_config env_cfg;

virtual_sequencer v_sequencer;
src_sequencer src_seqrh[];
dest_sequencer dest_seqrh[];

src_small s_seq1;
src_medium s_seq2;
src_big s_seq3;
src_random s_seq4;
src_err s_seq0;
dest_seq4 d_seq1;
dest_seq30 d_seq2;
int addr;
src_seqs s_seq;
dest_seqs d_seq;
function new(string name=get_type_name());
	super.new(name);
endfunction
function build();
  s_seq=src_seqs::type_id::create("s_seq");
  d_seq=dest_seqs::type_id::create("d_seq");
endfunction
task body();

	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
		`uvm_fatal(get_type_name(),"eror while getting env_cfg")
//	src_seqrh=new[env_cfg.no_of_src_agents];
//	dest_seqrh=new[env_cfg.no_of_dest_agents];
	
	assert($cast(v_sequencer,m_sequencer))
	else
		`uvm_error(get_type_name(),"error while casting m_sequencer to v_sequencer")
	src_seqrh=new[env_cfg.no_of_src_agents];
	dest_seqrh=new[env_cfg.no_of_dest_agents];
	foreach(src_seqrh[i]) 
		src_seqrh[i]=v_sequencer.src_seqrh[i];

	foreach(dest_seqrh[i]) 
		dest_seqrh[i]=v_sequencer.dest_seqrh[i];	
endtask


endclass

class vseq1x1 extends virtual_seqs;
`uvm_object_utils(vseq1x1)

function new(string name=get_type_name());
	super.new(name);
endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")
  
	//index=int'(addr);
src_seqs::type_id::set_type_override(src_small::get_type());
 dest_seqs::type_id::set_type_override(dest_seq4::get_type());
 super.build();
//	s_seq1=src_small::type_id::create("s_seq1");
//	d_seq1=dest_seq4::type_id::create("d_seq1");
fork
	if(env_cfg.has_src_agent) begin
		s_seq.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq.start(dest_seqrh[addr]);
	end
join
endtask

endclass
class vseq2x1 extends virtual_seqs;
`uvm_object_utils(vseq2x1)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
//	s_seq2=src_medium::type_id::create("s_seq2");
//	d_seq1=dest_seq4::type_id::create("d_seq1");
src_seqs::type_id::set_type_override(src_medium::get_type());
 dest_seqs::type_id::set_type_override(dest_seq4::get_type());
 super.build();

fork
	if(env_cfg.has_src_agent) begin
		s_seq.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq.start(dest_seqrh[addr]);
	end
join
endtask

endclass
class vseq3x1 extends virtual_seqs;
`uvm_object_utils(vseq3x1)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
//	s_seq3=src_big::type_id::create("s_seq3");
//	d_seq1=dest_seq4::type_id::create("d_seq1");
src_seqs::type_id::set_type_override(src_big::get_type());
 dest_seqs::type_id::set_type_override(dest_seq4::get_type());
 super.build();

fork
	if(env_cfg.has_src_agent) begin
		s_seq.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq.start(dest_seqrh[addr]);
	end
join
endtask

endclass
class vseq4x1 extends virtual_seqs;
`uvm_object_utils(vseq4x1)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
//	s_seq4=src_random::type_id::create("s_seq4");
//	d_seq1=dest_seq4::type_id::create("d_seq1");
src_seqs::type_id::set_type_override(src_random::get_type());
 dest_seqs::type_id::set_type_override(dest_seq4::get_type());
 super.build();

fork
	if(env_cfg.has_src_agent) begin
		s_seq.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq.start(dest_seqrh[addr]);
	end
join
endtask

endclass
/*class vseq1x2 extends virtual_seqs;
`uvm_object_utils(vseq1x2)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
	s_seq1=src_small::type_id::create("s_seq1");
	d_seq2=dest_seq30::type_id::create("d_seq2");
fork
	if(env_cfg.has_src_agent) begin
		s_seq1.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq2.start(dest_seqrh[addr]);
	end
join
endtask

endclass
class vseq2x2 extends virtual_seqs;
`uvm_object_utils(vseq2x2)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
	s_seq2=src_medium::type_id::create("s_seq2");
	d_seq2=dest_seq30::type_id::create("d_seq2");
fork
	if(env_cfg.has_src_agent) begin
		s_seq2.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq2.start(dest_seqrh[addr]);
	end
join
endtask

endclass
class vseq3x2 extends virtual_seqs;
`uvm_object_utils(vseq3x2)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
	s_seq3=src_big::type_id::create("s_seq3");
	d_seq2=dest_seq30::type_id::create("d_seq2");
fork
	if(env_cfg.has_src_agent) begin
		s_seq3.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq2.start(dest_seqrh[addr]);
	end
join
endtask

endclass
class vseq4x2 extends virtual_seqs;
`uvm_object_utils(vseq4x2)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
	s_seq4=src_random::type_id::create("s_seq4");
	d_seq2=dest_seq30::type_id::create("d_seq2");
fork
	if(env_cfg.has_src_agent) begin
		s_seq4.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq2.start(dest_seqrh[addr]);
	end
join
endtask

endclass
*/
class vseq0x1 extends virtual_seqs;
`uvm_object_utils(vseq0x1)

function new(string name=get_type_name());
	super.new(name);
	endfunction

task body();
	super.body();
        if(!uvm_config_db #(int)::get(null,get_full_name(),"addr",addr))
		`uvm_fatal(get_type_name(),"error while getting addr")

	//index=int'(addr);
//	s_seq0=src_err::type_id::create("s_seq0");
//	d_seq2=dest_seq30::type_id::create("d_seq2");
src_seqs::type_id::set_type_override(src_err::get_type());
 dest_seqs::type_id::set_type_override(dest_seq4::get_type());
 super.build();

fork
	if(env_cfg.has_src_agent) begin
		s_seq.start(src_seqrh[0]);
	end

	if(env_cfg.has_dest_agent) begin
		d_seq.start(dest_seqrh[addr]);
	end
join
endtask

endclass
