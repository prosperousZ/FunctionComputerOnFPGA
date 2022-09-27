//Author: prim: Yuntong Lu		Second: Haoze Zhang

module flags(input clk,
				 input reset, 
				 input [4:0] flags,
				 input flag_en, 
				 output reg [4:0] flags_out);

				 
always @(posedge clk)begin
		if(reset == 0)begin
				flags_out <= 0;
		end else begin
					if(flag_en)begin
						flags_out <= flags;
					end else begin
						flags_out <= flags_out;
					end
		end 
end 				 
endmodule