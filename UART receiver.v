module UART_RX
#(parameter BR = 9600, 
            CLK_RATE = 50e6) //The clock-rate and Bound-rate (frequency of UART) 
(
 input        clk, reset, 
 input        serial_in, //Serial input bit
 output       parity_error, //Check the data with an even parity bit
 output       valid, //Check if the whole data is available
 output [7:0] RX_Byte //The data we received
 );
 
 reg [15:0] clk_counter      = 0;
 reg [3:0]  bits_counter     = 0;
 reg        reg_valid        = 0;
 reg        reg_parity       = 0;
 reg        reg_parity_error = 0;
 reg [7:0]  reg_RX_byte      = 0;
 reg [2:0]  state            = 0;
 
 parameter IDLE              = 3'b000, //The states of our machine
           START_BIT         = 3'b001,
           DATA_BITS         = 3'b010,
           PARITY_BIT        = 3'b011,
           STOP_BIT          = 3'b100;
 parameter POSEDGES_FOR_BIT  = CLK_RATE/BR;

 assign valid        = reg_valid;
 assign parity_error = reg_parity_error;
 assign RX_Byte      = reg_RX_byte;
		   
 always @ (posedge clk, posedge reset)		
  begin
  
    if (reset)
     begin
      clk_counter       <= 0;
      bits_counter      <= 0;
      reg_parity_error  <= 0;
      reg_valid         <= 0;
      reg_RX_byte       <= 0;
      state             <= IDLE;
     end
	
    else
     begin
	     
       case(state)
	  
	    IDLE: 
	         begin
		   clk_counter        <= 0; 
		   bits_counter       <= 0;
		   reg_parity_error   <= 0;
		   reg_valid          <= 0;
		   if (serial_in == 0)
		     state <= START_BIT;
		   else 
		     state <= IDLE;
		 end
		 
	   START_BIT: 
		     begin
		       if (clk_counter >= (POSEDGES_FOR_BIT-1)/2) //We wait until the bit is stable (in the middle of the bit)
			 if (serial_in == 0)
			  begin
		           clk_counter <= 0;
			   state       <= DATA_BITS;
			  end 
			 else
			   state <= IDLE;
		      else  
                        clk_counter <= clk_counter + 1; 
                     end	

           DATA_BITS:
 	       	     begin
		       if (clk_counter >= POSEDGES_FOR_BIT-1) //Sampling every bit when it's stable (in the middle of the bit)
		        begin
		         reg_RX_byte    <= {serial_in , reg_RX_byte[7:1]}; //Shift register implementation
			 reg_parity     <= reg_parity ^ serial_in; //Calculate the even parity bit
			 bits_counter   = bits_counter + 1; 
			 clk_counter    <= 0;
			 if (bits_counter == 8)
		          state <= PARITY_BIT;
		        end
		      else
		       clk_counter <= clk_counter + 1;
		     end	
		 
	  PARITY_BIT:
		     begin
		       if (clk_counter >= POSEDGES_FOR_BIT-1)
		        if (serial_in == reg_parity) //Compare the actually and the calculate even parity bit
		         begin
			  state       <= STOP_BIT;
			  clk_counter <= 0;
			 end
		        else
		         begin
		          reg_parity_error <= 1;
		          state            <= IDLE;
		         end
		       else
                        clk_counter <= clk_counter + 1;		   
		     end	   
			   
	 STOP_BIT: 
		  begin
		    if (clk_counter >= POSEDGES_FOR_BIT-1)
		      if (serial_in == 1) //Check if the stop bit is actually '1'
		       begin
		        state     <= IDLE;
		        reg_valid <= 1; //Valid bit is high for 1 clock cycle
		       end
		      else
                       state <= IDLE;			 
                    else
                      clk_counter <= clk_counter + 1;
	          end 
		  
        default: 
		  state = IDLE;
      endcase 
    end
  end
endmodule
