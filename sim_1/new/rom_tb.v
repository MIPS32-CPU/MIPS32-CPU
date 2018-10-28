module rom_tb;
	reg clk;
	reg rst;
	reg [31:0] pc;
	wire [31:0] inst;
	
	initial begin
		clk = 1'b0;
		forever #10 clk = ~clk;
	end
	
	initial begin
		rst = 1'b1;
		pc = 32'b0;
		#195 rst = 1'b0;
		forever #20 pc = pc + 4'h4;
	end
	
	rom rom0(
		.clk(clk),		.rst(rst),
		.pc_i(pc),		.inst_o(inst)
	);
endmodule