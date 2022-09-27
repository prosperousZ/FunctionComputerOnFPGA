//Author: prim: Yuntong Lu		Second: Haoze Zhang
`timescale 1ns / 1ps
module tb_alu;

parameter WIDTH = 16;
reg [WIDTH-1:0] A, B;
reg [7:0] aluop;
reg [3:0] ImmLo;
reg Cin;
wire [WIDTH-1:0] Result;
wire [4:0] Flags; //CLFZN


alu	AA (A, B, Cin, aluop, ImmLo, Flags, Result);

initial begin
ImmLo = 0;
Cin = 0;
#5

// test add
aluop = 8'b00000101;
A = 8;
B = 9;
#5

// test sub
aluop = 8'b00001001;
A = 321;
B = 300;
#5


// test cmp
aluop = 8'b00001011;
A = 90;
B = 90;
#5

// and
aluop = 8'b00000001;
A = 3;
B = 1;
#5

// xor
aluop = 8'b00000011;
A = 5;
B = 0;
#5

// mov
aluop = 8'b00001101;
A = 0;
B = 20;
#5;

end

endmodule 