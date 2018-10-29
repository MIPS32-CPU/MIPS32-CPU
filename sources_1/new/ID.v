`include<defines.v>

module ID(
    input wire clk,
    input wire rst,
    input wire [31:0] inst_i,
    input wire [31:0] pc_i,
    
    input wire [31:0] readData1_i,
    input wire [31:0] readData2_i,
    
    //data from HILO registers
    input wire [31:0] HI_data_i,
    input wire [31:0] LO_data_i,
    
    //EX bypass signals  
    input wire [4:0] EX_writeAddr_i,
    input wire EX_writeEnable_i,
    input wire[1:0] EX_writeHILO_i,
    input wire [31:0] EX_writeHI_data_i,
    input wire [31:0] EX_writeLO_data_i,
    
    //MEM bypass signals
    input wire [4:0] MEM_writeAddr_i,
    input wire MEM_writeEnable_i,
    input wire [1:0] MEM_writeHILO_i,
    input wire [31:0] MEM_writeHI_data_i,
    input wire [31:0] MEM_writeLO_data_i,
    
    output reg [4:0] readAddr1_o,
    output reg [4:0] readAddr2_o,
    output reg readEnable1_o,
    output reg readEnable2_o,
    output reg [4:0] writeAddr_o,
    output reg writeEnable_o,
    
    output reg [1:0] writeHILO_o,
    
    output reg [31:0] oprand1_o,
    output reg [31:0] oprand2_o,
    output reg branchEnable_o,
    output reg [31:0] branchAddr_o,
    output reg [4:0] ALUop_o
);
    wire [5:0] inst_op = inst_i[31:26];
    wire [4:0] inst_rs = inst_i[25:21];
    wire [4:0] inst_rt = inst_i[20:16];
    wire [4:0] inst_rd = inst_i[15:11];
    wire [4:0] inst_shamt = inst_i[10:6];
    wire [5:0] inst_func = inst_i[5:0];
    
    reg [31:0] imm;
    reg [1:0] readHILO;
    
    //get the first operand
    always @ (*) begin
    	if (rst == 1'b1) begin
    		oprand1_o <= 32'b0;
    	end else if(readHILO == 2'b10 && EX_writeHILO_i[1] == 1'b1) begin
    		oprand1_o <= EX_writeHI_data_i;
    	end else if(readHILO == 2'b01 && EX_writeHILO_i[0] == 1'b1) begin
    		oprand1_o <= EX_writeLO_data_i;
    	end else if(readHILO == 2'b10 && MEM_writeHILO_i[1] == 1'b1) begin
    		oprand1_o <= MEM_writeHI_data_i;
    	end else if(readHILO == 2'b01 && MEM_writeHILO_i[0] == 1'b1) begin
    		oprand1_o <= MEM_writeLO_data_i;
    	end else if(readHILO == 2'b10) begin
    		oprand1_o <= HI_data_i;
    	end else if(readHILO == 2'b01) begin
    		oprand1_o <= LO_data_i;	
    	end else if(readEnable1_o == 1'b1 && EX_writeEnable_i == 1'b1 &&
    				EX_writeAddr_i == readAddr1_o) begin
    		oprand1_o <= EX_writeLO_data_i;
  		end else if(readEnable1_o == 1'b1 && MEM_writeEnable_i == 1'b1 &&
  					MEM_writeAddr_i == readAddr1_o) begin
  			oprand1_o <= MEM_writeLO_data_i;
  		end else if(readEnable1_o == 1'b1) begin
  			oprand1_o <= readData1_i;
  		end else if(readEnable1_o == 1'b0) begin
  			oprand1_o <= imm;
  		end else begin
  			oprand1_o <= 32'b0;
  		end
  	end
  	
  	//get the second oprand
  	always @ (*) begin
		if (rst == 1'b1) begin
			oprand2_o <= 32'b0;
		end else if(readEnable2_o == 1'b1 && EX_writeEnable_i == 1'b1 &&
					EX_writeAddr_i == readAddr2_o) begin
			oprand2_o <= EX_writeLO_data_i;
		end else if(readEnable2_o == 1'b1 && MEM_writeEnable_i == 1'b1 &&
					MEM_writeAddr_i == readAddr2_o) begin
			oprand2_o <= MEM_writeLO_data_i;
		end else if(readEnable2_o == 1'b1) begin
			oprand2_o <= readData2_i;
		end else if(readEnable2_o == 1'b0) begin
			oprand2_o <= imm;
		end else begin
			oprand2_o <= 32'b0;
		end
	end
    	
    //decode the instructions	
    always @ (*) begin
        if(rst == 1'b1) begin
            readAddr1_o <= 5'b0;
            readAddr2_o <= 5'b0;
            readEnable1_o <= 1'b0;
            readEnable2_o <= 1'b0;
            readHILO <= 2'b00;
            imm <= 32'b0;
            writeAddr_o <= 4'b0;
            writeEnable_o <= 1'b0;
            branchEnable_o <= 1'b0;
            branchAddr_o <= 32'b0;
            writeHILO_o <= 2'b00;
            ALUop_o <= `ALU_NOP;
         end else begin
         	//assign the default values
			readAddr1_o <= 5'b0;
			readAddr2_o <= 5'b0;
			readEnable1_o <= 1'b0;
			readEnable2_o <= 1'b0;
			readHILO <= 2'b00;
			imm <= 32'b0;
			writeAddr_o <= 5'b0;
			writeEnable_o <= 1'b0;
			branchEnable_o <= 1'b0;
			branchAddr_o <= 32'b0;
			ALUop_o <= `ALU_NOP;
			writeHILO_o <= 2'b00;
			
          	case (inst_op)
                `OP_ORI: begin
					readEnable1_o <= 1'b1;
					readAddr1_o <= inst_rs;
					imm <= {16'b0, inst_i[15:0]};
					writeEnable_o <= 1'b1;
					writeAddr_o <= inst_rt; 
					ALUop_o <= `ALU_OR;	
				end
				
				`OP_J: begin
					branchEnable_o <= 1'b1;			
                end
                
            	`OP_SPECIAL: begin
            		case(inst_func)
            			`FUNC_MFHI: begin
            				readHILO <= 2'b10;
            				writeEnable_o <= 1'b1;
            				writeAddr_o <= inst_rd;
            				ALUop_o <= `ALU_MOV;
            			end
            			
            			`FUNC_MTHI: begin
            				writeHILO_o <= 2'b10;
            				ALUop_o <= `ALU_MOV;
            			end
            			
            			`FUNC_MULT: begin
            				writeHILO_o <= 2'b11;
            				readEnable1_o <= 1'b1;
            				readAddr1_o <= inst_rs;
            				readEnable2_o <= 1'b1;
            				readAddr2_o <= inst_rt;
            				ALUop_o <= `ALU_MULT;
            			end
            		endcase
            	end
            	
            	default: begin
            	end
            endcase
        end
    end
    
    //branch instructions
    always @(*) begin
    	if(branchEnable_o == 1'b1) begin
    		case (inst_op) 
    			`OP_J: begin
    				branchAddr_o <= {pc_i[31:28], inst_i[25:0], 2'b0};
    			end
    		endcase
    	end
    end

endmodule
      