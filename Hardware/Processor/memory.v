//Author: prim: Yuntong Lu		Second: Haoze Zhang

module memory
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=16)
(
	input [(DATA_WIDTH-1):0] address,
	input clock,
	input [(ADDR_WIDTH-1):0] data,
	input wren,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;

	// Specify the initial contents.  You can also use the $readmemb
	// system task to initialize the RAM variable from a text file.
	// See the $readmemb template page for details.
	initial 
	begin : INIT
		$readmemh("/home/klemmon/Desktop/Fall2019/CS3710/FinalProject/Processor/memory.txt",ram);
	end 

	always @ (posedge clock)
	begin
		// Write
		if (wren)
			ram[address] <= data;

		addr_reg <= address;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ram[addr_reg];

endmodule
