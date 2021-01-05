`timescale 1ns/10ps
`include"def.svh"
module layer3_result_mem(
	clk,
	rst,
	save_enable,
	layer3_result_store_data_in,
	save_row_addr,
	save_col_addr,
	read_row_addr,
	read_col_addr,
	layer3_result_read_signal,
	//INOUT
	
	layer3_result_output
);
	input clk;
	input rst;

	input        save_enable;
	input [`LAYER3_OUTPUT_LENGTH-1:0]layer3_result_store_data_in;
	input [ 15:0] 	save_row_addr;
	input [ 15:0] 	save_col_addr;
	input [ 15:0] 	read_row_addr;
	input [ 15:0] 	read_col_addr;
	input        layer3_result_read_signal;
	//INOUT
	
	output logic [`LAYER3_OUTPUT_LENGTH-1:0] layer3_result_output;
	
	logic [`LAYER3_OUTPUT_LENGTH-1:0] layer3_results_mem    [`LAYER4_WIDTH][`LAYER4_WIDTH];
	logic [`LAYER3_OUTPUT_LENGTH-1:0] layer3_results_mem_in [`LAYER4_WIDTH][`LAYER4_WIDTH];
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=`LAYER4_WIDTH-1;i++)
			begin
				for(byte j=0;j<=`LAYER4_WIDTH-1;j++)
				begin
					layer3_results_mem[i][j]<=`LAYER3_OUTPUT_LENGTH'd0;
				end
			end
			
		end
			//WRITE
		else
		begin
			if(save_enable)
			begin
				layer3_results_mem[save_row_addr][save_col_addr]<=layer3_result_store_data_in;
			end
			else
			begin
				layer3_results_mem<=layer3_results_mem;
			end
		end
	end
	//READ
	always_comb
	begin
		if(layer3_result_read_signal)
		begin
			layer3_result_output=layer3_results_mem[read_row_addr][read_col_addr];
		end
		else
		begin
			layer3_result_output=`LAYER3_OUTPUT_LENGTH'd0;
		end
	end
endmodule
