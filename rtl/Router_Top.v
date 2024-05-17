module Router_Top(input clk,
                  input resetn,
                  input [7:0] din,
                  input pkt_valid,
                  input read_enb_0,
                  input read_enb_1,
                  input read_enb_2,
                  output [7:0] dout0,
                  output [7:0] dout1,
                  output [7:0] dout2,
                  output vld_out_0,
                  output vld_out_1,
                  output vld_out_2,
                  output err,
                  output busy );

wire parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,full_0,full_1,full_2;
wire [2:0] write_enb;

  wire [7:0]dout;
  
  Router_FSM FSM(clk,resetn,pkt_valid,parity_done,din[1:0],soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,busy,write_enb_reg,rst_int_reg,lfd_state);
  
  Router_Synchronizer  Synchronizer(detect_add,din[1:0],write_enb_reg,clk,resetn,read_enb_0,read_enb_1,read_enb_2,fifo_empty_0,fifo_empty_1,fifo_empty_2,full_0,full_1,full_2,vld_out_0,vld_out_1,vld_out_2,write_enb,fifo_full,soft_rst_0,soft_rst_1,soft_rst_2);
  
Router_Register Register(clk,resetn,pkt_valid,din,fifo_full,rst_int_reg,detect_add,lfd_state,laf_state,full_state,ld_state,parity_done,low_pkt_valid,err,dout);
 
  Router_FIFO FIFO_0(clk,resetn,write_enb[0],soft_rst_0,read_enb_0,dout,lfd_state,fifo_empty_0,full_0,dout0);
 
  Router_FIFO FIFO_1(clk,resetn,write_enb[1],soft_rst_1,read_enb_1,dout,lfd_state,fifo_empty_1,full_1,dout1);
  
  Router_FIFO FIFO_2(clk,resetn,write_enb[2],soft_rst_2,read_enb_2,dout,lfd_state,fifo_empty_2,full_2,dout2);

endmodule

