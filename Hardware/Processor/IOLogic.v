//Author: prim: Yuntong Lu		Second: Haoze Zhang
//*********************************************************
 module IOLogic(addr, we, IO_w_en, A, B, Y);
//*********************************************************

 input [15:0] addr, A, B;
 input we;
 output reg [15:0] Y;
 output reg IO_w_en;

 always @(*) begin
	if (addr[15:14] == 2'b11) begin
		Y <= B;
		IO_w_en <= we;
	end else begin
		Y <= A;
		IO_w_en <= 0;
	end
 
 end

 endmodule