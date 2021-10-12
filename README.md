# UART 8-bit transmitter and receiver
**This is an implementation of an 8-bit UART communucation protocol - Transmitter and Receiver in Verilog HDL (RTL design).**

UART (Universal Asynchronous Transmitter Receiver), is an asynchronous and maybe the most common protocols used for full-duplex serial communication.
It is a cheap solution that requires a single wire for transmitting the data and another wire for receiving.
This UART communication design includes a start bit ‘0’, 8-bit of data, even parity bit and a stop bit.
The transmitter sends a single bit at a time, the receiver sample the bits one after the another when the bits are stable and finally send the data in parallel.

The baud rate (frequency of UART) is different from one device to another, likewise the clock-rate of each device, so in the code they are adjustable (the defaults are baud rate of 9600bps and clock rate of 50MHz).

Finally, there is a test bench code, there the transmitter and the receiver where tested together. 


