/* 
 * ECE 3710
 * Fall 2019
 * Lab 01
 * Group 10_34: Kyle Lemmon and Colton Watson
 * September 5, 2019
 *
 * This is a simple Thunderbird turn signal state machine.
 * Given inputs, a sequence of LEDS will light up in a particular fashion.
 * If this input is to assert the left turn signal, the lights on the left side
 * of the car (board) will light up from the innermost light to the outermost light.
 * The input for the right turn signal is exactly the same as the left, but the lights
 * on the right side will light up from the innermost light to the outermost light.
 *
 * Once the hazard signal is asserted, all of the lights will flash on and off, 
 * regardless of what state they were in before.
 * 
 */
module tbird(LEFT,RIGHT,HAZ,clk,resetn,L,R);
	input LEFT,RIGHT,HAZ,clk, resetn;
	output reg [2:0] L,R;
	
	// State variables.
	reg [2:0] PS, NS;
	reg [31:0] count;
	
	parameter [2:0] DF = 3'b000;
	parameter [2:0] L0 = 3'b001;
	parameter [2:0] L1 = 3'b010;
	parameter [2:0] L2 = 3'b011;
	parameter [2:0] R0 = 3'b100;
	parameter [2:0] R1 = 3'b101;
	parameter [2:0] R2 = 3'b110;
	parameter [2:0] HZ = 3'b111;
	
	// Divide the clock. 50 MHz is too fast for human eyes.
	wire enable;
	clken enable_signal (.clk(clk), .resetn(resetn), .en(enable));
	
	// Sequential Logic
	always @(negedge clk, negedge resetn) begin
		if(resetn == 0) PS <= DF;
		else if(enable) PS <= NS;		
	end
	
	// Combinatinal Logic
	always @(*) begin
		NS = 3'b000;
		L  = 3'b000;
		R  = 3'b000;	
		
		case (PS)
			DF:begin // The default state. All lights are off.			
				if(HAZ)			NS = HZ;
				else if(LEFT)	NS = L0;
				else if(RIGHT)	NS = R0;
				
				end
			
			L0:begin // Only the first left light will be on.
				L = 3'b001;
				R = 3'b000;
				
				if(HAZ)  		NS = HZ;
				else  			NS = L1;
				
				end
				
			L1:begin // The first two left lights will be on.
				L = 3'b011;
				R = 3'b000;
				
				if(HAZ)			NS = HZ;
				else				NS = L2;
				
				end
				
			L2:begin	// All three left lights will be on.			
				L = 3'b111;
				R = 3'b000;
				
				if(HAZ)   		NS = HZ;
				else				NS = DF;
				
				end
				
			R0:begin	// Only the first right light will be on.		
				L = 3'b000;
				R = 3'b001;
				
				if(HAZ) 			NS = HZ;
				else				NS = R1;
				
				end
				
			R1:begin	// The first two right lights will be on.			
				L = 3'b000;
				R = 3'b011;
				
				if(HAZ)			NS = HZ;
				else				NS = R2;
				
				end
				
			R2:begin	// All three right lights will be on.			
				L = 3'b000;
				R = 3'b111;

				if(HAZ)			NS = HZ;
				else				NS = DF;
				end
				
			HZ:begin // Hazard. All lights go on.
				L = 3'b111;
				R = 3'b111;			
				
            // Go back to the default state, resetting the lights. If the hazard signal is still high,
				// The lights will turn on again, giving the flashing.
				NS = DF; 
				end
				
		   default: NS = DF; // Should not happen, go to the default state.
			endcase			
	end
endmodule
