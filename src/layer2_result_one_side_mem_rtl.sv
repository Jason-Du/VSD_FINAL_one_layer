`timescale 1ns/10ps
`include"def.svh"
//`include "layer3_wrapper.sv"
module layer2_result_one_side_mem(
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
	output logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result_output;
	logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result_output_sram;
	logic [ 7:0]   read_addr_sram;
	logic [ 7:0]   save_addr_sram;
	logic [16:0]   read_addr_minus;
	logic [19:0]   read_addr_add;
	
	logic [19:0]   save_addr_add;
	logic [16:0]   save_addr_minus;
	logic [`LAYER2_OUTPUT_LENGTH-1:0] null_wire1;
	
	always_comb
	begin
		read_addr_add=(read_row_addr)<<4;
		read_addr_minus=(read_row_addr)<<1;
		read_addr_sram=read_addr_add[7:0]+read_col_addr[7:0]-read_addr_minus[7:0];
		save_addr_add=(save_row_addr)<<4;
		save_addr_minus=(save_row_addr)<<1;
		save_addr_sram=save_addr_add[7:0]+save_col_addr[7:0]-save_addr_minus[7:0];
		layer2_result_output=layer2_result_read_signal?layer2_result_output_sram:128'd0;
	end

layer3_wrapper layer2_st(
  .CK(clk),
  .OEA(1'b0),
  .OEB(layer2_result_read_signal),
  .WEAN(~save_enable),
  .WEBN(1'b1),
  .A(save_addr_sram),
  .B(read_addr_sram),
  .DOA(null_wire1),
  .DOB(layer2_result_output_sram),
  .DIA(layer2_result_store_data_in),
  .DIB(128'd0)
);
	
	//INOUT
	
	/*
	
	logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_results_mem    [`LAYER3_WIDTH/2][`LAYER3_WIDTH/2];
	logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_results_mem_in [`LAYER3_WIDTH/2][`LAYER3_WIDTH/2];
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=`LAYER3_WIDTH/2-1;i++)
			begin
				for(byte j=0;j<=`LAYER3_WIDTH/2-1;j++)
				begin
					layer2_results_mem[i][j]<=`LAYER2_OUTPUT_LENGTH'd0;
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
			layer2_result_output=`LAYER2_OUTPUT_LENGTH'd0;
		end
	end
	*/
endmodule
