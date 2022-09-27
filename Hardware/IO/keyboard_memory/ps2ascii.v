/*
 * A look-up table for ps2 codes to ascii. If a character isn't implemented, expect to receive 0xF0.
 * If I missed a character and it outputs 0xF1, expect that to be changed to an ascii equivalent.
 * I'll make a table to show what maps to what.
 */
module ps2ascii(en, shift, extend, byte_ps2, byte_ascii);
	input en, shift, extend;
	input [7:0] byte_ps2;
	output reg [7:0] byte_ascii;
	
	always@(*) begin
		
		byte_ascii = 8'h00;
		if(en) begin
		
			// INPUT NOT IMPLEMENTED = 0xFF
			// INPUT NEEDS REPLACEMENT = 0xF1
			// Extended keys, there isn't a shift for them.
			if(extend) begin
				case(byte_ps2)
					// L GUI
					8'h1F: byte_ascii = 8'h06; // L GUI (Windows) (acknowledge)
					8'h27: byte_ascii = 8'h06; // R GUI (Windows)
					
					8'h11: byte_ascii = 8'h04; // R ALT (end of transmission)
					
					8'h2F: byte_ascii = 8'h07; // APPS (bell)
					
					8'h14: byte_ascii = 8'h05; // R CTRL (enquiry)
					
					8'h70: byte_ascii = 8'h0B; // INSERT (vertical tab)
					
					
					8'h7D: byte_ascii = 8'h1E; // PG UP (corresponds to charset.png upper triangle)
					8'h7A: byte_ascii = 8'h1F; // PG DN (corresponds to charset.png lower triangle)
					8'h6C: byte_ascii = 8'h11; // HOME  (corresponds to charset.png left  traingle)
					8'h69: byte_ascii = 8'h10; // END   (corresponds to charset.png right triangle)
					
					
					8'h71: byte_ascii = 8'h7F; // DELETE
					
					
					8'h75: byte_ascii = 8'h18; // UP    (corresponds to charset.png arrow up)
					8'h72: byte_ascii = 8'h19; // DOWN  (corresponds to charset.png arrow down)
					8'h74: byte_ascii = 8'h1A; // RIGHT (corresponds to charset.png arrow right)
					8'h6B: byte_ascii = 8'h1B; // LEFT  (corresponds to charset.png arrow left)
	
	
					
					
					8'h5A: byte_ascii = 8'h0A; // KP EN
					8'h4A: byte_ascii = 8'h3F; // KP /
					
					default: byte_ascii = 8'hFF;
				endcase
			end
			
			else if(shift) begin
				case(byte_ps2)
					8'h1C: byte_ascii = 8'h41; // A
					8'h32: byte_ascii = 8'h42; // B
					8'h21: byte_ascii = 8'h43; // C
					8'h23: byte_ascii = 8'h44; // D
					8'h24: byte_ascii = 8'h45; // E
					8'h2B: byte_ascii = 8'h46; // F
					8'h34: byte_ascii = 8'h47; // G
					8'h33: byte_ascii = 8'h48; // H
					8'h43: byte_ascii = 8'h49; // I
					8'h3B: byte_ascii = 8'h4A; // J
					8'h42: byte_ascii = 8'h4B; // K
					8'h4B: byte_ascii = 8'h4C; // L
					8'h3A: byte_ascii = 8'h4D; // M
					8'h31: byte_ascii = 8'h4E; // N
					8'h44: byte_ascii = 8'h4F; // O
					8'h4D: byte_ascii = 8'h50; // P
					8'h15: byte_ascii = 8'h51; // Q
					8'h2D: byte_ascii = 8'h52; // R
					8'h1B: byte_ascii = 8'h53; // S
					8'h2C: byte_ascii = 8'h54; // T
					8'h3C: byte_ascii = 8'h55; // U
					8'h2A: byte_ascii = 8'h56; // V
					8'h1D: byte_ascii = 8'h57; // W
					8'h22: byte_ascii = 8'h58; // X
					8'h35: byte_ascii = 8'h59; // Y
					8'h1A: byte_ascii = 8'h5A; // Z
					
					8'h45: byte_ascii = 8'h29; // 0 ())
					8'h16: byte_ascii = 8'h21; // 1 (!)
					8'h1E: byte_ascii = 8'h40; // 2 (@)
					8'h26: byte_ascii = 8'h23; // 3 (#)
					8'h25: byte_ascii = 8'h24; // 4 ($)
					8'h2E: byte_ascii = 8'h25; // 5 (%)
					8'h36: byte_ascii = 8'h5E; // 6 (^)
					8'h3D: byte_ascii = 8'h26; // 7 (&)
					8'h3E: byte_ascii = 8'h2A; // 8 (*)
					8'h46: byte_ascii = 8'h28; // 9 (()
					
					8'h0E: byte_ascii = 8'h7E; // ` (~)
					8'h4E: byte_ascii = 8'h5F; // - (_)
					8'h55: byte_ascii = 8'h2B; // = (+)
					
					8'h5D: byte_ascii = 8'h7C; // \ (|)
					8'h4C: byte_ascii = 8'h3A; // ; (:)
					8'h52: byte_ascii = 8'h34; // ' (")
					8'h54: byte_ascii = 8'h7B; // [ ({)
					8'h5B: byte_ascii = 8'h7D; // ] (})
					8'h41: byte_ascii = 8'h3C; // , (<)
					8'h49: byte_ascii = 8'h3E; // . (>)
					8'h4A: byte_ascii = 8'h3F; // / (?)
					
					
					8'h7C: byte_ascii = 8'h2A; // KP *
					8'h7B: byte_ascii = 8'h2D; // KP -
					8'h79: byte_ascii = 8'h2B; // KP +
					8'h71: byte_ascii = 8'h2E; // KP .
					
					8'h70: byte_ascii = 8'h30; // KP 0
					8'h69: byte_ascii = 8'h31; // KP 1
					8'h72: byte_ascii = 8'h32; // KP 2
					8'h7A: byte_ascii = 8'h33; // KP 3
					8'h6B: byte_ascii = 8'h34; // KP 4
					8'h73: byte_ascii = 8'h35; // KP 5
					8'h74: byte_ascii = 8'h36; // KP 6
					8'h6C: byte_ascii = 8'h37; // KP 7
					8'h75: byte_ascii = 8'h38; // KP 8
					8'h7D: byte_ascii = 8'h39; // KP 9
					
					
					8'h66: byte_ascii = 8'h08; // Backspace
					8'h29: byte_ascii = 8'h20; // Space
					8'h0D: byte_ascii = 8'h09; // TAB
					
					8'h12: byte_ascii = 8'h0F; // L Shift -> Shift in
					8'h59: byte_ascii = 8'h0F; // R Shift -> shift in
					
					8'h11: byte_ascii = 8'h04; // L ALT (end of transmission)
				
					8'h14: byte_ascii = 8'h05; // L CTRL (enquiry)
					
					8'h58: byte_ascii = 8'h01; // CAPS (Start of heading)
					8'h7E: byte_ascii = 8'h02; // SCROLL (start of text)
					8'h77: byte_ascii = 8'h03; // NUM (end of text)
					
					
					8'h5A: byte_ascii = 8'h0A; // ENTER 
					8'h76: byte_ascii = 8'h1B; // ESC
					
					/* F1 TO F12 */
					// The first half of ascii ends at 7F
					8'h05: byte_ascii = 8'h80; // F1
					8'h06: byte_ascii = 8'h81; // F2
					8'h04: byte_ascii = 8'h82; // F3
					8'h0C: byte_ascii = 8'h83; // F4
					8'h03: byte_ascii = 8'h84; // F5
					8'h0B: byte_ascii = 8'h85; // F6
					8'h83: byte_ascii = 8'h86; // F7
					8'h0A: byte_ascii = 8'h87; // F8
					8'h01: byte_ascii = 8'h88; // F9
					8'h09: byte_ascii = 8'h89; // F10
					8'h78: byte_ascii = 8'h8A; // F11
					8'h07: byte_ascii = 8'h8B; // F12
					
					8'hE0: byte_ascii = 8'hE0; // To help indicate if extended keys are being used.
					8'hF0: byte_ascii = 8'hF0; // To help indicate if a button is being released.
					
					
					
					default: byte_ascii = 8'hFF;
				endcase
			end
			
			else begin
				// Unshifted, not extended keys.
				case(byte_ps2)
					8'h1C: byte_ascii = 8'h61; // a
					8'h32: byte_ascii = 8'h62; // b
					8'h21: byte_ascii = 8'h63; // c
					8'h23: byte_ascii = 8'h64; // d
					8'h24: byte_ascii = 8'h65; // e
					8'h2B: byte_ascii = 8'h66; // f
					8'h34: byte_ascii = 8'h67; // g
					8'h33: byte_ascii = 8'h68; // h
					8'h43: byte_ascii = 8'h69; // i
					8'h3B: byte_ascii = 8'h6A; // j
					8'h42: byte_ascii = 8'h6B; // k
					8'h4B: byte_ascii = 8'h6C; // l
					8'h3A: byte_ascii = 8'h6D; // m
					8'h31: byte_ascii = 8'h6E; // n
					8'h44: byte_ascii = 8'h6F; // o
					8'h4D: byte_ascii = 8'h70; // p
					8'h15: byte_ascii = 8'h71; // q
					8'h2D: byte_ascii = 8'h72; // r
					8'h1B: byte_ascii = 8'h73; // s
					8'h2C: byte_ascii = 8'h74; // t
					8'h3C: byte_ascii = 8'h75; // u
					8'h2A: byte_ascii = 8'h76; // v
					8'h1D: byte_ascii = 8'h77; // w
					8'h22: byte_ascii = 8'h78; // x
					8'h35: byte_ascii = 8'h79; // y
					8'h1A: byte_ascii = 8'h7A; // z
					
					8'h45: byte_ascii = 8'h30; // 0
					8'h16: byte_ascii = 8'h31; // 1
					8'h1E: byte_ascii = 8'h32; // 2
					8'h26: byte_ascii = 8'h33; // 3
					8'h25: byte_ascii = 8'h34; // 4
					8'h2E: byte_ascii = 8'h35; // 5
					8'h36: byte_ascii = 8'h36; // 6
					8'h3D: byte_ascii = 8'h37; // 7
					8'h3E: byte_ascii = 8'h38; // 8
					8'h46: byte_ascii = 8'h39; // 9
					
					8'h0E: byte_ascii = 8'h60; // `
					8'h4E: byte_ascii = 8'h2D; // -
					8'h55: byte_ascii = 8'h3D; // =
					8'h5D: byte_ascii = 8'h5C; // \
					8'h4C: byte_ascii = 8'h3B; // ;
					8'h52: byte_ascii = 8'h27; // '	
					8'h54: byte_ascii = 8'h5B; // [
					8'h5B: byte_ascii = 8'h5D; // ]
					8'h41: byte_ascii = 8'h2C; // ,
					8'h49: byte_ascii = 8'h2E; // .
					8'h4A: byte_ascii = 8'h2F; // /
					
					8'h7C: byte_ascii = 8'h2A; // KP *
					8'h7B: byte_ascii = 8'h2D; // KP -
					8'h79: byte_ascii = 8'h2B; // KP +
					8'h71: byte_ascii = 8'h2E; // KP .
					
					8'h70: byte_ascii = 8'h30; // KP 0
					8'h69: byte_ascii = 8'h31; // KP 1
					8'h72: byte_ascii = 8'h32; // KP 2
					8'h7A: byte_ascii = 8'h33; // KP 3
					8'h6B: byte_ascii = 8'h34; // KP 4
					8'h73: byte_ascii = 8'h35; // KP 5
					8'h74: byte_ascii = 8'h36; // KP 6
					8'h6C: byte_ascii = 8'h37; // KP 7
					8'h75: byte_ascii = 8'h38; // KP 8
					8'h7D: byte_ascii = 8'h39; // KP 9
					
					8'h66: byte_ascii = 8'h08; // Backspace
					8'h29: byte_ascii = 8'h20; // Space
					8'h0D: byte_ascii = 8'h09; // TAB
					
					8'h12: byte_ascii = 8'h0F; // L Shift -> Shift in
					8'h59: byte_ascii = 8'h0F; // R Shift -> shift in
					
					8'h11: byte_ascii = 8'h04; // L ALT (end of transmission)
				
					8'h14: byte_ascii = 8'h05; // L CTRL (enquiry)
					
					8'h58: byte_ascii = 8'h01; // CAPS (Start of heading)
					8'h7E: byte_ascii = 8'h02; // SCROLL (start of text)
					8'h77: byte_ascii = 8'h03; // NUM (end of text)
					
					
					8'h5A: byte_ascii = 8'h0A; // ENTER 
					8'h76: byte_ascii = 8'h1B; // ESC
					
					/* F1 TO F12 */
					// The first half of ascii ends at 7F
					8'h05: byte_ascii = 8'h80; // F1
					8'h06: byte_ascii = 8'h81; // F2
					8'h04: byte_ascii = 8'h82; // F3
					8'h0C: byte_ascii = 8'h83; // F4
					8'h03: byte_ascii = 8'h84; // F5
					8'h0B: byte_ascii = 8'h85; // F6
					8'h83: byte_ascii = 8'h86; // F7
					8'h0A: byte_ascii = 8'h87; // F8
					8'h01: byte_ascii = 8'h88; // F9
					8'h09: byte_ascii = 8'h89; // F10
					8'h78: byte_ascii = 8'h8A; // F11
					8'h07: byte_ascii = 8'h8B; // F12
					
					8'hE0: byte_ascii = 8'hE0; // To help indicate if extended keys are being used.
					8'hF0: byte_ascii = 8'hF0; // To help indicate if a button is being released.
					
					
					default: byte_ascii = 8'hFF;
				endcase
			end
		end
	end

endmodule
