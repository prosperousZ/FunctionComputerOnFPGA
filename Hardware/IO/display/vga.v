/**
 * Author: Kyle Lemmon
 */
module vga(input clk,
	input rst, we_proc,
	input [15:0] addr_proc,wd_proc,
	output vga_clk, vga_blank_n, hsync, vsync, 
	output [7:0] r, g, b,
	output [15:0] rd_proc);
wire bright;
wire [9:0] x;
wire [8:0] y;
wire [15:0] rd_vga; 

vga_controller vcont(clk, rst, vga_clk, vga_blank_n, hsync, vsync, bright,x,y);
glyph_memory memory(addr_proc[12:0],(y>>3)*80+(x>>3),clk,rst,we_proc,wd_proc,rd_proc,rd_vga);
vga_bitgen bitgen(bright,clk,rd_vga,x,y,r,g,b);

endmodule