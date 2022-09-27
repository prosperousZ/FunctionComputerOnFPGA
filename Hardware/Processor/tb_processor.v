//Author: prim: Yuntong Lu		Second: Haoze Zhang
`timescale 1ns / 1ps
module tb_processor;
reg clk;
reg reset;
integer i;

processor PP (clk, reset);

initial begin
clk = 0;
reset = 0;
clk = ~clk;
#15
clk = ~clk;
#15
clk = ~clk;
#15
clk = ~clk;
#15
clk = ~clk;
#15
clk = ~clk;
reset = 1;
for (i = 0; i < 300; i = i + 1) begin
#15
clk = ~clk;
end

end

endmodule 