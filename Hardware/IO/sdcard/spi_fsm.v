module spi_fsm(
	input [47:0] cmd,
	input clk,send_cmd,rst,miso,sdck_in,recv_trans_complete,
	output sck,
	output reg ss,mosi,recv_byte_complete
	);

parameter 	CONF = 0,
				IDLE = 1,
				SPRE = 2,
				SEND = 3,
				RPRE = 5,
				RECV = 6;
parameter 	MOSI_HI = 0,
				MOSI_LO = 1,
				MOSI_DAT = 2;
reg [1:0] mosi_state;
reg [7:0] recv_byte;
reg [2:0] NS,PS,precon_count;
reg [6:0] conf_count, trans_count,recv_count;
reg conf_done, precon_count_en, precon_done,sck_en,trans_done, recv_en;


initial begin
	conf_count = 0;
	conf_done = 0;
	precon_count_en = 0;
	precon_count = 0;
	precon_done = 0;
	trans_count = 0;
	recv_en = 0;
	recv_byte = 0;
	recv_count = 0;
	sck_en=1;
	recv_byte_complete = 1;
	NS = CONF;
	PS = CONF;
	mosi = 1;
	trans_done = 0;
end

always @(negedge sdck_in) begin
	if(rst)begin
		mosi = 1;
		trans_count = 0;
		trans_done = 0;
		recv_byte_complete = 1;
		recv_count = 0;
	end else begin
		case(mosi_state)
			MOSI_HI: begin
				mosi = 1;
				trans_done = 0;
			end
			MOSI_LO: begin
				mosi = 0;
				trans_done = 0;
			end
			MOSI_DAT: begin
				trans_count = trans_count + 1;
				mosi = cmd[48-trans_count];
				if(trans_count == 48) begin
					trans_count = 0;
					trans_done = 1;
				end
			end
			endcase
		
		if(recv_en) begin
			if(recv_count == 7)begin
				recv_byte_complete = 0;
				recv_count = 0;
			end else begin
				if(recv_count == 0)
					recv_byte_complete = 1;
				else
					recv_byte_complete = 0;
				recv_count = recv_count + 1;
			end
		end
	end
end

always @(posedge sdck_in) begin
	if(rst) begin
		conf_done = 0;
		conf_count = 0;
		precon_count = 0;
		precon_done = 0;
		recv_byte = 0;
	end else begin
		//Put sd card into SPI mode 
		if(conf_count >= 74)
			conf_done = 1;
		else
			conf_count = conf_count + 1;
			
		if(precon_count_en) begin
			if(precon_count == 7)
				precon_done = 1;
			else
				precon_count = precon_count + 1;
		end else begin
			precon_count = 0;
			precon_done = 0;
		end
		
		if(recv_en) begin
			recv_byte[recv_count] = miso;
		end
	end
end


always @(clk) begin 
	if(rst) PS = CONF;
	PS=NS;
end

always @(*) begin
	if(rst) begin 
		NS = CONF;
		mosi_state = MOSI_HI;
		ss = 1;
		sck_en = 0;
		precon_count_en = 0;
		recv_en = 0;
		
	end else begin
		case (PS) 
			CONF: begin
				if(conf_done)
					NS = IDLE;
				else
					NS = CONF;
				mosi_state = MOSI_HI;
				ss = 1;
				sck_en = 1;
				precon_count_en = 0;
				recv_en = 0;
			end
			IDLE: begin
				if(send_cmd)
					NS = SPRE;
				else
					NS = IDLE;
				sck_en = 0;
				ss = 1;
				mosi_state = MOSI_HI;
				precon_count_en = 0;
				recv_en = 0;
			end
			SPRE: begin
				precon_count_en = 1;
				if(precon_done)
					NS = SEND;
				else
					NS = SPRE;
				ss = 0;
				mosi_state = MOSI_HI;
				sck_en = 1;
				recv_en = 0;
			end
			SEND: begin
				precon_count_en = 0;
				if(trans_done)
					NS = RPRE;
				else
					NS = SEND;
				mosi_state = MOSI_DAT;
				ss = 0;
				sck_en = 1;
				recv_en = 0;
			end
			RPRE: begin
				if(miso)
					NS = RPRE;
				else
					NS = RECV;
				sck_en = 1;
				mosi_state = MOSI_HI;
				ss = 0;
				precon_count_en = 0;
				recv_en = 0;
			end
			RECV: begin
				recv_en = 1;
				if(recv_trans_complete)
					NS = IDLE;
				else
					NS = RECV;
				mosi_state = MOSI_HI;
				ss = 0;
				sck_en = 1;
				precon_count_en = 0;
			end
		endcase
	end
end
	
assign sck = (sck_en) ? sdck_in : 0;

endmodule