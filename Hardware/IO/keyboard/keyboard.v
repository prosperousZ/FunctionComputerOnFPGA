/*
 * Initial keyboard interface. It displays to the LEDs the last button released.
 * This is not used, please disregard it.
 *
 */
module keyboard(clk, data, button);
  input clk;
  input data;
  output reg [7:0] button;

  reg [7:0] current_data;
  reg [7:0] prev_data;
  reg [3:0] data_bit;
  reg flag;
  
  initial begin
    data_bit <= 4'h1;
	 flag <=1'b0;
	 current_data <= 8'hf0;
	 prev_data <= 8'hf0;
	 button <= 8'ha0;
  end
					 
  always @(negedge clk) begin
    case(data_bit)
	  1:; // Start bit, isn't used.
	  2:current_data[0] <= data;
	  3:current_data[1] <= data;
	  4:current_data[2] <= data;
	  5:current_data[3] <= data;
	  6:current_data[4] <= data;
     7:current_data[5] <= data;
	  8:current_data[6] <= data;
	  9:current_data[7] <= data;
	  10:flag <= 1'b1; // Should be 1, polarity bit.
	  11:flag <= 1'b0; // Should be 0, ending bit.
	  default:data_bit <=1; // Shouldn't happen.
	 endcase
    
	 // Increment the data_bit while the last bit hasn't been received.
	 if (data_bit < 11)
	   data_bit <= data_bit + 1'b1;
	 else if(data_bit == 11) // Last bit received, reset which bit is currently being received.
	   data_bit <= 1'b1;
  
  end
  
  // Whenever flag changes, that mean the last two bits have arrived, once the button is released,
  // f0, and then the key code for the button is transmitted from the keyboard.
  // This currently doesn't work with buttons that have multiple bytes transmitted like Home, Delete, and the arrow keys.
  always@(posedge flag) begin
    if(current_data == 8'hf0)
	   button <= prev_data;
	 else
	   prev_data <= current_data;
  end
					 
endmodule



