module top;
	import uvm_pkg::*;
	import test_pkg::*;
	`include "uvm_macros.svh"
	bit clock;
	always #10 clock=!clock;
	
	router_src_if src_if(clock);
	router_dest_if dest_if_0(clock);
	router_dest_if dest_if_1(clock);
	router_dest_if dest_if_2(clock);
	
	Router_Top DUV(clock,
		src_if.resetn,
		src_if.din,
		src_if.pkt_valid,
		dest_if_0.read_en,
		dest_if_1.read_en,
		dest_if_2.read_en,
		dest_if_0.dout,
		dest_if_1.dout,
		dest_if_2.dout,
		dest_if_0.vld_out,
		dest_if_1.vld_out,
		dest_if_2.vld_out,
		src_if.error,
		src_if.busy);
	
	
	initial begin
	/*	`ifdef VCS
       		$fsdbDumpvars(0, top);
		$fsdbDumpSVA(0,top);
        		`endif
*/


		uvm_config_db #(virtual router_src_if)::set(null,"uvm_test_top","s_if0",src_if);
		uvm_config_db #(virtual router_dest_if)::set(null,"uvm_test_top","d_if0",dest_if_0);
		uvm_config_db #(virtual router_dest_if)::set(null,"uvm_test_top","d_if1",dest_if_1);
		uvm_config_db #(virtual router_dest_if)::set(null,"uvm_test_top","d_if2",dest_if_2);

		run_test();
	end

	property p1;
		@(posedge clock) disable iff(!src_if.resetn)
				$rose(src_if.pkt_valid)|=> src_if.busy;	
	endproperty
	property p2;
		@(posedge clock) disable iff(!src_if.resetn)
				$rose(src_if.busy)|=> $stable(src_if.din);			
	endproperty
	property p3;
	@(posedge clock) disable iff(!src_if.resetn)				
				$rose(dest_if_0.vld_out)|-> ##1 (dest_if_0.read_en[=0:29]) ;		
	endproperty
	property p4;
		@(posedge clock) disable iff(!src_if.resetn)				
				$rose(dest_if_1.vld_out)|-> ##1 dest_if_1.read_en[=0:29] ;			
	endproperty
	property p5;
		@(posedge clock) disable iff(!src_if.resetn)				
				$rose(dest_if_2.vld_out)|-> ##1 dest_if_2.read_en[=0:29] ;		
	endproperty
	property p6;
		@(posedge clock) disable iff(!src_if.resetn)
			$rose(src_if.pkt_valid)|-> dest_if_0.vld_out[=1:3];		
	endproperty
	property p7;
		@(posedge clock) disable iff(!src_if.resetn)
			$rose(src_if.pkt_valid)|-> dest_if_1.vld_out[=1:3];		
	endproperty
	property p8;
		@(posedge clock) disable iff(!src_if.resetn)
			$rose(src_if.pkt_valid)|-> dest_if_2.vld_out[=1:3];		
	endproperty
	property p9;
		@(posedge clock) disable iff(!src_if.resetn)
			$fell(dest_if_0.vld_out)|-> $fell(dest_if_0.read_en);		
	endproperty
	property p10;
		@(posedge clock) disable iff(!src_if.resetn)
			$rose(dest_if_1.vld_out)|-> $fell(dest_if_1.read_en);		
	endproperty
	property p11;
		@(posedge clock) disable iff(!src_if.resetn)
			$rose(dest_if_2.vld_out)|-> $fell(dest_if_2.read_en);		
	endproperty

	assert property(p1)
		`uvm_info("TOP","property P1 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P1 Failed!")
	assert property(p2)
		`uvm_info("TOP","property P2 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P2 Failed!")
assert property(p3)
		`uvm_info("TOP","property P3 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P3 Failed!")
assert property(p4)
		`uvm_info("TOP","property P4 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P4 Failed!")
assert property(p5)
		`uvm_info("TOP","property P5 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P5 Failed!")
assert property(p6)
		`uvm_info("TOP","property P6 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P6 Failed!")
assert property(p7)
		`uvm_info("TOP","property P7 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P7 Failed!")
assert property(p8)
		`uvm_info("TOP","property P8 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P8 Failed!")
assert property(p9)
		`uvm_info("TOP","property P9 Passed",UVM_LOW)
	else
		`uvm_error("TOP","P9 Failed!")





	
endmodule
	
