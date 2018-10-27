//****************Instruction Decode Macro Definations********************
//op represents 31-26, func represents 5-0, 
//rs represents 25-21, rt represents 20-16

//R-type instructions, the same op, different funcs
`define OP_SPECIAL				6'b000000

`define FUNC_ADD				6'b100000
`define FUNC_ADDU				6'b100001
`define FUNC_SUB				6'b100010
`define FUNC_SUBU				6'b100011
`define FUNC_AND				6'b100100
`define FUNC_OR					6'b100101
`define FUNC_XOR				6'b100110
`define FUNC_NOR				6'b100111
`define FUNC_SLT				6'b101010
`define FUNC_SLTU				6'b101011
`define FUNC_SLL				6'b000000
`define FUNC_SRL				6'b000010
`define FUNC_SRA				6'b000011
`define FUNC_SLLV				6'b000100
`define FUNC_SRLV				6'b000110
`define FUNC_SRAV				6'b000111
`define FUNC_MULT				6'b011000
`define FUNC_MULTU				6'b011001
`define FUNC_DIV				6'b011010
`define FUNC_DIVU				6'b011011
`define FUNC_JR					6'b001000
`define FUNC_JALR				6'b001001
`define FUNC_MOVZ				6'b001010
`define FUNC_MOVN				6'b001011
`define FUNC_SYSCALL			6'b001100
`define FUNC_BREAK				6'b001101
`define FUNC_MFHI				6'b010000
`define FUNC_MTHI				6'b010001
`define FUNC_MFLO				6'b010010
`define FUNC_MTLO				6'b010011

//common J-type and I-type instructions, different ops
`define OP_J					6'b000010
`define OP_JAL					6'b000011
`define OP_BEQ					6'b000100
`define OP_BNE					6'b000101
`define OP_BLEZ					6'b000110
`define OP_BGTZ					6'b000111
`define OP_ADDI					6'b001000
`define OP_ADDIU				6'b001001
`define OP_SLTI					6'b001010
`define OP_SLTIU				6'b001011
`define OP_ANDI					6'b001100
`define OP_ORI					6'b001101
`define OP_XORI					6'b001110
`define OP_LUI					6'b001111
`define OP_LB					6'b100000
`define OP_LH					6'b100001
`define OP_LW					6'b100011
`define OP_LBU					6'b100100
`define OP_LHU					6'b100101
`define OP_SB					6'b101000
`define OP_SH					6'b101001						
`define OP_SW					6'b101011

//special branch instructions, op is 000001, different rts
`define OP_REGIMM				6'b000001

`define RT_BLTZ					5'b00000
`define RT_BGEZ					5'b00001
`define RT_BLTZAL				5'b10000
`define RT_BGEZAL				5'b10001

//CP0 instructions
`define OP_COP0					6'b010000

`define FUNC_TLBP				6'b001000
`define FUNC_TLBR				6'b000001
`define FUNC_TLBWI				6'b000010
`define FUNC_TLBWR				6'b000110
`define FUNC_ERET				6'b011000
`define RS_MFC0					5'b00000
`define RS_MTC0					5'b00100

//****************ALU Operations Macro definations********************
`define ALU_NOP                 5'b00000
`define ALU_ADD
`define ALU_SUB
`define ALU_MULT
`define ALU_DIV
`define ALU_AND                 5'b00010
`define ALU_OR                  5'b00001
`define ALU_XOR                 5'b00011
`define ALU_NOR                 5'b00100
`define ALU_SLL
`define ALU_SRL
`define ALU_SRA

