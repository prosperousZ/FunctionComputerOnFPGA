module FinalProject(
	input clk,rst,ps2_clk,ps2_data,
	output [7:0] vga_r, vga_g, vga_b,
	output vga_clk, vga_blank_n, hsync,vsync
	); 
	wire [15:0] iomem_q,io_write_data,iomem_addr;
	wire IO_w_en, load_op, stor_op;
	processor proc(clk, rst, iomem_q, io_write_data, iomem_addr, IO_w_en);
	
	io_interface ioint(clk, rst, IO_w_en,load_op,stor_op,ps2_clk,ps2_data,
		iomem_addr,io_write_data,0,0,
		iomem_q,
		vga_clk,vga_blank_n, hsync, vsync,op_complete,vga_r,vga_g,vga_b);
endmodule 