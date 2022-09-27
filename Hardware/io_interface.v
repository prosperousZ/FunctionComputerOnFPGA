module io_interface(
	input clk,rst,write_en,load_op,stor_op,ps2_clk,ps2_data,
	input [15:0] addr, wdata, regA, regB,
	output reg [15:0] rdata,
	output vga_clk,vga_blank_n, hsync, vsync, op_complete,
	output [7:0] r,g,b
);

reg vga_write_en, sdcard_write_en, kbd_reset_en;
wire [15:0] vga_data, sdcard_data;
wire keyboard_data;

always @(*) begin
	//VGA
	if( addr[15:13] == 3'b111 ) begin
		rdata <= vga_data;
		vga_write_en <= write_en;
		sdcard_write_en <= 0;
		kbd_reset_en <= 0;
	//Keyboard
	end else if( addr[15:12] == 4'b1101 ) begin
		rdata <= keyboard_data | 16'h0000;
		vga_write_en <= 0;
		sdcard_write_en <= 0;
		kbd_reset_en <= write_en;
	//SD Card
	end else if( addr[15:12] == 4'b1100 ) begin
		sdcard_write_en <= write_en;
		rdata <= sdcard_data;
		vga_write_en <= 0;
		kbd_reset_en <= 0;
		rdata <= 0;
	end else begin
		vga_write_en <= 0;
		rdata <= 0;
		sdcard_write_en <= 0;
		kbd_reset_en <= 0;
	end
end

vga display(clk, rst, vga_write_en, 
	addr,wdata,
	vga_clk, vga_blank_n, hsync, vsync, 
	r, g, b,vga_data);

io_fake_sdcard sdcard(
	clk, rst, load_op, stor_op, we_proc,
	(addr & 8'hFF),
	wdata, regA, regB,
	sdcard_data,
	op_complete
);

keyboard_memory keyboard(clk, rst, ps2_clk, ps2_data, addr, keyboard_data, kbd_reset_en);


endmodule 