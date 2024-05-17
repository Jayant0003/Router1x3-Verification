class src_xtn extends uvm_sequence_item;
`uvm_object_utils(src_xtn)

rand bit[7:0] header;
rand bit[7:0] payload[];
bit[7:0] parity;
bit error;
bit busy;
constraint c_header{header[1:0]!=2'b11;}
constraint c_payload{payload.size==header[7:2];}

function void post_randomize();
	parity=header^0;
	foreach(payload[i])
		parity=parity^payload[i];

endfunction

function void do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("header",header,8,UVM_DEC);
	foreach(payload[i]) begin
		string s=$sformatf("%d",payload[i]);
		printer.print_generic($sformatf("payload[%0d]",i),"int",$size(payload[i]),s);
	end
	printer.print_field("parity",parity,8,UVM_DEC);
	printer.print_field("error",error,1,UVM_BIN);
	printer.print_field("busy",busy,1,UVM_BIN);
endfunction

endclass
