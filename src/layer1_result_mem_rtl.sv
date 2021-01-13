`timescale 1ns/10ps
`include"def.svh"
`include "layer1_wrapper.sv"
module layer1_result_mem(
	clk,
	rst,
	save_enable,
	layer1_result_store_data_in,
	save_row_addr,
	save_col_addr,
	read_row_addr,
	read_col_addr,
	layer1_result_read_signal,
	//INOUT
	
	layer1_result_output
);
	input clk;
	input rst;

	input        save_enable;
	input [`LAYER1_OUTPUT_LENGTH-1:0]layer1_result_store_data_in;
	input [ 15:0] 	save_row_addr;
	input [ 15:0] 	save_col_addr;
	input [ 15:0] 	read_row_addr;
	input [ 15:0] 	read_col_addr;
	input        layer1_result_read_signal;
	//INOUT
	
	output logic [`LAYER1_OUTPUT_LENGTH-1:0] layer1_result_output;
	logic        [`LAYER1_OUTPUT_LENGTH-1:0] null_wire1;
	//A WRITE B READ
	logic [ 9:0]   read_addr_sram;
	logic [16:0]   read_addr_minus;
	logic [20:0]   read_addr_add;
	logic [9:0]    save_addr_sram;
	logic [20:0]   save_addr_add;
	logic [16:0]   save_addr_minus;
	
	always_comb
	begin
		read_addr_add=(read_row_addr)<<5;
		read_addr_minus=(read_row_addr)<<1;
		read_addr_sram=read_addr_add[9:0]+read_col_addr[9:0]-read_addr_minus[9:0];
		save_addr_add=(save_row_addr)<<5;
		save_addr_minus=(save_row_addr)<<1;
		save_addr_sram=save_addr_add[9:0]+save_col_addr[9:0]-save_addr_minus[9:0];
	end
	
layer1_wrapper layer1_st(
  .CK(~clk),
  .OEA(1'b0),
  .OEB(layer1_result_read_signal),
  .WEAN(~save_enable),
  .WEBN(1'b1),
  .A(save_addr_sram),
  .B(read_addr_sram),
  .DOA(null_wire1),
  .DOB(layer1_result_output),
  .DIA(layer1_result_store_data_in),
  .DIB(128'd0)
);


	
	

	
	
/*
	logic [`LAYER1_OUTPUT_LENGTH-1:0] layer1_results_mem    [`LAYER2_WIDTH][`LAYER2_WIDTH];
	logic [`LAYER1_OUTPUT_LENGTH-1:0] layer1_results_mem_in [`LAYER2_WIDTH][`LAYER2_WIDTH];
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=`LAYER2_WIDTH-1;i++)
			begin
				for(byte j=0;j<=29;j++)
				begin
					layer1_results_mem[i][j]<=`LAYER1_OUTPUT_LENGTH'd0;
				end
			end
			
		end
			//WRITE
		else
		begin
			if(save_enable)
			begin
				layer1_results_mem[save_row_addr][save_col_addr]<=layer1_result_store_data_in;
			end
			else
			begin
				layer1_results_mem<=layer1_results_mem;
			end
		end
	end
	//READ
	always_comb
	begin
		if(layer1_result_read_signal)
		begin
			layer1_result_output=layer1_results_mem[read_row_addr][read_col_addr];
		end
		else
		begin
			layer1_result_output=`LAYER1_OUTPUT_LENGTH'd0;
		end
	end
	
*/
endmodule
