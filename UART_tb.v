`timescale 1ps/1ps

module UART_tb;
  
 reg clk;
 reg reset;
 reg [7:0] data_in;
 reg transmit;
 wire TX_active;
 wire error;
 wire valid;
 wire [7:0] data_out;
 event reset_trigger;
 
 UART_TOP DUT (.clk(clk), .reset(reset), .data_in(data_in), .transmit(transmit), .error(error),
               .TX_active(TX_active), .valid(valid), .data_out(data_out));
			   
 initial 
   begin
       clk      <= 0;
	   reset    <= 0;
       transmit <= 0;
   #10 transmit <= 1;
   end 
   
 initial 
   begin
    $display("  \t\ttime,\treset,\tdata_out,\tvalid,\tTX_active"); 
    $monitor("%t,   \t%b,   \t%b,   \t%b,    \t%d",$time, reset, data_out, valid, TX_active);
   end 
			   
 initial
   data_in <= 8'b10101100;
   
 always
   #2 clk <= ~clk;
   
 initial 
  begin
   forever
    begin
     @(reset_trigger);
	 repeat(10)
      @(negedge clk);
	 reset <= 1;
	 #10
	 reset <= 0;
    end	 
  end	
   
 initial 
  begin
   wait(valid)
   #15;
   -> reset_trigger;
   #50;
   $stop;
  end 
  
endmodule
   
   
 
  