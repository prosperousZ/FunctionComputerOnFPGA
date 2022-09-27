`timescale 1ns/1ps
/*
 * Simple testbench, just to see if data is received.
 *
 */
module ps2_in_tb;
	reg clk, rst;
	reg wait_for_data, start_receiving_data;
	reg ps2_clk, ps2_data;
	
	wire [7:0] byte_data;
	wire full_byte_received;
	integer i;
	
	reg [0:10] byte_command;
	
	ps2_in UUT(clk, rst, wait_for_data, start_receiving_data, ps2_clk, ps2_data, byte_data, full_byte_received);
	
	initial begin
		clk = 1'b0;
		rst = 1'b0;
		wait_for_data = 1'b0;
		start_receiving_data = 1'b0;
		ps2_clk = 1'b0;
		ps2_data = 1'b0;
		i = 0;
		
		byte_command = 11'b0_01011010_11; // Send 0x5A to keyboard
		
		#10;
		
		rst = 1'b1;
		ps2_clk = 1'b1; // By default, ps2_clk and ps2_data will be tied high.
		ps2_data = 1'b1;
		
		#10;
		
		rst = 1'b0;
		
		#10;
		
		wait_for_data = 1'b1; // Go to wait state
		
		#1000;
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		
		byte_command = 11'b0_00001111_11; // Send 0xF0 to keyboard
		
		#1000;
		
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		
		byte_command = 11'b0_01011010_11; // Send 0x5A to keyboard
		#1000;
		
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		
		#1000;
	
		
		$stop;
		
	end
	
	
	always 
		#5 clk = !clk;
	
	always
		#50 ps2_clk = !ps2_clk;
	
	
endmodule
