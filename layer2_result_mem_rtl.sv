`timescale 1ns/10ps
`include"def.svh"
module layer2_result_mem(
	clk,
	rst,
	save_enable,
	layer2_result_store_data_in,
	save_row_addr,
	save_col_addr,
	read_row_addr,
	read_col_addr,
	layer2_result_read_signal,
	//INOUT
	
	layer2_result_output
);
	input clk;
	input rst;

	input        save_enable;
	input [`LAYER2_OUTPUT_LENGTH-1:0]layer2_result_store_data_in;
	input [ 15:0] 	save_row_addr;
	input [ 15:0] 	save_col_addr;
	input [ 15:0] 	read_row_addr;
	input [ 15:0] 	read_col_addr;
	input        layer2_result_read_signal;
	//INOUT
	
	output logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result_output;
	
	logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_results_mem    [30][30];
	logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_results_mem_in [30][30];
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=29;i++)
			begin
				for(byte j=0;j<=29;j++)
				begin
					layer2_results_mem[i][j]<=127'd0;
				end
			end
			
		end
			//WRITE
		else
		begin
			if(save_enable)
			begin
				layer2_results_mem[save_row_addr][save_col_addr]<=layer2_result_store_data_in;
			end
			else
			begin
				layer2_results_mem<=layer2_results_mem;
			end
		end
	end
	//READ
	always_comb
	begin
		if(layer2_result_read_signal)
		begin
			layer2_result_output=layer2_results_mem[read_row_addr][read_col_addr];
		end
		else
		begin
			layer2_result_output=128'd0;
		end
	end
endmodule
