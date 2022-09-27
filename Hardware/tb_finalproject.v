`timescale 1ns / 1ps
module tb_finalproject();

	reg clk;
	reg rst;
	reg ps2_clk;
	reg ps2_data;
	wire [7:0] vga_r, vga_g, vga_b;
	
	integer i;
	
	reg [0:10] byte_command;
	

	initial begin
		clk = 1'b0;
		rst = 1'b0;
		
		
		ps2_clk = 1'b0;
		ps2_data = 1'b0;
		i = 0;	
		
		/* --- SEND a single button --- */
		
		
		byte_command = 11'b0_01011010_11; // Send 0x5A to keyboard
		
		#10;
		
		rst = 1'b1;
		ps2_clk = 1'b1;
		ps2_data = 1'b1;
		
		#10;
		
		rst = 1'b0;
		
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
		
		byte_command = 11'b0_01011010_11; // Send 0x5A (Enter) to keyboard
		#1000;
		
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		

		
		/* --- TEST SHIFT --- */
		
		
		byte_command = 11'b0_01001000_11; // Send 0x12 (L Shift) to keyboard
		#1000;
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		
		byte_command = 11'b0_00111000_01; // Send 0x1C (a) to keyboard, expecting mem[41] to be high.
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
		
		
		
		
		byte_command = 11'b0_00111000_01; // Send 0x1C (a) to keyboard, expecting mem[41] to be low.
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
		
		byte_command = 11'b0_01001000_11; // Send 0x12 (L Shift) to keyboard, shift should go low.
		#1000;
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		
		
		
		/* --- TEST an EXTEND --- */
		byte_command = 11'b0_00000111_01; // Send 0xE0 to keyboard.
		#1000;
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		
		
		byte_command = 11'b0_10101110_01; // Send 0x75 to keyboard (up arrow), mem[8'h18] should go high.
		#1000;
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		
		
		byte_command = 11'b0_00000111_01; // Send 0xE0 to keyboard.
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
		
		byte_command = 11'b0_10101110_01; // Send 0x75 to keyboard (up arrow), mem[8'h18] should go low.
		#1000;
		
		wait(ps2_clk == 1'b1);
		#25;
		for(i = 0; i < 11; i = i + 1) begin
			ps2_data = byte_command[i];
			wait(ps2_clk == 1'b0);
			#75;
			
		end
		#1000;
		
		#100000;
		$stop;
		
		
	end
	
	always
		#5 clk = !clk;
		
	always
		#51 ps2_clk = !ps2_clk;


FinalProject proj(clk,rst,ps2_clk,ps2_data,vga_r,cga_b,vga_b,vga_clk,vga_blank_n,hsync,vsync);

always #50 rst = 1;


endmodule 