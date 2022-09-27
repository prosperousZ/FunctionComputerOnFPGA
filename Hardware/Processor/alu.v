//Author: prim: Yuntong Lu		Second: Haoze Zhang

module alu(A, B, Cin, aluop, ImmLo, Flags, Result, PC, Jneed, Cond
	);
	
parameter WIDTH = 16;
input [WIDTH-1:0] A, B, PC;
input [7:0] aluop;
input [3:0] ImmLo, Cond;
input Cin;
output reg [WIDTH-1:0] Result;
output reg [4:0] Flags; //CLFZN
output reg Jneed;

// base line
parameter ADD = 8'b00000101;
parameter ADDU = 8'b00000110;
parameter ADDC = 8'b00000111;
parameter SUB = 8'b00001001;
parameter CMP = 8'b00001011;
parameter AND = 8'b00000001;
parameter OR = 8'b00000010;
parameter XOR = 8'b00000011;
parameter MOV = 8'b00001101;
parameter LOAD = 8'b01000000;
parameter STORE = 8'b01000100;
parameter JCOND = 8'b01001100;
parameter JAL = 8'b01001000;
// addition 
parameter ADDI = 4'b0101;
parameter ADDUI = 4'b0110;
parameter ADDCI = 4'b0111;
parameter SUBI = 4'b1001;
parameter CMPI = 4'b1011;
parameter ORI = 4'b0010;
parameter ANDI = 4'b0001;
parameter MOVI = 4'b1101;
parameter BCOND = 4'b1100;
parameter LUI = 4'b1111;
// additional
parameter LSH = 8'b10000100;
parameter LSHL = 8'b10000000;
parameter LSHR = 8'b10000001;
parameter LDSD = 8'b10000101;
parameter STSD = 8'b10000111;

reg [15:0]Imm;


