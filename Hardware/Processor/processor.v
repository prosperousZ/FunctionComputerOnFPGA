//Author: prim: Yuntong Lu		Second: Haoze Zhang
module processor (clk, reset, Q, data, addr, IO_w_en);
// For the sd card io
// 1 bit: load, store
// 16 bit: rblock, roffset
// LDSD r0, r1

// For all other I/O
// 16 bit: memaddr, memrdata, memwdata

input clk, reset;
input [15:0] Q;
wire regwrite;
wire [3:0] wa, immLo, ra1, ra2;
wire [7:0] aluop, ld_pc_disp;
wire  we_a, LD_mux_en_a, pc_en, ld_pc_en,pc_mux, flag_en, wr_pc;
wire [15:0] q_a; 
wire [4:0] flags_out;
output [15:0] data, addr;
output IO_w_en;

dataPath DP(reset, clk, Q, data, addr, IO_w_en);


endmodule 