module keyboard_memory(clk, rst, ps2_clk, ps2_data, addr, is_pressed, reset_pressed);
	input clk, rst; // Active low reset (reset when (rst == 0))
	
	input ps2_clk, ps2_data, reset_pressed;
	
	input [7:0] addr;
	
	output reg is_pressed;
	
	// Each button pressed corresponds to a button in ascii, currently to check if the button 'a'
	// is pressed, check memory[8'h61]. To check if 'A' is pressed, check memory[8'h41].
	reg [255:0] memory;
	
	reg key_break;
	
	// Keyboard
	wire wait_for_data = 1'b1; // Currently we always want to wait for data.
	wire start_receiving_data = 1'b0; // Always wait for data.
	wire [7:0] byte_ps2;
	wire full_byte_received;
	
	ps2_in keyboard (clk, rst, wait_for_data, start_receiving_data, ps2_clk, ps2_data, byte_ps2, full_byte_received);
	
	// Lookup Table
	wire en;
	wire shift;
	reg extend;
	wire [7:0] byte_ascii;
	ps2ascii lookup (en, shift, extend, byte_ps2, byte_ascii);
	
	
	
	/* FSM */
	
	parameter idle = 1'b0;
	parameter decode = 1'b1;

	
	reg [7:0] next_state;
	reg [7:0] current_state;
	
	always @(posedge clk) begin
		if(rst == 0) current_state <= idle;
		else    current_state <= next_state;
	end
	
	
	always @(*) begin
		next_state = idle;
		
		case(current_state)
			idle: 
				begin
					extend = extend;
					key_break = key_break;
					
					if(full_byte_received) begin
						next_state = decode;
					end
					else begin
						next_state = idle;
					end
				end
			decode:
				begin
					next_state = idle;					
				end			
			default: 
				begin
					next_state = idle;
				end
		endcase
	end
	
	
	/* Sequential Logic */
	
	// Control extend
	always @(posedge clk) begin
		if (rst == 0) begin
			extend <= 1'b0;
		end
		
		if(current_state == decode) begin
			if(byte_ascii == 8'hE0)
				extend <= 1'b1;
			else if(byte_ascii != 8'hF0)
				extend <= 1'b0;			
			else
				extend <= extend;
		end
	end
	
	// Control shift, just treat it like  a regular button. There may be trouble if both shifts are held.
	assign shift = memory[8'h0F];
	
	
	// Control key_break
	always @(posedge clk) begin
		if(rst == 0) begin
			key_break <= 1'b0;
		end
		
		if(current_state == decode) begin
			if(byte_ascii == 8'hF0) 
				key_break <= 1'b1; 			
			else
				key_break <= 1'b0;
		end
		else begin
			key_break <= key_break;
		end
	end
	
	// Control memory
	always @(posedge clk) begin
		if(rst == 1'b0) begin
			memory <= 256'b0; 
		end
		
		if(current_state == decode) begin
			if(key_break || reset_pressed) begin
				memory[byte_ascii] <= 1'b0;
			end
			else begin
				memory[byte_ascii] <= 1'b1;
			end
		end
	end
	
	
	always @(posedge clk) begin
		if (rst == 0) begin
			is_pressed <= 1'b0;
		end		
		is_pressed <= reset_pressed ? 0:memory[addr[7:0]];		
	end
	
	// enable for lookup table.
	assign en = (current_state == decode);
	
	
	

endmodule
