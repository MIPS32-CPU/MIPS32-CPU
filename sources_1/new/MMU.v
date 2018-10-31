module MMU(
	input wire clk,
	input wire rst,
	input wire [31:0] virtualAddr_i,
	input wire [3:0] memOp_i,
	input wire [31:0] storeData_i,
	input wire [31:0] Sram_ramData_i,
	
	output reg [3:0] memOp_o,
	output reg [31:0] loadData_o,
	output reg [31:0] storeData_o,
	output reg [19:0] physicalAddr_o
);
	always @(*) begin 
		if(rst == 1'b1) begin
			memOp_o <= 3'b0;
			loadData_o <= 32'b0;
			storeData_o <= 32'b0;
			physicalAddr_o <= 32'b0;
		end else begin
			memOp_o <= memOp_i;
			loadData_o <= Sram_ramData_i;
			storeData_o <= storeData_i;
			physicalAddr_o <= virtualAddr_i[19:0];
		end
	end
endmodule