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
    input wire signed_i,
    input wire [63:0] result_div_i,
    input wire success_i,
    
    output reg [4:0] writeAddr_o,
    output reg writeEnable_o,
    output reg [1:0] writeHILO_o,
    output reg [31:0] HI_data_o,
    output reg [31:0] LO_data_o,
    
    output reg signed_o,
    output reg [31:0] dividend_o,
    output reg [31:0] divider_o,
    output reg start_o,
    
    output reg pauseRequest
);
    
    always @ (*) begin
        if(rst == 1'b1) begin
            writeAddr_o <= 5'b0;
            writeEnable_o <= 1'b0;
            writeHILO_o <= 2'b00;
            HI_data_o <= 32'b0;
            LO_data_o <= 32'b0;
            signed_o <= 1'b0;
            dividend_o <= 32'b0;
            divider_o <= 32'b0;
            start_o <= 32'b0;
            
        end else begin
        	//assgin the default values
			writeAddr_o <= writeAddr_i;
			writeEnable_o <= writeEnable_i;
			writeHILO_o <= writeHILO_i;
			HI_data_o <= 32'b0;
			LO_data_o <= 32'b0;
			signed_o <= 1'b0;
			dividend_o <= 32'b0;
			divider_o <= 32'b0;
			start_o <= 32'b0;
            
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
                
                `ALU_DIV: begin
                	if(success_i == 1'b0) begin
                		dividend_o <= oprand1_i;
                		divider_o <= oprand2_i;
                		signed_o <= signed_i;
                		start_o <= 1'b1;
                		pauseRequest <= 1'b1;
                	end else if(success_i == 1'b1) begin
                		start_o <= 1'b0;
                		pauseRequest <= 1'b0;
                		{HI_data_o, LO_data_o} <= result_div_i;
               		end 
               	end
                default: begin
                end
            endcase
        end
    end
endmodule
                