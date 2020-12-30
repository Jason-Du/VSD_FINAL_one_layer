`include "./layer1_cnn_rtl.sv"
`timescale 1ns/10ps
module top_cnn(
	clk,
	rst,
	cnndonesignal
	);
	localparam  WEIGHT_NUM=16'd72;
	localparam  BIAS_NUM=16'd8;
	localparam  PIXEL_NUM=16'd1024;
	input clk;
	input rst;
	logic 	[47:0]pixel_data;
	logic	[47:0]weight_data;
	logic	[15:0] bias_data;
	/*
	logic	weight_set_done;
	logic	bias_set_done;
	logic   pixel_set_done;
	*/
	logic        save_enable;
	logic [15:0] output_row;
	logic [15:0] output_col;
	logic        layer1_calculation_done;
	logic [127:0]output_data;
	logic [15:0] weight_count_data;
	logic        weight_count_clear;
	logic        weight_count_keep;
	logic [15:0] bias_count_data;
	logic        bias_count_clear;
	logic        bias_count_keep;
	logic [15:0] pixel_count_data;
	logic        pixel_count_clear;
	logic        pixel_count_keep;
	logic [15:0] save_count_data;
	logic        save_count_clear;
	logic        save_count_keep;
	logic        weight_set_done_register_out;
	logic        bias_set_done_register_out;
	logic        pixel_set_done_register_out;
	logic        weight_store_done;
	logic        bias_store_done;

	output logic cnndonesignal;

	logic [47:0]mem_pixel_in[32][32];
	logic [47:0]mem_weight_in[72];
	logic [15:0]mem_bias_in[8];
	logic [127:0]mem_result[30][30];
	logic [127:0]mem_result_in[30][30];
	
	logic [15:0] read_bias_addr;
	logic        read_bias_signal;
	logic [15:0] read_weight_addr;
	logic        read_weight_signal;
	
	
	
	logic        read_pixel_signal;
	logic [15:0] read_pixel_address;

	counter weight_set_counter(
		.clk(clk),
		.rst(rst),
		.count(weight_count_data),
		.clear(1'b0),
		.keep(1'b0)
	);
	counter bias_set_counter(
		.clk(clk),
		.rst(rst),
		.count(bias_count_data),
		.clear(1'b0),
		.keep(1'b0)
	);
	counter pixel_set_counter(
		.clk(clk),
		.rst(rst),
		.count(pixel_count_data),
		.clear(pixel_count_clear),
		.keep(1'b0)
	);
	/*
	counter save_result_counter(
		.clk(clk),
		.rst(rst),
		.count(save_count_data),
		.clear(save_count_clear),
		.keep(1'b0)
	);
	logic [5:0] row_register_in;
	logic [5:0] row_register_out;
*/
	logic pixel_store_done;
	always_comb
	begin
		weight_data    =read_weight_signal?mem_weight_in[read_weight_addr]:48'd0;
		bias_data      =read_bias_signal?mem_bias_in[read_bias_addr]:16'd0;
		pixel_data     =read_pixel_signal?mem_pixel_in[read_pixel_address[9:5]][read_pixel_address[4:0]]:48'd0;
		//pixel_count_data[4:0]
		
		if (save_enable)
		begin
			mem_result_in[output_row][output_col]=output_data;
		end
		else
		begin
			mem_result_in[output_row][output_col]=mem_result[output_row][output_col];
		end
		pixel_count_clear=(weight_count_data>16'd72)? 1'b0:1'b1;
		pixel_store_done =(weight_count_data==16'd72)?1'b1:1'b0;
		
		bias_store_done  =(weight_count_data==16'd10)?1'b1:1'b0;
		weight_store_done  =(weight_count_data==16'd10)?1'b1:1'b0;
		/*
		mem_result[row_register_out][save_count_data] =output_data;
		weight_set_done=(weight_count_data==WEIGHT_NUM)?1'b1:weight_set_done_register_out;
		bias_set_done  =(bias_count_data==BIAS_NUM)?1'b1:bias_set_done_register_out;
		pixel_set_done =(pixel_count_data==PIXEL_NUM)?1'b1:pixel_set_done_register_out;
		save_count_clear=~pixel_set_done;
		*/

		//cnndonesignal  =(pixel_count_data==(PIXEL_NUM)*2)?1'b1:1'b0;
		
		/*
		save_count_clear=(pixel_set_done)?((save_count_data==6'd29)?1'b1:1'b0):1'b1;
		row_register_in=(save_count_data==6'd29)?row_register_out+6'd1:row_register_out;
		*/
	end

	always_ff@(posedge clk or rst)
	begin
		if(rst)
		begin
		/*
			weight_set_done_register_out<=1'b0;
			bias_set_done_register_out<=1'b0;
			pixel_set_done_register_out<=1'b0;
			
			row_register_out<=6'd0;
			*/
			cnndonesignal<=1'b0;
			for (int i=0;i<=30;i++)
			begin
				for (int j=0;j<=30;j++)
				begin
					mem_result[i][j]=128'd0;
				end
			end
		end
		else
		begin
		/*	
			weight_set_done_register_out<=weight_set_done;
			bias_set_done_register_out<=bias_set_done;
			pixel_set_done_register_out<=pixel_set_done;
			row_register_out<=row_register_in;
			*/
			cnndonesignal<=layer1_calculation_done;
			for (int i=0;i<=30;i++)
			begin
				for (int j=0;j<=30;j++)
				begin
					mem_result[i][j]=mem_result_in[i][j];
				end
			end
		end
	end
	/*
	layer1_cnn LAYER1_CNN(
		.clk(clk),
		.rst(rst),
		.input_data(pixel_data),

		.weight_data(weight_data),
		.bias_data(bias_data),
		.weight_set_done(weight_set_done),
		.bias_set_done(bias_set_done),
		
		.output_data(output_data)
	);
	*/

	
	layer1_cnn LAYER1_CNN(
	.clk(clk),
	.rst(rst),
	.input_data(pixel_data),
	.weight_data(weight_data),
	.bias_data(bias_data),
	.weight_store_done(weight_store_done),
	.bias_store_done(bias_store_done),
	.pixel_store_done(pixel_store_done),
	
	.save_enable(save_enable),
	.output_row(output_row),
	.output_col(output_col),
	.layer1_calculation_done(layer1_calculation_done),
	.output_data(output_data),
	.read_pixel_addr(read_pixel_address),
	.read_pixel_signal(read_pixel_signal),
	.read_weight_addr(read_weight_addr),
	.read_weight_signal(read_weight_signal),
	.read_bias_addr(read_bias_addr),
	.read_bias_signal(read_bias_signal)
);
endmodule