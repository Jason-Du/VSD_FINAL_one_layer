`timescale 1ns/10ps
module counter(
	clk,
	rst,
	count
);
	input clk;
	input rst;
	output [15:0]count;
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			count<=16'd0;
		end
		else
		begin
			count<=count_in;
		end

	end
	always_comb
	begin
		count_in=count+16'd1;
	end
endmodule