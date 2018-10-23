module pc(
    input wire clk,
    input wire rst,
    input wire branchEnable_i,
    input wire[31:0] branchAddr_i,
    
    output reg[31:0] pc_o 
    );
    
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            pc_o <= 32'b0;
        end else begin
            if(branchEnable_i == 1'b1) begin
                pc_o <= branchAddr_i;
            end else begin
                pc_o <= pc_o + 4'h4;
            end
        end
    end
 endmodule
