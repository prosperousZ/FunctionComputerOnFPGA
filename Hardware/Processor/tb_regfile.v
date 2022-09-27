//Author: prim: Yuntong Lu		Second: Haoze Zhang
`timescale 1ns / 1ps
module tb_regfile;
parameter WIDTH = 16, REGBITS = 16;
reg  clk; 
reg  regwrite; 
reg  [REGBITS-1:0] ra1, ra2, wa; 
reg  [WIDTH-1:0]   wd; 
wire [WIDTH-1:0]   rd1, rd2;
integer i;

regfile ff (clk, regwrite, ra1, ra2, wa, wd, rd1, rd2);

initial begin
clk = 0;
regwrite = 0;
ra1 = 0;
ra2 = 0;
wa = 0;
for (i = 0; i < 60; i = i + 1) begin
clk = ~clk;
if (i < 30) begin
regwrite = 1;
wa = i;
wd = i;
end
else begin
regwrite = 0;
ra1 = i - 30;
ra2 = i - 30;
end

#5;
end


end


endmodule 