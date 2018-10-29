`include<defines.v>
module EX(
    input wire clk,
    input wire rst,
    input wire [4:0] ALUop_i,
    input wire [31:0] oprand1_i,
    input wire [31:0] oprand2_i,
    input wire [4:0] writeAddr_i,
    input wire writeEnable_i,
    input wire [1:0] writeHILO_i,
    
    output reg [4:0] writeAddr_o,
    output reg writeEnable_o,
    output reg [1:0] writeHILO_o,
    output reg [31:0] HI_data_o,
    output reg [31:0] LO_data_o
);
    
    always @ (*) begin
        if(rst == 1'b1) begin
            writeAddr_o <= 5'b0;
            writeEnable_o <= 1'b0;
            writeHILO_o <= 2'b00;
            HI_data_o <= 32'b0;
            LO_data_o <= 32'b0;
        end else begin
        	//assgin the default values
			writeAddr_o <= writeAddr_i;
			writeEnable_o <= writeEnable_i;
			writeHILO_o <= writeHILO_i;
			HI_data_o <= 32'b0;
			LO_data_o <= 32'b0;
            
            case (ALUop_i)
                `ALU_OR: begin
					{HI_data_o, LO_data_o} <= oprand1_i | oprand2_i;
			 	end
			 	
                `ALU_MOV: begin
                	{HI_data_o, LO_data_o} <= oprand1_i;
                end
                
                `ALU_MULT: begin
                	{HI_data_o, LO_data_o} <= oprand1_i * oprand2_i;
                end
                
                default: begin
                end
            endcase
        end
    end
endmodule
                