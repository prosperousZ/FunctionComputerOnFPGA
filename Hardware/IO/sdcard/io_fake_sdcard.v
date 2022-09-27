module io_fake_sdcard(
	input clk, rst, load_op, stor_op, we_proc,
	input [7:0] addr_proc,
	input [15:0] wd_proc, file_no, block_addr,
	output [15:0] io_q,
	output reg op_complete
);

reg [15:0] memory [0:131071];
reg [18:0] addr;

initial begin
	$readmemh("/home/klemmon/Desktop/Fall2019/CS3710/FinalProject/IO/sdcard/sd.mem",memory);
end


always @(posedge clk) begin
	if(we_proc) begin
		memory[addr] <= wd_proc;
	end
	op_complete <= load_op | stor_op;
	addr <= ((file_no | 19'h00000) << 13) | ((block_addr & 8'hFF) << 8) | (addr_proc & 8'hFF);
end

assign io_q = memory[addr];

endmodule 
