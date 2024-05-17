interface router_dest_if(input bit clock);
	logic read_en;
	logic [7:0] dout;
	bit vld_out;//if router_DUT is not conneted keep it as logic..if bit infinite loop
//modport DUV(input clock,read_en,din,output dout,vld_out);
	
	clocking dest_drv_cb @(posedge clock);
		default input #1 output #1;
		output read_en;
		input vld_out;
	endclocking

	clocking dest_mon_cb @(posedge clock);
		default input #1 output #1;
		input dout;
		input read_en;
	endclocking
	
modport DEST_DRV_MP (clocking dest_drv_cb);
modport DEST_MON_MP (clocking dest_mon_cb);
endinterface
	

	


	

