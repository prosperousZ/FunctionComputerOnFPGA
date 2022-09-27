//Author: prim: Yuntong Lu		Second: Haoze Zhang
module pc(input clk,
    input reset,
    input pc_en,
	 input [15:0] ld_pc,
	 input [7:0] ld_pc_disp,
	 input ld_pc_en,
	 input wr_pc,
    output reg [15:0] pc);

always@(posedge clk)begin
        if(reset == 0)
            begin
				pc <= 0;
            end
        else begin 
				if(pc_en)begin
					if(ld_pc_en)begin
						if (ld_pc_disp[7] == 0)
							pc <= pc + {8'b00000000,ld_pc_disp};
						else 
							pc <= pc - {9'b000000000,(~ld_pc_disp[6:0])} - 16'b0000000000000011;
					end else if (wr_pc) begin
						pc <= ld_pc;
					end else begin
						pc <= pc + 16'b0000_0000_0000_0001;
					end
				end 
			end
end 
endmodule