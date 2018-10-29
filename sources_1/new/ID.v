`include<defines.v>

module ID(
    input wire clk,
    input wire rst,
    input wire [31:0] inst_i,
    input wire [31:0] pc_i,
    
    input wire [31:0] readData1_i,
    input wire [31:0] readData2_i,
    
    //EX bypass signals
    input wire [31:0] EX_writeData_i,  
    input wire [4:0] EX_writeAddr_i,
    input wire EX_writeEnable_i,
    
    //MEM bypass signals
    input wire [31:0] MEM_writeData_i,
    input wire [4:0] MEM_writeAddr_i,
    input wire MEM_writeEnable_i,
    
    output reg [4:0] readAddr1_o,
    output reg [4:0] readAddr2_o,
    output reg readEnable1_o,
    output reg readEnable2_o,
    output reg [4:0] writeAddr_o,
    output reg writeEnable_o,
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
    reg instValid;
    
    //get the first operand
    always @ (*) begin
    	if (rst == 1'b1) begin
    		oprand1_o <= 32'b0;
    	end else if(readEnable1_o == 1'b1 && EX_writeEnable_i == 1'b1 &&
    				EX_writeAddr_i == readAddr1_o) begin
    					oprand1_o <= EX_writeData_i;
  		end else if(readEnable1_o == 1'b1 && MEM_writeEnable_i == 1'b1 &&
  					MEM_writeAddr_i == readAddr1_o) begin
  						oprand1_o <= MEM_writeData_i;
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
					EX_writeAddr_i == readAddr1_o) begin
			oprand2_o <= EX_writeData_i;
		end else if(readEnable2_o == 1'b1 && MEM_writeEnable_i == 1'b1 &&
					MEM_writeAddr_i == readAddr1_o) begin
			oprand2_o <= MEM_writeData_i;
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
            imm <= 32'b0;
            writeAddr_o <= 4'b0;
            writeEnable_o <= 1'b0;
            branchEnable_o <= 1'b0;
            branchAddr_o <= 32'b0;
            ALUop_o <= 5'b0;
            instValid <= 1'b0;
         end else begin
            case (inst_op)
                `OP_ORI: begin
					readEnable1_o <= 1'b1;
					readAddr1_o <= inst_rs;
					readEnable2_o <= 1'b0;
					imm <= {16'b0, inst_i[15:0]};
					writeEnable_o <= 1'b1;
					writeAddr_o <= inst_rt; 
					branchEnable_o <= 1'b0;
					branchAddr_o <= 32'b0;
					ALUop_o <= `ALU_OR;
					instValid <= 1'b1;
				end
				
				`OP_J: begin
					readEnable1_o <= 1'b0;
					readEnable2_o <= 1'b0;
					imm <= 32'b0;
					writeEnable_o <= 1'b0;
					branchEnable_o <= 1'b1;
					instValid <= 1'b1;
                end
                `OP_SPECIAL: begin
                    case (inst_shamt)
                        5'b00000: begin
                            case (inst_func)
                                `FUNC_AND: begin
                                        readEnable1_o <= 1'b1;
                                        readAddr1_o <= inst_rs;
                                        oprand1_o <= readData1_i;
                                        readEnable2_o <= 1'b1;
                                        readAddr2_o <= inst_rt;
                                        oprand2_o <= readData2_i;
                                        writeEnable_o <= 1'b1;
                                        writeAddr_o <= inst_rd;
                                        branchEnable_o <= 1'b0;
                                        branchAddr_o <= 32'b0;
                                        instValid <= 1'b1;
                                        ALUop_o <= `ALU_AND;
                                end
                                `FUNC_OR: begin
                                        readEnable1_o <= 1'b1;
                                        readAddr1_o <= inst_rs;
                                        oprand1_o <= readData1_i;
                                        readEnable2_o <= 1'b1;
                                        readAddr2_o <= inst_rt;
                                        oprand2_o <= readData2_i;
                                        writeEnable_o <= 1'b1;
                                        writeAddr_o <= inst_rd;
                                        branchEnable_o <= 1'b0;
                                        branchAddr_o <= 32'b0;
                                        instValid <= 1'b1;
                                        ALUop_o <= `ALU_OR;
                                end
                                `FUNC_XOR: begin
                                        readEnable1_o <= 1'b1;
                                        readAddr1_o <= inst_rs;
                                        oprand1_o <= readData1_i;
                                        readEnable2_o <= 1'b1;
                                        readAddr2_o <= inst_rt;
                                        oprand2_o <= readData2_i;
                                        writeEnable_o <= 1'b1;
                                        writeAddr_o <= inst_rd;
                                        branchEnable_o <= 1'b0;
                                        branchAddr_o <= 32'b0;
                                        instValid <= 1'b1;
                                        ALUop_o <= `ALU_XOR;
                                end
                                `FUNC_NOR: begin
                                        readEnable1_o <= 1'b1;
                                        readAddr1_o <= inst_rs;
                                        oprand1_o <= readData1_i;
                                        readEnable2_o <= 1'b1;
                                        readAddr2_o <= inst_rt;
                                        oprand2_o <= readData2_i;
                                        writeEnable_o <= 1'b1;
                                        writeAddr_o <= inst_rd;
                                        branchEnable_o <= 1'b0;
                                        branchAddr_o <= 32'b0;
                                        instValid <= 1'b1;
                                        ALUop_o <= `ALU_NOR;
                                end
                                `FUNC_SLLV: begin
                                        readEnable1_o <= 1'b1;
                                        readAddr1_o <= inst_rs;
                                        oprand1_o <= readData1_i;
                                        readEnable2_o <= 1'b1;
                                        readAddr2_o <= inst_rt;
                                        oprand2_o <= readData2_i;
                                        writeEnable_o <= 1'b1;
                                        writeAddr_o <= inst_rd;
                                        branchEnable_o <= 1'b0;
                                        branchAddr_o <= 32'b0;
                                        instValid <= 1'b1;
                                        ALUop_o <= `ALU_SLL;
                                end
                                `FUNC_SRLV: begin
                                        readEnable1_o <= 1'b1;
                                        readAddr1_o <= inst_rs;
                                        oprand1_o <= readData1_i;
                                        readEnable2_o <= 1'b1;
                                        readAddr2_o <= inst_rt;
                                        oprand2_o <= readData2_i;
                                        writeEnable_o <= 1'b1;
                                        writeAddr_o <= inst_rd;
                                        branchEnable_o <= 1'b0;
                                        branchAddr_o <= 32'b0;
                                        instValid <= 1'b1;
                                        ALUop_o <= `ALU_SRL;
                                end
                                `FUNC_SRAV: begin
                                        readEnable1_o <= 1'b1;
                                        readAddr1_o <= inst_rs;
                                        oprand1_o <= readData1_i;
                                        readEnable2_o <= 1'b1;
                                        readAddr2_o <= inst_rt;
                                        oprand2_o <= readData2_i;
                                        writeEnable_o <= 1'b1;
                                        writeAddr_o <= inst_rd;
                                        branchEnable_o <= 1'b0;
                                        branchAddr_o <= 32'b0;
                                        instValid <= 1'b1;
                                        ALUop_o <= `ALU_SRA;
                                end
                                default: begin
                                end
                            endcase
                        end
                        default: begin
                        end
                    endcase
                end
                `OP_ANDI: begin
                    readEnable1_o <= 1'b1;
                    readAddr1_o <= inst_rs;
                    oprand1_o <= readData1_i;
                    readEnable2_o <= 1'b0;
                    readAddr2_o <= 5'b0;
                    imm <= {16'b0, inst_i[15:0]};
                    oprand2_o <= imm;
                    writeEnable_o <= 1'b1;
                    writeAddr_o <= inst_rt; 
                    branchEnable_o <= 1'b0;
                    branchAddr_o <= 32'b0;
                    ALUop_o <= `ALU_AND;
                    instValid <= 1'b1;
                end
                `OP_XORI: begin
                    readEnable1_o <= 1'b1;
                    readAddr1_o <= inst_rs;
                    oprand1_o <= readData1_i;
                    readEnable2_o <= 1'b0;
                    readAddr2_o <= 5'b0;
                    imm <= {16'b0, inst_i[15:0]};
                    oprand2_o <= imm;
                    writeEnable_o <= 1'b1;
                    writeAddr_o <= inst_rt; 
                    branchEnable_o <= 1'b0;
                    branchAddr_o <= 32'b0;
                    ALUop_o <= `ALU_XOR;
                    instValid <= 1'b1;
                end
                `OP_LUI: begin
                    readEnable1_o <= 1'b1;
                    readAddr1_o <= 5'b0;
                    readEnable2_o <= 1'b0;
                    readAddr2_o <= 5'b0;
                    writeEnable_o <= 1'b1;
                    writeAddr_o <= inst_rt;
                    branchEnable_o <= 1'b0;
                    branchAddr_o <= 32'b0;
                    imm <= {inst_i[15:0], 16'b0};
                    oprand1_o <= readData1_i;
                    oprand2_o <= imm;
                    ALUop_o <= `ALU_OR;
                    instValid <= 1'b1;
                end
                default: begin
                end
            endcase
            if (inst_i[31:21] == 11'b00000000000) begin
                case (inst_func)
                `FUNC_SLL: begin
                        readEnable1_o <= 1'b0;
                        readAddr1_o <= 5'b0;
                        readEnable2_o <= 1'b1;
                        readAddr2_o <= inst_rt;
                        oprand2_o <= readData2_i;
                        writeEnable_o <= 1'b1;
                        writeAddr_o <= inst_rd;
                        branchEnable_o <= 1'b0;
                        branchAddr_o <= 32'b0;
                        imm[4:0] <= inst_shamt;
                        oprand1_o <= imm;
                        ALUop_o <= `ALU_SLL;
                        if(inst_rs == 5'b00000) begin
                            instValid <= 1'b1;
                        end else begin
                            instValid <= 1'b0;
                        end
                end
                `FUNC_SRL: begin
                        readEnable1_o <= 1'b0;
                        readAddr1_o <= 5'b0;
                        readEnable2_o <= 1'b1;
                        readAddr2_o <= inst_rt;
                        oprand2_o <= readData2_i;
                        writeEnable_o <= 1'b1;
                        writeAddr_o <= inst_rd;
                        branchEnable_o <= 1'b0;
                        branchAddr_o <= 32'b0;
                        imm[4:0] <= inst_shamt;
                        oprand1_o <= imm;
                        ALUop_o <= `ALU_SRL;
                        if(inst_rs == 5'b00000) begin
                            instValid <= 1'b1;
                        end else begin
                            instValid <= 1'b0;
                        end
                end
                `FUNC_SRA: begin
                        readEnable1_o <= 1'b0;
                        readAddr1_o <= 5'b0;
                        readEnable2_o <= 1'b1;
                        readAddr2_o <= inst_rt;
                        oprand2_o <= readData2_i;
                        writeEnable_o <= 1'b1;
                        writeAddr_o <= inst_rd;
                        branchEnable_o <= 1'b0;
                        branchAddr_o <= 32'b0;
                        imm[4:0] <= inst_shamt;
                        oprand1_o <= imm;
                        ALUop_o <= `ALU_SRA;
                        if(inst_rs == 5'b00000) begin
                            instValid <= 1'b1;
                        end else begin
                            instValid <= 1'b0;
                        end
                end
                default: begin
                end
                endcase
            end
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
      