`timescale 1ns/1ps
`include<defines.v>

module sram_control (
	input wire clk50,
	input wire rst,
	input wire [19:0] ramAddr_i,
	input wire [31:0] storeData_i,
	input wire [3:0] ramOp_i,
	
	output reg [31:0] loadData_o,
	output reg WE_n_o,
	output reg OE_n_o,
	output reg CE_n_o,
	output reg [3:0] be_n_o,
	output reg [19:0] ramAddr_o,
	
	inout wire [31:0] data_io
);	
	reg [31:0] data_io_reg;
	reg [1:0] state, nstate;
	assign data_io = data_io_reg;
	
	parameter IDLE = 2'b00,
			  READ = 2'b01,
			  WRITE = 2'b10;
			  
	always @(posedge clk50 or posedge rst) begin
		if(rst == 1'b1) begin
			state <= IDLE;
		end else begin
			state <= nstate;
		end
	end
		
    always @(*) begin
    	if(rst == 1'b1 || ramOp_i == 4'b0) begin
			WE_n_o <= 1'b1;
			CE_n_o <= 1'b1;
			OE_n_o <= 1'b1;
			be_n_o <= 4'b1111;
			ramAddr_o <= 20'b0;
			loadData_o <= 32'b0;
			data_io_reg <= 32'bz;
			state <= IDLE;
		end else begin
			
			case(state) 
				IDLE: begin
					WE_n_o <= 1'b1;
					OE_n_o <= 1'b1;
					CE_n_o <= 1'b0;
					be_n_o <= 4'b0;
					loadData_o <= 32'b0;
					data_io_reg <= storeData_i;
					ramAddr_o <= ramAddr_i;
					
					case(ramOp_i) 
						`MEM_LW: begin
							nstate <= READ;
						end
						`MEM_SW: begin
							nstate <= WRITE;
						end
						default: begin
							nstate <= IDLE;
						end
					endcase
				end
				
				READ: begin
					CE_n_o <= 1'b0;
					OE_n_o <= 1'b0;
					be_n_o <= 4'b0;
					data_io_reg <= 32'bz;
					loadData_o <= data_io;
					
					if(ramOp_i != 4'b0011) begin
						nstate <= IDLE;
					end else begin
						nstate <= READ;
					end
				end
				
				WRITE: begin
					CE_n_o <= 1'b0;
					WE_n_o <= 1'b0;
					be_n_o <= 4'b0;
					nstate <= IDLE;
				end
			
			endcase
		end			
    end
	 
endmodule	
