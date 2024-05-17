interface router_src_if(input bit clock);
	logic [7:0] din;
	logic pkt_valid;
	logic resetn;
	logic error;
	logic busy;
//	modport DUV(input clock,resetn,din,pkt_valid,output error,busy);

	clocking src_drv_cb @(posedge clock);
		default input #1 output #1 ;
		output din;
		output pkt_valid;
		output resetn;
		input busy;
		input error;
	endclocking
	clocking src_mon_cb @(posedge clock);
		default input #1 output #1;
		input din;
		input pkt_valid;
		input resetn;
		input busy;
		input error;
	endclocking
	
	
modport SRC_DRV_MP (clocking src_drv_cb);
modport SRC_MON_MP (clocking src_mon_cb);
endinterface
	

	


	

