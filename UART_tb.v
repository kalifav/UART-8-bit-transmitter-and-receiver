//TB for the UART_TOP model

`timescale 1ns/1ps

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
    $display("\t\ttime,\treset,\tdata_out,\tvalid,\tTX_active"); 
    $monitor("%t,   \t%b,   \t%b,   \t%b,    \t%d",$time, reset, data_out, valid, TX_active);
   end 
	
		
 task trans_data(input [7:0] data);
  data_in = data;
 endtask

 initial
   trans_data($random);
   
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
     #15;
     reset <= 0;
    end	 
  end	
   
 initial 
  begin
   wait(valid)
   trans_data($random);
   #15;
   -> reset_trigger;
   #15;
   trans_data($random);
   wait(valid);
   #15
   $stop;
  end 
  
endmodule
