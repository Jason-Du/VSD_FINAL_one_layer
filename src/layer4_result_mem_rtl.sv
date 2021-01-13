`timescale 1ns/10ps
`include"def.svh"
`include "layer4_wrapper.sv"
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
	
	
	logic [ 7:0]   read_addr_sram;
	logic [ 7:0]   save_addr_sram;	
	logic [ 7:0]   read_addr_sram0;
	logic [ 7:0]   save_addr_sram0;
	
	logic [17:0]   read_addr_minus;
	logic [19:0]   read_addr_add;
	
	logic [19:0]   save_addr_add;
	logic [17:0]   save_addr_minus;
	logic [`LAYER4_OUTPUT_LENGTH-1:0] null_wire1;
	
	
	always_comb
	begin
		read_addr_add=(read_row_addr)<<4;
		read_addr_minus=(read_row_addr)<<2;
		read_addr_sram0=read_addr_add[7:0]+read_col_addr[7:0]-read_addr_minus[7:0];
		save_addr_add=(save_row_addr)<<4;
		save_addr_minus=(save_row_addr)<<2;
		save_addr_sram0=save_addr_add[7:0]+save_col_addr[7:0]-save_addr_minus[7:0];
		
		read_addr_sram=(read_addr_sram0==8'd144||read_addr_sram0==8'd145)?8'd0:read_addr_sram0;
		save_addr_sram=(save_addr_sram0==8'd144)?8'd0:save_addr_sram0;
		
	end

layer4_wrapper layer4_st(
  .CK(~clk),
  .OEA(1'b0),
  .OEB(layer4_result_read_signal),
  .WEAN(~save_enable),
  .WEBN(1'b1),
  .A(save_addr_sram),
  .B(read_addr_sram),
  .DOA(null_wire1),
  .DOB(layer4_result_output),
  .DIA(layer4_result_store_data_in),
  .DIB(128'd0)
);
	/*
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
	*/
endmodule
