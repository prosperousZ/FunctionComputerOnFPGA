`timescale 1ns / 1ps
module tb_dataPath;



reg clk, regwrite, Cin, reset;
reg [3:0] wa;
reg [7:0] aluop;
reg  we_a, we_b, LD_mux_en_a, LD_mux_en_b, pc_en, ld_pc_en,pc_mux; 
wire [3:0] ra1, ra2;
wire [15:0] wd, rd1, rd2;
wire [4:0] flags_alu;//flags for conditional jump 
wire [15:0] pc_counter,result, addr_a, addr_b;
wire [15:0] q_a, q_b;
  

dataPath	DP (reset, clk, regwrite, Cin, wa, aluop, we_a, 
	we_b, LD_mux_en_a, LD_mux_en_b, pc_en, ld_pc_en,pc_mux);

initial begin
clk = 0;
reset = 1;
Cin = 0;
wa = 0;
aluop = 0;
we_a = 0;
we_b = 0;
LD_mux_en_a = 0;
LD_mux_en_b = 0;
pc_en = 0;
ld_pc_en = 0;
pc_mux = 0;
#5

// test
clk = ~clk;
reset = 0;
Cin = 0;
wa = 0;
aluop = 8'b00000101;
we_a = 0;
we_b = 0;
LD_mux_en_a = 0;
LD_mux_en_b = 0;
pc_en = 1;
ld_pc_en = 0;
pc_mux = 1;
#5;

end

endmodule 