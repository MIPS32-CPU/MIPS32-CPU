module pc_tb;
    reg clk;
    reg rst;
    reg branchEnable_i;
    reg[31:0] branchAddr_i;
    wire[31:0] pc_o;
initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

initial begin
    rst = 1'b1;
    branchEnable_i = 1'b0;
    branchAddr_i = 32'b1;
    #195 rst = 1'b0;
    #400 branchEnable_i = 1'b1;
    #1000 $stop;
end

pc pc0(.clk(clk), .rst(rst), .branchEnable_i(branchEnable_i), 
       .branchAddr_i(branchAddr_i), .pc_o(pc_o));
endmodule