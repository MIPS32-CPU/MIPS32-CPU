`timescale 1ns/1ps

module sram_control (
	input wire clk50,
	input wire rst,
	input wire [19:0] ramAddr_i,
	input wire [31:0] storeData_i,
	input wire [31:0] loadData_i,
	input wire ramOp_i,
	
	output reg [31:0] ramAddr_o,
	output reg [31:0] storeData_o,
	output reg [31:0] loadData_o,
	output reg writeEnable_n_o,
	output reg readEnable_n_o,
	output reg chipEnable_n_o,
	output reg busEnable_n_o,
	output reg LB_n_o,
	output reg UB_n_o
);	
	
endmodule	
