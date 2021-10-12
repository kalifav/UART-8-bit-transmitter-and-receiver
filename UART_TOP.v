module UART_TOP
#(parameter BR = 9600, 
            CLK_RATE = 50e6) //The clock-rate and Bound-rate (frequency of UART) 
(
 input         clk, reset, 
 input  [7:0]  data_in, //Data input byte
 input         transmit, //High for activation
 output        error, //High if there is an error in the transmission
 output        TX_active, //High if the transmitter is active
 output        valid, //Check if the whole data is available
 output [7:0]  data_out //The data we received
 );
 
 wire RX_serial_in;
 //Routing both receiver and transmitter toghether
 UART_TX   Transmitter (.clk(clk), .reset(reset), .TX_data_in(data_in), .transmit(transmit),
                      .TX_active(TX_active), .TX_serial_out_bit(RX_serial_in));
					  
 UART_RX   Receiver	 (.clk(clk), .reset(reset), .serial_in(RX_serial_in), .parity_error(error),
                      .valid(valid), .RX_Byte(data_out)); 
					  
endmodule					  
 
