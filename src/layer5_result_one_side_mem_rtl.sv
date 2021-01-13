`timescale 1ns/10ps
`include"def.svh"
//`include "include/def.svh"
module layer5_result_one_side_mem(
	clk,
	rst,
	save_enable,
	layer5_result_store_data_in,
	save_row_addr,
	save_col_addr,
	read_row_addr,
	read_col_addr,
	layer5_result_read_signal,
	//INOUT
	
	layer5_result_output
);
	input clk;
	input rst;

	input        save_enable;
	input [`LAYER6_WEIGHT_INPUT_LENGTH-1:0]layer5_result_store_data_in;
	input [ 15:0] 	save_row_addr;
	input [ 15:0] 	save_col_addr;
	input [ 15:0] 	read_row_addr;
	input [ 15:0] 	read_col_addr;
	input        layer5_result_read_signal;
	//INOUT
	
	output logic [`LAYER6_WEIGHT_INPUT_LENGTH-1:0] layer5_result_output;
	
	logic [`LAYER6_WEIGHT_INPUT_LENGTH-1:0] layer5_results_mem [`LAYER6_WIDTH/2][`LAYER6_WIDTH/2];
	logic [`LAYER6_WEIGHT_INPUT_LENGTH-1:0] layer5_results_mem_in [`LAYER6_WIDTH/2][`LAYER6_WIDTH/2];
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(int i=0;i<=`LAYER6_WIDTH/2-1;i++)
			begin
				for(int j=0;j<=`LAYER6_WIDTH/2-1;j++)
				begin
					layer5_results_mem [i][j]<=`LAYER6_WEIGHT_INPUT_LENGTH'd0;
				end
			end
			
		end
			//WRITE
		else
		begin
			if(save_enable&&save_row_addr[2:0]<3'd5&&save_col_addr[2:0]<3'd5)
			begin
				layer5_results_mem [save_row_addr[2:0]][save_col_addr[2:0]]<=layer5_result_store_data_in;
			end
			else
			begin
				layer5_results_mem <=layer5_results_mem ;
			end
		end
	end
	//READ
	always_comb
	begin
		if(layer5_result_read_signal&&read_row_addr[2:0]<3'd5&&read_col_addr[2:0]<3'd5)
		begin
			layer5_result_output=layer5_results_mem [read_row_addr[2:0]][read_col_addr[2:0]];
		end
		else
		begin
			layer5_result_output=`LAYER6_WEIGHT_INPUT_LENGTH'd0;
		end
		
	end
endmodule
