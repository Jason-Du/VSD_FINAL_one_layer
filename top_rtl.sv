`include "controller_rtl.sv"
`include "layer1_cnn_rtl.sv"
`include "layer2_cnn_rtl.sv"
`include "weight_bias_arbitor_rtl.sv"
`include "image_set_register_rtl.sv"
`include "interrupt_register_rtl.sv"
`include "local_mem_bias_rtl.sv"
`include "local_mem_pixel_rtl.sv"
`include "local_mem_weight_rtl.sv"
`include "layer1_result_mem_rtl.sv"

`timescale 1ns/10ps
module top(
	clk,
	rst,
	araddr,
	arvalid,
	
	wdata,
	wvalid,
	
	awaddr,
	awvalid,
	//in out port
	rdata,
	interrupt_signal
);
input 	                  clk;
input 	                  rst;
input        [31:0]       araddr;
input    	              arvalid;
input        [31:0]       wdata;
input 	                  wvalid;
input        [31:0]       awaddr;
input                     awvalid;
	//in out port
output logic [31:0]	      rdata;
output logic              interrupt_signal;

logic [1:0] image_set_register_data_output;
logic [1:0] image_set_register_data_in;
logic image_set_register_write_signal;

logic cpu_interrupt_register_write_signal;
logic cpu_interrupt_register_data_in;
logic interrupt_register_write_signal;
logic interrupt_register_data_in;

logic layer1_input_store_done;
logic layer1_weight_store_done;
logic layer1_bias_store_done;
logic [4:0] layer_weight_sel;
logic [4:0] layer_bias_sel;
logic layer2_weight_store_done;
logic layer2_bias_store_done;

//////////////////////////////////////
logic        write_bias_mem_signal;
logic [15:0] write_bias_mem_data;
logic [15:0] write_bias_mem_addr;
logic        write_weight_mem_signal;
logic [15:0] write_weight_mem_data;
logic [15:0] write_weight_mem_addr;

logic        write_pixel_mem_signal;
logic [15:0] write_pixel_mem_data;
logic [15:0] write_pixel_mem_addr;

logic [ 47:0] read_pixel_data;
logic [127:0] read_weight_data;
logic [ 15:0] read_bias_data;


logic layer1_save_enable;
logic [ 15:0] layer1_save_col;
logic [ 15:0] layer1_save_row;
logic [127:0] layer1_output_data;


logic [15:0] read_pixel_addr;
logic [15:0] layer1_read_row;
logic [15:0] layer1_read_col;
logic read_pixel_signal;

logic        layer1_read_weight_signal;
logic        layer1_read_bias_signal;
logic [15:0] layer1_read_weight_addr;
logic [15:0] layer1_read_bias_addr;

logic        read_weight_signal_data;
logic [15:0] read_weight_addr_data;
logic        read_bias_signal_data;
logic [15:0] read_bias_addr_data;
logic        layer1_calculation_done;



logic [127:0] layer1_result;
logic         layer2_save_enable;
logic [ 15:0] layer2_save_row;
logic [ 15:0] layer2_save_col;
logic         layer2_calculation_done;
logic [127:0] layer2_output_data;
logic [ 15:0] layer2_read_row;
logic [ 15:0] layer2_read_col;
logic         layer1_result_read_signal;
logic [ 15:0] layer2_read_weight_addr;
logic         layer2_read_weight_signal;
logic [ 15:0] layer2_read_bias_addr;
logic         layer2_read_bias_signal;


controller ctlr(
	.clk(clk),
	.rst(rst),
	//bus_write_signal(),
	//bus_read_signal(),
	.image_set_register_data_output(image_set_register_data_output),
	.wdata(wdata),
	.wvalid(wvalid),
//	araddr(),
//	arvalid(),
	.awaddr(awaddr),
	.awvalid(awvalid),
	//------------------------IN/OUT PORT
	.layer1_input_store_done(layer1_input_store_done),
	.layer1_weight_store_done(layer1_weight_store_done),
	.layer1_bias_store_done(layer1_bias_store_done),
	
	.layer2_weight_store_done(layer2_weight_store_done),
	.layer2_bias_store_done(layer2_bias_store_done),
	
	
	.layer_weight_sel(layer_weight_sel),
	.layer_bias_sel(layer_bias_sel),
	
	.image_set_register_data_in(image_set_register_data_in),
	.image_set_register_write_signal(image_set_register_write_signal),
	.interrupt_register_data_in(cpu_interrupt_register_data_in),
	.interrupt_register_write_signal(cpu_interrupt_register_write_signal),
	
	
	//read_pixel_mem(),
	.write_pixel_mem(write_pixel_mem_signal),
	.pixel_mem_addr(write_pixel_mem_addr),
	.pixel_mem_data(write_pixel_mem_data),
	
	//read_weight_mem(),
	.write_weight_mem(write_weight_mem_signal),
	.weight_mem_addr(write_weight_mem_addr),
	.weight_mem_data(write_weight_mem_data),
	
	
	//read_bias_mem(),
	.write_bias_mem(write_bias_mem_signal),
	.bias_mem_addr(write_bias_mem_addr),
	.bias_mem_data(write_bias_mem_data)
);

 image_set_register imag_set_cod(
	.clk(clk),
	.rst(rst),
	.write_data(image_set_register_data_in),
	.write_signal(image_set_register_write_signal),
	
	.setting_done_condition(image_set_register_data_output)
);


interrupt_register interpt_reg(
	.clk(clk),
	.rst(rst),
	.write_signal(interrupt_register_write_signal),
	.write_data(interrupt_register_data_in),
	.interrupt_signal(interrupt_signal)
);


//------------------------------------STORING--------------// READING----------------------------//

always_comb
begin
	read_pixel_addr={layer1_read_col[10:0],layer1_read_row[4:0]};
	interrupt_register_data_in=layer1_calculation_done?1'b1:1'b0;
	interrupt_register_write_signal=layer1_calculation_done?1'b1:1'b0;;
end
/*
local_mem_bias bias_st_mem(
	.clk(clk),
	.rst(rst),
	
	.write_bias_addr(write_bias_mem_addr),
	.write_bias_data(write_bias_mem_data),
	.write_bias_signal(write_bias_mem_signal),
	
	.read_bias_addr(read_bias_addr_data),
	.read_bias_data(read_bias_data),
	//
	.read_bias_signal(read_bias_signal_data)

);

local_mem_weight weight_st_mem(
	.clk(clk),
	.rst(rst),
	.read_weight_addr(read_weight_addr_data),
	.read_weight_signal(read_weight_signal_data),
	.buffer_num_sel(layer_weight_sel),
	
	.write_weight_addr(write_weight_mem_addr),
	.write_weight_data(write_weight_mem_data),
	.write_weight_signal(write_weight_mem_signal),
	//
	
	.read_weight_data(read_weight_data)

);

local_mem_pixel pixel_st_mem(
	.clk(clk),
	.rst(rst),
	.read_pixel_addr(read_pixel_addr),
	.read_pixel_signal(read_pixel_signal),
	
	
	.write_pixel_data(write_pixel_mem_data),
	.write_pixel_addr(write_pixel_mem_addr),
	.write_pixel_signal(write_pixel_mem_signal),
	
	.read_pixel_data(read_pixel_data)

);
*/

layer1_cnn layer1(
	.clk(clk),
	.rst(rst),
	.input_data(read_pixel_data),
	.weight_data(read_weight_data[47:0]),
	.bias_data(read_bias_data),
	
	.weight_store_done(layer1_weight_store_done),
	.bias_store_done(layer1_bias_store_done),
	.pixel_store_done(layer1_input_store_done),
	//IN OUT PORT
	.save_enable(layer1_save_enable),
	.output_row(layer1_save_row),
	.output_col(layer1_save_col),
	
	.layer1_calculation_done(layer1_calculation_done),
	.output_data(layer1_output_data),
	//fix
	//read_pixel_addr,
	.read_col_addr(layer1_read_row),
	.read_row_addr(layer1_read_col),
	//fix
	.read_pixel_signal(read_pixel_signal),
	//.read_weights_buffer_num_sel(),
	.read_weight_addr(layer1_read_weight_addr),
	.read_weight_signal(layer1_read_weight_signal),
	.read_bias_addr(layer1_read_bias_addr),
	.read_bias_signal(layer1_read_bias_signal)
);

/*
layer1_result_mem layer1_data_mem(
	.clk(clk),
	.rst(rst),
	.save_enable(layer1_save_enable),
	.layer1_result_store_data_in(layer1_output_data),
	.save_row_addr(layer1_save_row),
	.save_col_addr(layer1_save_col),
	.read_row_addr(layer2_read_row),
	.read_col_addr(layer2_read_col),
	.layer1_result_read_signal(layer1_result_read_signal),
	//INOUT
	.layer1_result_output(layer1_result)
);

*/
weight_bias_arbitor wb_arbitor(
	.weight_sel(layer_weight_sel),
	.bias_sel(layer_bias_sel),
	.layer1_read_weight_signal(layer1_read_weight_signal),
	.layer2_read_weight_signal(layer2_read_weight_signal),
	.layer1_read_bias_signal(layer1_read_bias_signal),
	.layer2_read_bias_signal(layer2_read_bias_signal),
	.layer1_read_weight_addr(layer1_read_weight_addr),
	.layer2_read_weight_addr(layer2_read_weight_addr),
	.layer1_read_bias_addr(layer1_read_bias_addr),
	.layer2_read_bias_addr(layer2_read_bias_addr),
	//INOUT
	.read_weight_signal_data(read_weight_signal_data),
	.read_weight_addr_data(read_weight_addr_data),
	.read_bias_signal_data(read_bias_signal_data),
	.read_bias_addr_data(read_bias_addr_data)
);



layer2_cnn layer2(
	.clk(clk),
	.rst(rst),
	.input_data(layer1_result),
	.weight_data(read_weight_data),
	.bias_data(read_bias_data),
	
	.weight_store_done(layer2_weight_store_done),
	.bias_store_done(layer2_bias_store_done),
	.pixel_store_done(layer1_calculation_done),
	//IN OUT PORT
	.save_enable(layer2_save_enable),
	.output_row(layer2_save_row),
	.output_col(layer2_save_col),
	
	.layer2_calculation_done(layer2_calculation_done),
	.output_data(layer2_output_data),
	//fix
	//read_pixel_addr,
	.read_col_addr(layer2_read_col),
	.read_row_addr(layer2_read_row),
	//fix
	.read_pixel_signal(layer1_result_read_signal),
	//read_weights_buffer_num_sel(),
	.read_weight_addr(layer2_read_weight_addr),
	.read_weight_signal(layer2_read_weight_signal),
	.read_bias_addr(layer2_read_bias_addr),
	.read_bias_signal(layer2_read_bias_signal)
);








endmodule





