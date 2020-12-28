`timescale 1ns/10ps
module cnn_top(
	clk,
	rst,
	wvalid,
	awaddr,
);

controller ctrl(
	clk,
	rst,
	bus_write_signal,
	bus_read_signal,
	bus_write_data,
	image_set_register_data_output,
	araddr,
	awaddr,
	wvalid,
	//------------------------IN/OUT PORT
	//arready,
	//awready,
	
	image_set_register_data_in,
	image_set_register_write_signal,
	interrupr_rsgister_data_in,
	interrupr_rsgister_write_signal,
	
	layer1_weight_set_done,
	layer1_bias_set_done,
	layer1_pixel_set_done,
	//setdone signal
	
	read_pixel_mem,
	write_pixel_mem,
	pixel_mem_addr,
	pixel_mem_data,
	
	read_weight_mem,
	write_weight_mem,
	weight_mem_addr,
	weight_mem_data,
	
	
	read_bias_mem,
	write_bias_mem,
	bias_mem_addr,
	bias_mem_data,
	
	read_result_signal,
	write_result_signal
	
);
