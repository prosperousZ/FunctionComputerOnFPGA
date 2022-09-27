module spi_tb();
reg clk,send_cmd,miso,recv_trans_complete;
initial begin
	clk = 0;
	send_cmd = 0;
	miso = 1;
	recv_trans_complete = 0;
end
spi myspi(
	clk,0,miso,send_cmd,recv_trans_complete,
	sck,ss,mosi,recv_byte_complete
	);

always # 100000 send_cmd = 1;
always # 300000 miso = 0;
always # 500000 recv_trans_complete = 1;
always #1 clk=~clk;

endmodule
