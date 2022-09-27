/*
 * Simple top level module for the PS/2 keyboard. If a button is pushed or
 * released, it is displayed on the LEDS. Note that some buttons like the 
 * arrow keys have two bytes for their make codes, meaning the LEDS should flash
 * 0xE0, and then the code. Also note that when a button is released, a break code
 * is sent, which is longer than the make code and typically involves the code 
 * 0xF0 followed by the code for the button that was released.
 *
 */
module ps2(clk, rst, ps2_clk, ps2_data, leds);
	input clk; // 50 MHz clock
	input rst; // Active low (button) reset
	
	input ps2_clk;
	input ps2_data;
	
	output [7:0] leds;
	
	wire new_byte_out;
	
	ps2_in keyboard_in (.clk(clk), .rst(~rst), .wait_for_data(1'b1), .start_receiving_data(1'b0), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .byte_data(leds), .full_byte_received(new_byte_out));
endmodule
