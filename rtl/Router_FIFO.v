module Router_FIFO(input clk,
                  input resetn,
                  input write_enb,
                  input soft_rst,
                  input read_enb,
                  input [7:0] din,
                  input lfd_state,
                  output empty,
                  output full,
                  output reg [7:0] dout);

reg [8:0] mem[15:0];
reg [6:0] fifo_counter;
reg [4:0] wr_pt,rd_pt;
reg lfd_state_s;
  integer i;
  //for lfd_state
always @(posedge clk) begin
	if(!resetn)
		lfd_state_s<=1'b0;
	else
		lfd_state_s<=lfd_state;//giving one clock delay to lfd_state signal
end

  
// FIFO counter logic
always @(posedge clk) begin
   if(!resetn) 
    fifo_counter<=7'b0; 
  else if(soft_rst) 
    fifo_counter<=7'b0; 
  else if(read_enb & ~ empty) begin
   
      if(mem[rd_pt[3:0]][8]==1'b1)
      fifo_counter<=mem[rd_pt[3:0]][7:2]+1'b1;
     else if(fifo_counter!=0)
       fifo_counter<=fifo_counter-1'b1;
       else
       fifo_counter<=fifo_counter;
     end 
     else
     fifo_counter<=fifo_counter;
     
     end
  
//FIFO Read operation
always @(posedge clk) begin
  
  if(!resetn) dout<=8'b0;
  else if(soft_rst) dout<=8'bz;
  else if(read_enb && ~ empty)  dout<=mem[rd_pt[3:0]][7:0];
  else if(empty) dout<=8'bz;
  else if(fifo_counter==7'b0) dout<=8'bz;
  else dout<=0;

end

// FIFO Write Operation
always @(posedge clk) begin
  if(!resetn) begin
    for(i=0;i<16;i=i+1) 
      mem[i]<=0;  end
  else if(soft_rst) begin
    for(i=0;i<16;i=i+1) 
      mem[i]<=0;  end
  else begin
    if(write_enb && !full)
    {mem[wr_pt[3:0]]}<={lfd_state_s,din};
        end
  end
// Incrementing Pointer
always @(posedge clk) begin
 
  if(!resetn) begin
    rd_pt=5'b0;
    wr_pt=5'b0; end
  else if(soft_rst) begin
    rd_pt=5'b0;
    wr_pt=5'b0; end
  else begin
    if(!full && write_enb)
      wr_pt<=wr_pt+1;
    else wr_pt=wr_pt;
    if(!empty && read_enb)
      rd_pt<=rd_pt+1;
    else rd_pt=rd_pt; 
    end
end
 
assign full= (wr_pt=={~rd_pt[4],rd_pt[3:0]})?1'b1:1'b0;
assign empty=(wr_pt==rd_pt)?1'b1:1'b0;                
                                       
endmodule


