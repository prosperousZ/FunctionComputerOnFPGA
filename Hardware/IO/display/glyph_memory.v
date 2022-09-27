module glyph_memory(
	input [12:0] addr_proc,addr_vga,
	input clk,rst,we,
	input[15:0] wd_proc,
	output [15:0] rd_proc,
	output reg [15:0] rd_vga
);

reg [15:0] memory [4799:0];

reg [12:0] proc_addr;

initial begin
	$readmemh("/home/klemmon/Desktop/Fall2019/CS3710/FinalProject/IO/display/display.mem",memory);
end

always @(posedge clk) begin
	if (rst == 0) begin
		
	end
	if (we)
		memory[addr_proc] = wd_proc;
	proc_addr <= addr_proc;
	rd_vga <= memory[addr_vga];
end

assign rd_proc = memory[proc_addr];

endmodule