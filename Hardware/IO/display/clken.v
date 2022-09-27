/* 
 * ECE 3710
 * Fall 2019
 * Lab 01
 * Group 10_34: Kyle Lemmon and Colton Watson
 * September 5, 2019
 *
 * A simple clock divider. This is intended to make a 5 Hz clock from a 50 MHz clock.
 * It's been modified to act more as an enable, as specified in Lab 1's documentation.
 *
 */
module clken(clk, resetn, en);
	input clk, resetn;
	output reg en;
	reg[31:0] count = 32'b0;
	
	always@(posedge clk, negedge resetn) begin
		if(resetn == 1'b0) begin
			en <= 1'b0;
			count  <= 32'b0;
		end
		else begin
			if(count < 10000000) begin
				if(count == 0)
					en <= 1'b0;
				count <= count + 1;
			end else begin
				count <= 0;
				en <= 1'b1;
			end
		
		end
	end

	
	
endmodule
