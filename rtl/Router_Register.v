module Router_Register(input clk,
                       input resetn,
                       input pkt_valid,
                       input [7:0] din,
                       input fifo_full,
                       input rst_int_reg,
                       input detect_add,
                       input lfd_state,
                       input laf_state,
                       input full_state,
                       input ld_state,
                       output reg parity_done,
                       output reg low_pkt_valid,
                       output reg err,
                       output reg [7:0] dout);
  
  reg [7:0] header_byte,fifo_full_state_byte;
  reg [7:0] packet_parity,internal_parity;
  
  // dout logic
  always @(posedge clk) begin
    if(~resetn)
      dout<=0;
    else if(lfd_state)
      dout<=header_byte;
    else if(ld_state && ~fifo_full)
      dout<=din;
    else if(laf_state)
      dout<=fifo_full_state_byte;
    else 
      dout<=dout;
  end
  
  // header_byte and FIFO_full_state_byte logic
  always @(posedge clk) begin
    if(~resetn)
    {header_byte,fifo_full_state_byte}<=16'b0;
    else begin
      if(detect_add && pkt_valid)
      header_byte<=din;
    else if(fifo_full && ld_state)
      fifo_full_state_byte<=din; 
      else
        {header_byte,fifo_full_state_byte}<={header_byte,fifo_full_state_byte};
  end
  end
  
  
  // parity_done logic
  always @(posedge clk) begin
    if(~resetn || detect_add)
      parity_done<=0;
    else if((ld_state && ~pkt_valid && ~fifo_full) || (laf_state &&  low_pkt_valid && !parity_done))
        parity_done<=1;
      else if(laf_state && low_pkt_valid && ~parity_done)
        parity_done<=1;
      else 
        
          parity_done<=parity_done;
          end
  
  // low_pkt_valid logic
  always @(posedge clk) begin
    if(~resetn || rst_int_reg)
      low_pkt_valid<=0;
    else if(ld_state && ~pkt_valid)
        low_pkt_valid<=1'b1;
      else
        low_pkt_valid<=low_pkt_valid;
    end 
  
  //packet_parity(received parity) logic
  always @(posedge clk) begin
    if(~resetn || detect_add)
      packet_parity<=0;
    else if(!pkt_valid)
        packet_parity<=din;
      else 
          packet_parity<=packet_parity;
  end
  
  
  
  //internal_parity logic
  always @(posedge clk) begin
    if(~resetn || detect_add)
      internal_parity<=0;
    else if(pkt_valid && !fifo_full)
        internal_parity<=internal_parity ^ din;
      else
        internal_parity<=internal_parity;
    end 
  
  
  //error logic
  always @(posedge clk) begin
    if(~resetn)
      err<=0;
    else if(!pkt_valid && rst_int_reg) begin
        if(internal_parity !== packet_parity)
          err<=1'b1;
      else 
        err<=1'b0;
    end
    else  
      err<=err;
    end 
  
endmodule
