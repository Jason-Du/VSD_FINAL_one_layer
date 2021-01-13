`timescale 1ns/10ps
`include"def.svh"
module layer5_result_one_side_mem_v2(
	clk,
	rst,
	save_enable1,
	save_enable2,
	layer5_result_store_data_in,
	save_row_addr,
	save_col_addr,
	read_row_addr,
	read_col_addr,
	layer5_result_read_signal1,
	layer5_result_read_signal2,
	//INOUT
	
	layer5_result_output1,
	layer5_result_output2
);
	input clk;
	input rst;

	input        save_enable1;
	input        save_enable2;
	input [`LAYER5_OUTPUT_LENGTH-1:0]layer5_result_store_data_in;
	input [ 15:0] 	save_row_addr;
	input [ 15:0] 	save_col_addr;
	input [ 15:0] 	read_row_addr;
	input [ 15:0] 	read_col_addr;
	input        layer5_result_read_signal1;
	input        layer5_result_read_signal2;
	//INOUT
	
	output logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_result_output1;
	output logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_result_output2;	
	logic [ 5:0]   read_addr_sram;
	logic [ 5:0]   save_addr_sram;
	logic [ 5:0]   address_a;
	logic [ 5:0]   address_b;
	
	logic [15:0]   read_addr_minus;
	logic [15:0]   read_addr_add;
	
	logic [15:0]   save_addr_add;
	logic [15:0]   save_addr_minus;
	logic [`LAYER4_OUTPUT_LENGTH-1:0] null_wire1;
	
	/*
	always_comb
	begin
		read_addr_add=(read_row_addr)<<2;
		read_addr_minus=(read_row_addr);
		read_addr_sram=read_addr_add[5:0]+read_col_addr[5:0]+read_addr_minus[5:0];
		save_addr_add=(save_row_addr)<<2;
		save_addr_minus=(save_row_addr);
		save_addr_sram=save_enable1?save_addr_add[5:0]+save_col_addr[5:0]+save_addr_minus[5:0]:save_addr_add[5:0]+save_col_addr[5:0]+save_addr_minus[5:0]+16'd25;
		
		address_a=layer5_result_read_signal1?read_addr_sram:save_addr_sram;
		address_b=layer5_result_read_signal2?read_addr_sram:save_addr_sram;
	end
	
layer6_wrapper layer5_st(
  .CK(~clk),
  .OEA(layer5_result_read_signal1),
  .OEB(layer5_result_read_signal2),
  .WEAN(~save_enable1),
  .WEBN(~save_enable2),
  .A(address_a),
  .B(address_b),
  .DOA(layer5_result_output1),
  .DOB(layer5_result_output2),
  .DIA(layer5_result_store_data_in),
  .DIB(layer5_result_store_data_in)
);
*/
	
	
	logic [`LAYER5_OUTPUT_LENGTH-1:0] layer2_results_mem    [`LAYER6_WIDTH][`LAYER6_WIDTH];
	logic [`LAYER5_OUTPUT_LENGTH-1:0] layer2_results_mem_in [`LAYER6_WIDTH][`LAYER6_WIDTH];
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=`LAYER6_WIDTH/2-1;i++)
			begin
				for(byte j=0;j<=`LAYER6_WIDTH/2-1;j++)
				begin
					layer2_results_mem[i][j]<=`LAYER5_OUTPUT_LENGTH'd0;
				end
			end
			
		end
			//WRITE
		else
		begin
			if(save_enable1||save_enable2)
			begin
				if(save_enable1)
				begin
					layer2_results_mem[save_row_addr][save_col_addr]<=layer5_result_store_data_in;
				end
				else
				begin
					layer2_results_mem[save_row_addr+16'd5][save_col_addr+16'd5]<=layer5_result_store_data_in;
				end
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
		if(layer5_result_read_signal1)
		begin
			layer5_result_output1=layer2_results_mem[read_row_addr][read_col_addr];
		end
		else
		begin
			layer5_result_output1=`LAYER5_OUTPUT_LENGTH'd0;
		end
	end
	always_comb
	begin
		if(layer5_result_read_signal2)
		begin
			layer5_result_output2=layer2_results_mem[read_row_addr+16'd5][read_col_addr+16'd5];
		end
		else
		begin
			layer5_result_output2=`LAYER5_OUTPUT_LENGTH'd0;
		end
	end
	
endmodule
