class dest_xtn extends uvm_sequence_item;
`uvm_object_utils(dest_xtn)

bit[7:0] header;
bit[7:0] payload[];
bit[7:0] parity;
bit error;
bit busy;
rand bit[4:0] no_of_cycles;

//constraint c11{soft no_of_cycles==6;}

function new(string name=get_type_name());
	super.new(name);
endfunction
/*function bit do_compare(uvm_object rhs,uvm_comparer comparer);
	src_xtn rhs_;
	if(!$cast(rhs_,rhs)) begin
		`uvm_error(get_type_name(),"error while casting");
		return 0;
	end
	return super.do_compare(rhs,comparer) && this.header==rhs_.header && this.payload==rhs_.payload && this.parity==rhs_.parity;
endfunction
*/
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
	printer.print_field("no_of_cycles",no_of_cycles,5,UVM_DEC);
endfunction

endclass

