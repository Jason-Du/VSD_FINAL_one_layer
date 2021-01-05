`timescale 1ns/10ps
module fc_layer(
	clk,
	rst,
	input_data,//128
	weight_data,//128
	bias_data,//16
	
	weight_store_done,
	bias_store_done,
	pixel_store_done,
	//IN OUT PORT
	save_enable,
	//output_row,
	//output_col,
	output_addr//16
	
	layer1_calculation_done,
	output_data,//160
	//fix
	//read_pixel_addr,
	read_col_addr,//16
	read_row_addr,//16
	//fix
	read_pixel_signal,
	//read_weights_buffer_num_sel,
	read_weight_addr,//16 count to 250 finish set
	read_weight_signal,
	read_bias_addr,//16 count to 10 finish set
	read_bias_signal
);