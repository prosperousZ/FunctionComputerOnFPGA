/**
 * Author: Kyle Lemmon
 */
module vga_controller(input clk,
	input rst,
	output vga_clk, vga_blank_n, hsync, vsync, bright,
	output [9:0] x,
	output [8:0] y);

	integer hcount=0,vcount=0,counter=0;

always @(posedge clk) begin
	if(counter & 1'b1) begin
		hcount <= hcount + 1;
	end
	if(hcount >= 800) begin
		hcount <= 0;
		vcount <= vcount + 1;
	end
	if(vcount >= 525) begin
		vcount <= 0;
	end
	counter <= counter + 1;
end
assign vga_clk = counter&1'b1;
assign hsync = hcount >= 96;
assign vsync = vcount >= 2;

assign x = hcount - 144;
assign y = vcount - 35;

assign bright = hcount >= 144 && hcount < 784 && vcount > 35 && vcount < 515; 
assign vga_blank_n = hcount >= 144 && hcount < 784 && vcount > 35 && vcount < 515;

endmodule