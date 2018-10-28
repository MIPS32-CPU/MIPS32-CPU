module MEM(
    input wire clk,
    input wire rst,
    input wire [31:0] result_i,
    input wire [4:0] writeAddr_i,
    input wire writeEnable_i,
    
    output reg [31:0] result_o,
    output reg [4:0] writeAddr_o,
    output reg writeEnable_o
);

    always @ (*) begin
        if (rst == 1'b1) begin 
            result_o <= 32'b0;
            writeEnable_o <= 1'b0;
            writeAddr_o <= 5'b0;
        end else begin
            result_o <= result_i;
            writeEnable_o <= writeEnable_i;
            writeAddr_o <= writeAddr_i;
        end
    end
endmodule