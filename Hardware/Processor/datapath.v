`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuntong Lu, Haoze Zhang
// 
// Create Date:    15:24:24 09/17/2019 
// Design Name: 
// Module Name:    
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dataPath (reset, clk, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);

input clk, reset;
wire regwrite, flag_en;
wire [3:0] wa, immLo;
wire [7:0] aluop, ld_pc_disp;
wire  we_a, LD_mux_en_a, pc_en, ld_pc_en,pc_mux, wr_pc; 
wire [3:0] ra1, ra2;
//wire we_b;
wire [15:0] wd, rd1, rd2;
wire [4:0] flags, falgs_out;//flags for conditional jump 
wire [15:0] pc_counter,result, addr_a, addr_b, B_value;
wire [15:0] q_a;
wire [4:0] flags_out;
output [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

 


//Regfile
regfile Reg(.clk(clk), .regwrite(regwrite), .ra1(ra1), .ra2(ra2), .wa(wa), .wd(wd), .rd1(rd1), .rd2(rd2), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15));


//Memory
Memory Mem(.data_a(rd1), .addr_a(addr_a), .we_a(we_a), .clk(clk), .q_a(q_a));


//ALU
alu Alu(.A(rd1), .B(rd2), .aluop(aluop), .ImmLo(immLo), .Flags(flags), .Result(result), .PC(pc_counter));

//FLAG
flags flag(.clk(clk), .reset(reset), .flags(flags), .flag_en(flag_en), .flags_out(flags_out));

//CMP_mux
//mux_2to1 mux3(.A(rd1), .B(r_flag), .sel(CMP_mux_en), .Y(In_A));

//Imm_mux
//mux_2to1 mux3 (.A(rd2), .B({12'b000000000000,ImmLo}), .sel(sel_imm), .Y(B_value));

//LD_mux
mux_2to1 mux1(.A(result), .B(q_a), .sel(LD_mux_en_a), .Y(wd));
//mux_2to1 mux1(.A(result), .B(q_b), .sel(LD_mux_en_b), .Y(wd));

//PC_MUX. 
mux_2to1 mux2(.A(rd2),.B(pc_counter), .sel(pc_mux), .Y(addr_a));
//mux_2to1 mux2(.A(ra1),.B(pc_counter), .sel(pc_mux), .Y(addr_b));

//program counter 
pc pc1(.clk(clk), .reset(reset), .pc_en(pc_en),.ld_pc(rd2), .ld_pc_disp(ld_pc_disp), .ld_pc_en(ld_pc_en), .wr_pc(wr_pc), .pc(pc_counter));
//pc pc1(.clk(clk), .reset(reset), .pc_en(pc_en),.ld_pc(ra2), .ld_pc_en(ld_pc_en), .pc(pc_counter));


FSM myfsm (clk, reset, q_a, regwrite, wa, aluop, we_a, immLo, 
	 LD_mux_en_a, pc_en, ld_pc_en,pc_mux, ra1, ra2, flags_out, flag_en, wr_pc, ld_pc_disp);

endmodule