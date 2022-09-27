`timescale 1ns/1ps

module ps2ascii_tb;
	reg  [7:0] byte_ps2;
	reg shift;
	reg extend;
	wire [7:0] byte_ascii;
	
	integer i;
	
	ps2ascii UUT (shift, extend, byte_ps2, byte_ascii);
	
	initial begin
	
		//en = 1'b1;
		extend = 1'b0;
		shift = 1'b0;
	
		byte_ps2 = 8'b0;
		
		for(i = 0; i < 512; i = i + 1) begin
		
			{byte_ps2, extend, shift} = i;
			
			#10
			if(byte_ascii != 8'hFF) begin
				if(byte_ascii == 8'hF1)
					$display("ps2: %H needs a proper ascii position!", byte_ps2);
				else
					$display("ps2: %H \t shift: %b \t ascii: %H (%C)", byte_ps2, shift, byte_ascii, byte_ascii);
				
			end
		end
	
	end

endmodule