always @(*)
begin
	Imm = 16'b0000000000000000;
	Flags = 5'b00000;
	Jneed = 0;
	Result = 0;
	// base line
	case (aluop[7:4])
	4'b0000: begin
		case (aluop)
			ADD:
				begin
				// get result
				Result = A + B;			
				// set flags
				if (Result == 16'b0000000000000000) 
					begin
					Flags[0] = 1'b1;
					end
				else 
					begin
					Flags[0] = 1'b0;
					end
				
				if( (~A[15] & ~B[15] & Result[15]) | (A[15] & B[15] & ~Result[15]) ) 
					begin
					Flags[2] = 1'b1;
					end
				else 
					begin
					Flags[2] = 1'b0;
					end
				//Flags[1:0] = 2'b00; Flags[3] = 1'b0;
				//Flags[1] = 1'b0; Flags[3] = 1'b0; Flags[4] = 1'b0;
				end

				
			ADDU:
				begin
				{Flags[3], Result} = A + B;
				if (Result == 16'b0000000000000000) Flags[0] = 1'b1; 
				else Flags[0] = 1'b0;
				//Flags[2:0] = 3'b000;
				//Flags[1] = 1'b0; Flags[2] = 1'b0; Flags[4] = 1'b0;
				end

				
			ADDC:
				begin
				Result = A + B + Cin;
				if (Result == 16'b0000000000000000) 
					begin
					Flags[0] = 1'b1;
					end
				else 
					begin
					Flags[0] = 1'b0;
					end
				
				if( (~A[15] & ~B[15] & Result[15]) | (A[15] & B[15] & ~Result[15]) ) 
					begin
					Flags[2] = 1'b1;
					end
				else 
					begin
					Flags[2] = 1'b0;
					end
				//Flags[1:0] = 2'b00; Flags[3] = 1'b0;
				//	Flags[1] = 1'b0; Flags[3] = 1'b0; Flags[4] = 1'b0;
				end

				
			SUB:
				begin
				Result = A - B;
				if (Result == 16'b1111111111111111) Flags[0] = 1'b1;
				else Flags[0] = 1'b0;
				if( (~A[15] & B[15] & Result[15]) | (A[15] & ~B[15] & ~Result[15]) ) Flags[2] = 1'b1;
				else Flags[2] = 1'b0;
				//Flags[1:0] = 2'b00; Flags[3] = 1'b0;
				//Flags[1] = 1'b0; Flags[3] = 1'b0; Flags[4] = 1'b0;
				end

			// the result will store to the last regster in the regfile	
			// CLFZN
			CMP: begin
				Result = A - B;
				// set Z
				if (Result == 0)
					Flags[3] = 1'b1;
				else
					Flags[3] = 1'b0;
				// set L	
				if (A < B) 
					Flags[1] = 1'b1;
				else
					Flags[1] = 1'b0;
				// set N
				if ($signed(A) < $signed(B))
					Flags[4] = 1'b1;
				else	
					Flags[4] = 1'b0;
			end
			
				
			AND:
				begin
				Result = A & B;
				end
		
			OR:
				begin
				Result = A | B;
				end
			
			XOR:
				begin
				Result = A ^ B;
				end
			
			MOV:
				begin
				Result = B;
				end
				
			default: begin
				Result = 16'b0000000000000000;
			end	
				
		endcase			
		end
		
		ADDI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			Result = A + Imm;
			if (Result == 16'b0000000000000000) 
				begin
				Flags[0] = 1'b1;
				end
			else 
				begin
				Flags[0] = 1'b0;
				end
			
			if( (~A[15] & ~Imm[15] & Result[15]) | (A[15] & Imm[15] & ~Result[15]) ) 
				begin
				Flags[2] = 1'b1;
				end
			else 
				begin
				Flags[2] = 1'b0;
				end
			//Flags[1:0] = 2'b00; Flags[3] = 1'b0;
			//Flags[1] = 1'b0; Flags[3] = 1'b0; Flags[4] = 1'b0;
			end
		
		ADDUI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			{Flags[3], Result} = A + Imm;
			if (Result == 16'b0000000000000000) Flags[0] = 1'b1; 
			else Flags[0] = 1'b0;
			//Flags[2:0] = 3'b000;
			//Flags[1] = 1'b0; Flags[3] = 1'b0; Flags[4] = 1'b0;
			end

		
		ADDCI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			Result = A + Imm + Cin;
			if (Result == 16'b0000000000000000) 
				begin
				Flags[0] = 1'b1;
				end
			else 
				begin
				Flags[0] = 1'b0;
				end
			
			if( (~A[15] & ~Imm[15] & Result[15]) | (A[15] & Imm[15] & ~Result[15]) ) 
				begin
				Flags[2] = 1'b1;
				end
			else 
				begin
				Flags[2] = 1'b0;
				end
			//Flags[1:0] = 2'b00; Flags[3] = 1'b0;
			//Flags[1] = 1'b0; Flags[3] = 1'b0; Flags[4] = 1'b0;
			end
		
		

		SUBI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			Result = A - Imm;
			if (Result == 16'b1111111111111111) Flags[0] = 1'b1;
			else Flags[0] = 1'b0;
			if( (~A[15] & B[15] & Result[15]) | (A[15] & ~B[15] & ~Result[15]) ) Flags[2] = 1'b1;
			else Flags[2] = 1'b0;
			//Flags[1:0] = 2'b00; Flags[3] = 1'b0;
			//Flags[1] = 1'b0; Flags[3] = 1'b0; Flags[4] = 1'b0;
			end
		
		

		CMPI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			Result = A - Imm;
			// set Z
			if (Result == 0)
				Flags[3] = 1'b1;
			else
				Flags[3] = 1'b0;
			// set L	
			if (A < Imm)
				Flags[1] = 1'b1;
			else
				Flags[1] = 1'b0;
			// set N
			if ($signed(A) < $signed(Imm))
				Flags[4] = 1'b1;
			else	
				Flags[4] = 1'b0;
			end
		ORI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			Result = A | Imm;
			end
		ANDI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			Result = A & Imm;
			end			
		MOVI:
			begin
			Imm = {8'b00000000, aluop[3:0], ImmLo};
			Result = Imm;
			end
		
	   // A comes from the last regster in the regfile	
		// Result stores to second last regster
		BCOND:
			begin
			Result = A;				
			end
			
		LUI:
			begin
			Result = {aluop[3:0], ImmLo, A[7:0]};
			end
			
			
		4'b1000: begin
			case(aluop)	
			LSH: 
				begin
				if (B[4] == 0)
					Result = A << B[3:0];
				else
					Result = A >> (~B[3:0] + 4'b0001);
				end
				
			LSHL:
				begin
				Result = A << ImmLo;
				end
			LSHR:
				begin
				Result = A >> ImmLo;
				end
				
			LDSD:
				begin
				end
				
			STSD:
				begin
				end
			default:
				begin
				end
				
			endcase
		end
		
		
		4'b0100: begin
		case(aluop)
			
		LOAD:
			begin
			Result = A;			
			end
			
		STORE:
			begin
			Result = A;
			end
			
		JCOND:
			begin
			Result = {12'b000000000000, ImmLo};
				// when equal
				if (Cond == 4'b0000) begin
					if (A == 16'b0000000000000000) Jneed = 1;
					else Jneed = 0;
				end
				
				// when not equal
				else if (Cond == 4'b1111) begin
					if (A == 16'b0000000000000000) Jneed = 0;
					else Jneed = 1;
				end
				
				// when >
				else if (Cond == 4'b1100) begin
					if (A == 16'b1111111100000000) Jneed = 1;
					else Jneed = 0;
				end
				
				
				// when >=
				else if (Cond == 4'b1101) begin
					if (A == 16'b0000000000000000 | A == 16'b1111111100000000) Jneed = 1;
					else Jneed = 0;
				end
				
				// when <
				else if (Cond == 4'b0011) begin
					if (A == 16'b0000000011111111) Jneed = 1;
					else Jneed = 0;
				end
				
				// when <=
				else if (Cond == 4'b1011) begin
					if (A == 16'b0000000000000000 | A == 16'b0000000011111111) Jneed = 1;
					else Jneed = 0;
				end	
				
			end
			
		JAL:
			begin
			Result = PC - 16'b0000000000000001;
			//Jneed = 1;
			end
		
		default:
			begin
			
			end
		
		endcase
		end
		
		default: 
			begin
			Result = 16'b0000000000000000;
			Flags = 5'b00000;
			end		
	endcase
	
	
	
end

endmodule
	
