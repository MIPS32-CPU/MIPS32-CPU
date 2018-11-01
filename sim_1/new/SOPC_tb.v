module SOPC_tb;
	reg clk;
	reg rst;

	initial begin
		clk = 1'b0;
		forever #10 clk = ~clk;
	end

	initial begin
		rst = 1'b1;
		#25 rst = 1'b0;
		#2000 $stop;
	end
	
	SOPC SOPC0(
		.clk(clk), .rst(rst)
	);

endmodule