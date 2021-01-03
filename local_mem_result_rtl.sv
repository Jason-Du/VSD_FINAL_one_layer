`timescale 1ns/10ps
module local_mem_result(
	clk,
	rst,
	read_result_signal,
	write_result_data,
	write_result_signal,
	
	read_result_data
);
	input clk;
	input rst;
	input read_result_signal;
	input write_result_data;
	input write_result_signal;

	output logic read_result_data;
	
	logic [31:0] result_mem_in;
	logic [31:0] result_mem_out;
	always_comb
	begin
		if(read_result_signal)
		begin
			read_result_data=result_mem_out;
		end
		else
		begin
			read_result_data=32'd0
		end
	end
	always_comb
	begin
		if(write_result_signal)
		begin
			result_mem_in=write_result_data;
		end
		else
		begin
			result_mem_in=result_mem_out;
		end
	end
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			result_mem_out<=32'd0;
		end
		else
		begin
			result_mem_out<=result_mem_in;
		end
	end
	
endmodule





