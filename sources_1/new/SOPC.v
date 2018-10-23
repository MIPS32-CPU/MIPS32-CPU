module SOPC(
	input wire clk,
	input wire rst
);
	wire [31:0] rom_inst_o;
	wire [31:0] CPU_romAddr_o;
	
	CPU CPU0(
		.clk(clk),				.rst(rst),
		.romData_i(rom_inst_o),	.romAddr_o(CPU_romAddr_o)
	);
	
	rom rom0(
		.clk(clk),				.rst(rst),
		.pc_i(CPU_romAddr_o), 	.inst_o(rom_inst_o)
	);
endmodule