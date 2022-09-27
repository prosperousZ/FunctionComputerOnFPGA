module spi(
	input clk,rst,miso,send_cmd,recv_trans_complete,
	output sck,ss,mosi,recv_byte_complete
	);
	
wire sck_in;

reg [7:0] clk_count;

initial begin 
	clk_count = 0;
end

always @(posedge clk)
	clk_count = clk_count + 1;

assign sck_in = clk_count[7];
	
spi_fsm fsm(
	48'h400000000095,
	clk,~send_cmd,~rst,miso,sck_in,recv_trans_complete,
	sck,
	ss,mosi,recv_byte_complete
	);


endmodule