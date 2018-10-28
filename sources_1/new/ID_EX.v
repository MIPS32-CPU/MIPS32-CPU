`include<defines.v>

module ID_EX(
    input wire clk,
    input wire rst,
    input wire [4:0] ALUop_i,
    input wire [31:0] oprand1_i,
    input wire [31:0] oprand2_i,
    input wire [4:0] writeAddr_i,
    input wire writeEnable_i,
    
    output reg [4:0] ALUop_o,
    output reg [31:0] oprand1_o,
    output reg [31:0] oprand2_o,
    output reg [4:0] writeAddr_o,
    output reg writeEnable_o
);

    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            ALUop_o <= `ALU_NOP;
            oprand1_o <= 32'b0;
            oprand2_o <= 32'b0;
            writeAddr_o <= 5'b0;
            writeEnable_o <= 1'b0;
        end else begin
            ALUop_o <= ALUop_i;
            oprand1_o <= oprand1_i;
            oprand2_o <= oprand2_i;
            writeEnable_o <= writeEnable_i;
            writeAddr_o <= writeAddr_i;
        end
    end
endmodule