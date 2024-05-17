module Router_FSM(input clk,
                  input resetn,
                  input pkt_valid,
                  input parity_done,
                  input [1:0] din,
                  input soft_rst_0,
                  input soft_rst_1,
                  input soft_rst_2,
                  input fifo_full,
                  input low_pkt_valid,
                  input fifo_empty_0,
                  input fifo_empty_1,
                  input fifo_empty_2,
                  output detect_add,
                  output ld_state,
                  output laf_state,
                  output full_state,
                  output busy,
                  output write_enb_reg,
                  output rst_int_reg,
                  output lfd_state);
  reg [1:0] addr;
  reg [2:0] present_state,next_state;
  parameter DECODE_ADDRESS= 3'b000,
  			LOAD_FIRST_DATA= 3'b001,
  			LOAD_DATA= 3'b010,
  			FIFO_FULL_STATE= 3'b011,
  			LOAD_AFTER_FULL= 3'b100,
  			LOAD_PARITY= 3'b101,
  			CHECK_PARITY_ERROR= 3'b110,
  			WAIT_TILL_EMPTY= 3'b111;
  
  //internal variable add logic
  always @(posedge clk) begin   
    if(~resetn)
      addr<=2'b0;
    else if(detect_add)    
        addr<=din;
    else
      addr<=addr; 
  end
  
  //present_state logic
  always @(posedge clk) begin
    if(~resetn)
      present_state<=DECODE_ADDRESS;
    else 
      if((soft_rst_0 )||(soft_rst_1 ) ||(soft_rst_2 ))
  		present_state<=DECODE_ADDRESS;
      else
        present_state<=next_state; 
  end
  
  //next_state logic
  always @(*) begin
    if(~resetn)
      next_state<=DECODE_ADDRESS;
      else if(soft_rst_0|| soft_rst_1|| soft_rst_2)
        next_state<=DECODE_ADDRESS;
        else 
        begin
    
      case(present_state)
        DECODE_ADDRESS: begin if((pkt_valid & (din==2'b00) & fifo_empty_0) | (pkt_valid &(din==2'b01) & fifo_empty_1) | (pkt_valid & (din==2'b10) & fifo_empty_2))
          next_state<=LOAD_FIRST_DATA;
           else if((pkt_valid&&(din==2'b0) & !fifo_empty_0) | (pkt_valid & (din==2'b1) & !fifo_empty_1) | (pkt_valid & (din==2'b10) & !fifo_empty_2))
          next_state<=WAIT_TILL_EMPTY;
          else 
            next_state<=DECODE_ADDRESS; end
        LOAD_FIRST_DATA: next_state<=LOAD_DATA;
        LOAD_DATA:begin if(fifo_full)
          next_state<=FIFO_FULL_STATE;
          else if(!fifo_full & !pkt_valid)
            next_state<=LOAD_PARITY;
          else
            next_state<=LOAD_DATA; end
         FIFO_FULL_STATE: begin
           if(!fifo_full)
             next_state<=LOAD_AFTER_FULL;
           else
             next_state<=FIFO_FULL_STATE; end
         LOAD_AFTER_FULL: begin
           if(parity_done)
             next_state<=DECODE_ADDRESS;
           else  begin
              if(!low_pkt_valid)
             next_state<=LOAD_DATA;
            else 
              next_state<=LOAD_PARITY;
           end

               end

          LOAD_PARITY: next_state<=CHECK_PARITY_ERROR;
          CHECK_PARITY_ERROR: begin
            if(!fifo_full)
              next_state<=DECODE_ADDRESS;
            else
              next_state<=FIFO_FULL_STATE; end
          WAIT_TILL_EMPTY: begin
            if((fifo_empty_0 && addr==2'd0) || (fifo_empty_1 && addr==2'd1)|| (fifo_empty_2 && addr==2'd2))
              next_state<=LOAD_FIRST_DATA;
            else
              next_state<=WAIT_TILL_EMPTY; end
          default: next_state<=DECODE_ADDRESS;
          endcase
        end
        end 
  // Output SIgnals
  
  assign detect_add=(present_state==DECODE_ADDRESS)?1'b1:1'b0;
  assign lfd_state=(present_state==LOAD_FIRST_DATA)?1'b1:1'b0;
  assign ld_state=(present_state==LOAD_DATA)?1'b1:1'b0;
  assign full_state=(present_state==FIFO_FULL_STATE)?1'b1:1'b0;
  assign laf_state=(present_state==LOAD_AFTER_FULL)?1'b1:1'b0;
  assign rst_int_reg=(present_state==CHECK_PARITY_ERROR)?1'b1:1'b0;
  assign write_enb_reg=((present_state==LOAD_DATA)||(present_state==LOAD_AFTER_FULL)||(present_state==LOAD_PARITY))?1'b1:1'b0;
  assign busy=((present_state==WAIT_TILL_EMPTY)||(present_state==LOAD_FIRST_DATA)||(present_state==LOAD_AFTER_FULL)||(present_state==FIFO_FULL_STATE)||(present_state==CHECK_PARITY_ERROR)||(present_state==LOAD_PARITY))?1'b1:1'b0;
  
 
  
  
  
endmodule
 
 


 
