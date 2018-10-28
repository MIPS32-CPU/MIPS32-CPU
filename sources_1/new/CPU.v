/******************************************
Regulations for the names of the wires:
ONLY define the OUTPUT wires of the parts.
In fact, one wire can link two ends.
*******************************************/

module CPU(
    input wire clk,
    input wire rst,
    input wire [31:0] romData_i,
    output wire [31:0] romAddr_o
);
	
    //link the pc and IF/ID
    wire [31:0] pc_pc_o;
    
    //link IF/ID and ID
    wire [31:0] IF_ID_pc_o;
    wire [31:0] IF_ID_inst_o;
    
    //link ID and registers , ID/EX
    wire [31:0] reg_readData1_o, reg_readData2_o;
    wire [4:0] ID_readAddr1_o, ID_readAddr2_o;
    wire ID_readEnable1_o, ID_readEnable2_o;
    wire ID_writeEnable_o;
    wire [4:0] ID_writeAddr_o;
    wire [31:0] ID_oprand1_o, ID_oprand2_o;
    wire [4:0] ID_ALUop_o;
    wire ID_branchEnable_o;
    wire [31:0] ID_branchAddr_o;
    
    //link ID/EX and EX
    wire [4:0] ID_EX_ALUop_o;
    wire [31:0] ID_EX_oprand1_o, ID_EX_oprand2_o;
    wire [4:0] ID_EX_writeAddr_o;
    wire ID_EX_writeEnable_o;
    
    //link EX and EX/MEM
    wire [31:0] EX_result_o;
    wire [4:0] EX_writeAddr_o;
    wire EX_writeEnable_o;
       
    //link EX/MEM and MEM
    wire [31:0] EX_MEM_result_o;
    wire [4:0] EX_MEM_writeAddr_o;
    wire EX_MEM_writeEnable_o;
     
    //link MEM and MEM/WB
    wire [31:0] MEM_result_o;
    wire [4:0] MEM_writeAddr_o;
    wire MEM_writeEnable_o;
     
    //link MEM/WB and registers
    wire [31:0] MEM_WB_result_o;
    wire [4:0] MEM_WB_writeAddr_o;
    wire MEM_WB_writeEnable_o; 
             
    assign romAddr_o = pc_pc_o;
    
    pc pc0(
        .clk(clk),                              .rst(rst), 
        .branchEnable_i(ID_branchEnable_o),    .branchAddr_i(ID_branchAddr_o), 
        .pc_o(pc_pc_o)
    );
    
    
    
    IF_ID IF_ID0(
        .clk(clk),                              .rst(rst), 
        .pc_i(pc_pc_o),                         .inst_i(romData_i), 
        .pc_o(IF_ID_pc_o),                      .inst_o(IF_ID_inst_o)
    );
    
    
    
    ID ID0(
        .clk(clk),                              .rst(rst), 
        .inst_i(IF_ID_inst_o),                  .pc_i(IF_ID_pc_o), 
        .readData1_i(reg_readData1_o),          .readData2_i(reg_readData2_o),
        .EX_writeEnable_i(EX_writeEnable_o),	.EX_writeAddr_i(EX_writeAddr_o),
        .EX_writeData_i(EX_result_o),			.MEM_writeEnable_i(MEM_writeEnable_o),
        .MEM_writeAddr_i(MEM_writeAddr_o), 		.MEM_writeData_i(MEM_result_o),
        .readAddr1_o(ID_readAddr1_o),           .readAddr2_o(ID_readAddr2_o), 
        .readEnable1_o(ID_readEnable1_o),       .readEnable2_o(ID_readEnable2_o), 
        .writeEnable_o(ID_writeEnable_o),       .writeAddr_o(ID_writeAddr_o),
        .oprand1_o(ID_oprand1_o),               .oprand2_o(ID_oprand2_o), 
        .branchEnable_o(ID_branchEnable_o),     .branchAddr_o(ID_branchAddr_o), 
        .ALUop_o(ID_ALUop_o)
    );
    
    
    registers regs0(
        .clk(clk),                              .rst(rst), 
        .readEnable1_i(ID_readEnable1_o),       .readEnable2_i(ID_readEnable2_o), 
        .readAddr1_i(ID_readAddr1_o),           .readAddr2_i(ID_readAddr2_o),
        .writeEnable_i(MEM_WB_writeEnable_o),   .writeAddr_i(MEM_WB_writeAddr_o), 
        .writeData_i(MEM_WB_result_o),          .readData1_o(reg_readData1_o), 
        .readData2_o(reg_readData2_o)
    );
    
    
    
    ID_EX ID_EX0(
        .clk(clk),                              .rst(rst), 
        .ALUop_i(ID_ALUop_o),                   .oprand1_i(ID_oprand1_o), 
        .oprand2_i(ID_oprand2_o),               .writeAddr_i(ID_writeAddr_o),
        .writeEnable_i(ID_writeEnable_o),       .ALUop_o(ID_EX_ALUop_o), 
        .oprand1_o(ID_EX_oprand1_o),            .oprand2_o(ID_EX_oprand2_o), 
        .writeAddr_o(ID_EX_writeAddr_o),        .writeEnable_o(ID_EX_writeEnable_o)
    );
    
   
    
    EX EX0(
    	.clk(clk), 								.rst(rst), 
    	.ALUop_i(ID_EX_ALUop_o),				.oprand1_i(ID_EX_oprand1_o), 
    	.oprand2_i(ID_EX_oprand2_o), 			.writeAddr_i(ID_EX_writeAddr_o),
    	.writeEnable_i(ID_EX_writeEnable_o), 	.result_o(EX_result_o), 
    	.writeAddr_o(EX_writeAddr_o),			.writeEnable_o(EX_writeEnable_o)
    );
    
    
    
    EX_MEM EX_MEM0(
    	.clk(clk), 								.rst(rst), 
    	.result_i(EX_result_o),					.writeAddr_i(EX_writeAddr_o), 
    	.writeEnable_i(EX_writeEnable_o), 		.result_o(EX_MEM_result_o),
    	.writeAddr_o(EX_MEM_writeAddr_o), 		.writeEnable_o(EX_MEM_writeEnable_o)
    );
    
  
    
    MEM MEM0(
    	.clk(clk), 								.rst(rst), 
        .result_i(EX_MEM_result_o),				.writeAddr_i(EX_MEM_writeAddr_o), 
        .writeEnable_i(EX_MEM_writeEnable_o), 	.result_o(MEM_result_o),
        .writeAddr_o(MEM_writeAddr_o), 			.writeEnable_o(MEM_writeEnable_o)
    );
    

    
    MEM_WB MEM_WB0(
    	.clk(clk), 								.rst(rst), 
        .result_i(MEM_result_o),				.writeAddr_i(MEM_writeAddr_o), 
        .writeEnable_i(MEM_writeEnable_o), 		.result_o(MEM_WB_result_o),
        .writeAddr_o(MEM_WB_writeAddr_o), 		.writeEnable_o(MEM_WB_writeEnable_o)
    ); 

endmodule
    
    
    
