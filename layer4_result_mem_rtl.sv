`timescale 1ns/10ps
`include"def.svh"
module layer4_result_mem(
	clk,
	rst,
	save_enable,
	layer4_result_store_data_in,
	save_row_addr,
	save_col_addr,
	read_row_addr,
	read_col_addr,
	layer4_result_read_signal,
	//INOUT
	
	layer4_result_output
);
	input clk;
	input rst;

	input        save_enable;
	input [`LAYER4_OUTPUT_LENGTH-1:0]layer4_result_store_data_in;
	input [ 15:0] 	save_row_addr;
	input [ 15:0] 	save_col_addr;
	input [ 15:0] 	read_row_addr;
	input [ 15:0] 	read_col_addr;
	input        layer4_result_read_signal;
	//INOUT
	
	output logic [`LAYER4_OUTPUT_LENGTH-1:0] layer4_result_output;
	
	logic [`LAYER4_OUTPUT_LENGTH-1:0] layer4_results_mem    [`LAYER5_WIDTH][`LAYER5_WIDTH];
	logic [`LAYER4_OUTPUT_LENGTH-1:0] layer4_results_mem_in [`LAYER5_WIDTH][`LAYER5_WIDTH];
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=`LAYER5_WIDTH-1;i++)
			begin
				for(byte j=0;j<=`LAYER5_WIDTH-1;j++)
				begin
					layer4_results_mem[i][j]<=`LAYER4_OUTPUT_LENGTH'd0;
				end
			end
			
		end
			//WRITE
		else
		begin
			if(save_enable)
			begin
				layer4_results_mem[save_row_addr][save_col_addr]<=layer4_result_store_data_in;
			end
			else
			begin
				layer4_results_mem<=layer4_results_mem;
			end
		end
	end
	//READ
	always_comb
	begin
		if(layer4_result_read_signal)
		begin
			layer4_result_output=layer4_results_mem[read_row_addr][read_col_addr];
		end
		else
		begin
			layer4_result_output=`LAYER4_OUTPUT_LENGTH'd0;
		end
	end
endmodule
