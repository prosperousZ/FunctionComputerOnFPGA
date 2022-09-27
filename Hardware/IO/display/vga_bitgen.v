/**
 * Author: Kyle Lemmon
 */
module vga_bitgen(input bright,clk,
	input [15:0] glyph, 
	input [9:0] x,
	input [8:0] y,
	output[7:0] r,g,b);

wire draw;

charset_rom chars(
	.clk(clk),
	.char(glyph[7:0]),
	.row(y[2:0]),
	.col(x[2:0]),
	.active(draw));

	
assign r = (bright && draw) ? glyph[13:12]<<6 : glyph[15:14]<<6;
assign g = (bright && draw) ? glyph[11:10]<<6 : glyph[15:14]<<6;
assign b = (bright && draw) ? glyph[9:8]<<6   : glyph[15:14]<<6;


/*
assign r = (draw && bright) ? glyph[13:12]<<2 : 8'hff;
assign g = (draw && bright) ? glyph[11:10]<<4 : 8'hff;
assign b = (draw && bright) ? glyph[9:8]<<6   : 8'hff;*/

endmodule