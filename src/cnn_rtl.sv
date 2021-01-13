`include "controller_rtl.sv"
`include "layer1_cnn_rtl.sv"
`include "layer2_cnn_rtl.sv"
`include "layer3_maxpooling_rtl.sv"
`include "layer3_maxpooling_v2_rtl.sv"
`include "layer4_cnn_rtl.sv"
`include "layer5_cnn_rtl.sv"
`include "layer6_maxpooling_rtl.sv"
`include "layer6_maxpooling_v2_rtl.sv"
`include "layer7_fc_rtl.sv"
`include "weight_bias_arbitor_rtl.sv"
`include "layer7_write_mem_arbitor_rtl.sv"
`include "image_set_register_rtl.sv"
`include "interrupt_register_rtl.sv"
`include "local_mem_bias_rtl.sv"
`include "local_mem_pixel_rtl.sv"
`include "local_mem_weight_rtl.sv"
`include "layer7_local_mem_weight_rtl.sv"
`include "layer1_result_mem_rtl.sv"
`include "layer2_result_mem_rtl.sv"
`include "layer2_result_one_side_mem_rtl.sv"
`include "layer3_result_mem_rtl.sv"
`include "layer4_result_mem_rtl.sv"
`include "layer5_result_mem_rtl.sv"
`include "layer5_result_one_side_mem_rtl.sv"
`include "layer5_result_one_side_mem_v2_rtl.sv"
`include "layer6_result_mem_rtl.sv"
`include "local_mem_result_rtl.sv"

`timescale 1ns/10ps
module cnn(
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
////////////////////////////////////// CONTROLLER
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
logic [2:0] layer7_weight_mem_sel;
logic [4:0] layer_weight_sel;
logic [4:0] layer_bias_sel;
logic layer2_weight_store_done;
logic layer2_bias_store_done;
logic layer4_weight_store_done;
logic layer4_bias_store_done;
logic layer5_weight_store_done;
logic layer5_bias_store_done;
logic layer7_weight_store_done;
logic layer7_bias_store_done;

logic [3:0]weight_fsm_cs;
//////////////////////////////////////CONTROLLER
logic        write_bias_mem_signal;
logic [15:0] write_bias_mem_data;
logic [15:0] write_bias_mem_addr;
logic        write_weight_mem_signal;
logic        write_layer7_weight_mem;
logic [15:0] write_weight_mem_data;
logic [15:0] write_weight_mem_addr;

logic        write_pixel_mem_signal;
logic [15:0] write_pixel_mem_data;
logic [15:0] write_pixel_mem_addr;

///////////////////////////////////ARBITOR
logic        read_weight_signal_data;
logic [15:0] read_weight_addr_data;
logic        read_bias_signal_data;
logic [15:0] read_bias_addr_data;
logic [ 47:0] read_pixel_data;
logic [`MAXIMUM_OUTPUT_LENGTH-1:0] read_weight_data;
logic [ 15:0] read_bias_data;
//////////////////////////////////ARBITOR

logic [`LAYER1_OUTPUT_LENGTH-1:0] layer1_result;
logic layer1_save_enable;
logic [ 15:0] layer1_save_col;
logic [ 15:0] layer1_save_row;
logic [`LAYER1_OUTPUT_LENGTH-1:0] layer1_output_data;
logic        layer1_calculation_done;
logic        pipeline_layer1_calculation_done;
logic [15:0] layer1_read_row;
logic [15:0] layer1_read_col;
logic        layer1_read_weight_signal;
logic        layer1_read_bias_signal;
logic        read_pixel_signal;
logic [15:0] layer1_read_weight_addr;
logic [15:0] layer1_read_bias_addr;
logic [15:0] read_pixel_addr;


logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result;
logic         layer2_save_enable;
logic [ 15:0] layer2_save_row;
logic [ 15:0] layer2_save_col;
logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_output_data;
logic         layer2_calculation_done;
logic         pipeline_layer2_calculation_done;
logic [ 15:0] layer2_read_row;
logic [ 15:0] layer2_read_col;
logic         layer2_read_bias_signal;
logic         layer2_read_weight_signal;
logic         layer1_result_read_signal;
logic [ 15:0] layer2_read_weight_addr;
logic [ 15:0] layer2_read_bias_addr;



logic [`LAYER3_OUTPUT_LENGTH-1:0] layer3_result;
logic         layer3_save_enable;
logic [ 15:0] layer3_save_row;
logic [ 15:0] layer3_save_col;
logic [`LAYER3_OUTPUT_LENGTH-1:0] layer3_output_data;
logic         layer3_calculation_done;
logic         pipeline_layer3_calculation_done;
logic [ 15:0] layer3_read_row;
logic [ 15:0] layer3_read_col;
logic         layer3_read_bias_signal;
logic         layer3_read_weight_signal;
logic         layer2_result_read_signal;
logic [ 15:0] layer3_read_weight_addr;
logic [ 15:0] layer3_read_bias_addr;


logic [`LAYER4_OUTPUT_LENGTH-1:0] layer4_result;
logic         layer4_save_enable;
logic [ 15:0] layer4_save_row;
logic [ 15:0] layer4_save_col;
logic [`LAYER4_OUTPUT_LENGTH-1:0] layer4_output_data;
logic         layer4_calculation_done;
logic         pipeline_layer4_calculation_done;
logic [ 15:0] layer4_read_row;
logic [ 15:0] layer4_read_col;
logic         layer4_read_bias_signal;
logic         layer4_read_weight_signal;
logic         layer3_result_read_signal;
logic [ 15:0] layer4_read_weight_addr;
logic [ 15:0] layer4_read_bias_addr;

logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_result;
logic         layer5_save_enable;
logic [ 15:0] layer5_save_row;
logic [ 15:0] layer5_save_col;
logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_output_data;
logic         layer5_calculation_done;
logic         pipeline_layer5_calculation_done;
logic [ 15:0] layer5_read_row;
logic [ 15:0] layer5_read_col;
logic         layer5_read_bias_signal;
logic         layer5_read_weight_signal;
logic         layer4_result_read_signal;
logic [ 15:0] layer5_read_weight_addr;
logic [ 15:0] layer5_read_bias_addr;


logic [`LAYER6_OUTPUT_LENGTH-1:0] layer6_result;
logic         layer6_save_enable;
logic [ 15:0] layer6_save_row;
logic [ 15:0] layer6_save_col;
logic [`LAYER6_OUTPUT_LENGTH-1:0] layer6_output_data;
logic         layer6_calculation_done;
logic         pipeline_layer6_calculation_done;
logic [ 15:0] layer6_read_row;
logic [ 15:0] layer6_read_col;
logic         layer6_read_bias_signal;
logic         layer6_read_weight_signal;
logic         layer5_result_read_signal;
logic [ 15:0] layer6_read_weight_addr;
logic [ 15:0] layer6_read_bias_addr;


logic [`LAYER7_OUTPUT_LENGTH-1:0] layer7_result;
logic         layer7_save_enable;
logic [ 15:0] layer7_save_row;
logic [ 15:0] layer7_save_col;
logic [`LAYER7_OUTPUT_LENGTH-1:0] layer7_output_data;
logic         layer7_calculation_done;
logic         pipeline_layer7_calculation_done;
logic [ 15:0] layer7_read_row;
logic [ 15:0] layer7_read_col;
logic         layer7_read_bias_signal;
logic         layer7_read_weight_signal;
logic         layer6_result_read_signal;
logic [ 15:0] layer7_read_weight_addr;
logic [ 15:0] layer7_read_bias_addr;

logic layer7_mem1_write;
logic layer7_mem2_write;
logic layer7_mem3_write;
logic layer7_mem4_write;
logic layer7_mem5_write;
logic [127:0] read_weight_data_channel2;
logic [127:0] read_weight_data_channel3;
logic [127:0] read_weight_data_channel4;
logic [127:0] read_weight_data_channel5;
logic [127:0] read_weight_data_channel6;
logic [127:0] read_weight_data_channel7;
logic [127:0] read_weight_data_channel8;
logic [127:0] read_weight_data_channel9;
logic [127:0] read_weight_data_channel10;
//RESULT
logic write_result_signal;
logic read_result_signal;


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
	
	.layer4_weight_store_done(layer4_weight_store_done),
	.layer4_bias_store_done(layer4_bias_store_done),
	
	.layer5_weight_store_done(layer5_weight_store_done),
	.layer5_bias_store_done(layer5_bias_store_done),
	
	.layer7_weight_store_done(layer7_weight_store_done),
	.layer7_bias_store_done(layer7_bias_store_done),
	
	.layer_weight_sel(layer_weight_sel),
	.layer7_weight_mem_sel(layer7_weight_mem_sel),
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
	.write_layer7_weight_mem(write_layer7_weight_mem),
	.weight_mem_addr(write_weight_mem_addr),
	.weight_mem_data(write_weight_mem_data),
	.weight_fsm_cs(weight_fsm_cs),
	
	
	//read_bias_mem(),
	.write_bias_mem(write_bias_mem_signal),
	.bias_mem_addr(write_bias_mem_addr),
	.bias_mem_data(write_bias_mem_data)
);


layer7_write_mem_arbitor layer7_warb(
	.layer7_write_sel(layer7_weight_mem_sel),
	.layer7_write_signal(write_layer7_weight_mem),
	
	.layer7_mem1_write(layer7_mem1_write),
	.layer7_mem2_write(layer7_mem2_write),
	.layer7_mem3_write(layer7_mem3_write),
	.layer7_mem4_write(layer7_mem4_write),
	.layer7_mem5_write(layer7_mem5_write)
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
	read_pixel_addr={layer1_read_row[10:0],layer1_read_col[4:0]};
	//read_pixel_addr={layer1_read_col[10:0],layer1_read_row[4:0]};
	interrupt_register_data_in=layer7_calculation_done?1'b1:1'b0;
	interrupt_register_write_signal=(layer7_calculation_done||cpu_interrupt_register_write_signal)?1'b1:1'b0;
end


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
	.read_weight_addr1(read_weight_addr_data),
	.read_weight_addr2(read_weight_addr_data),
	.read_weight_signal(read_weight_signal_data),
	.buffer_num_sel(layer_weight_sel),
	
	.write_weight_addr(write_weight_mem_addr),
	.write_weight_data(write_weight_mem_data),
	.write_weight_signal(write_weight_mem_signal||layer7_mem1_write),
	.layer7_read_weight_signal(layer7_read_weight_signal),
	.weight_fsm_cs(weight_fsm_cs),
	.weight_store_done(layer1_weight_store_done||layer2_weight_store_done||layer4_weight_store_done||layer5_weight_store_done),
	//
	
	.read_weight_data1(read_weight_data),
	.read_weight_data2(read_weight_data_channel2)

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

layer7_local_mem_weight layer7_channel3_4_mem(
	.clk(clk),
	.rst(rst),
	.read_weight_signal(layer7_read_weight_signal),
	.read_weight_addr1(read_weight_addr_data),
	.read_weight_addr2(read_weight_addr_data),
	
	.write_weight_data(write_weight_mem_data),
	.write_weight_signal(layer7_mem2_write),
	.write_weight_addr(write_weight_mem_addr),

	//IN OUT
	
	.read_weight_data1(read_weight_data_channel3),
	.read_weight_data2(read_weight_data_channel4)
);
layer7_local_mem_weight layer7_channel5_6_mem(
	.clk(clk),
	.rst(rst),
	.read_weight_signal(layer7_read_weight_signal),
	.read_weight_addr1(read_weight_addr_data),
	.read_weight_addr2(read_weight_addr_data),
	
	.write_weight_data(write_weight_mem_data),
	.write_weight_signal(layer7_mem3_write),
	.write_weight_addr(write_weight_mem_addr),
	//IN OUT
	
	.read_weight_data1(read_weight_data_channel5),
	.read_weight_data2(read_weight_data_channel6)
);
layer7_local_mem_weight layer7_channel7_8_mem(
	.clk(clk),
	.rst(rst),
	.read_weight_signal(layer7_read_weight_signal),
	.read_weight_addr1(read_weight_addr_data),
	.read_weight_addr2(read_weight_addr_data),
	
	.write_weight_data(write_weight_mem_data),
	.write_weight_signal(layer7_mem4_write),
	.write_weight_addr(write_weight_mem_addr),
	//IN OUT
	
	.read_weight_data1(read_weight_data_channel7),
	.read_weight_data2(read_weight_data_channel8)
);
layer7_local_mem_weight layer7_channel9_10_mem(
	.clk(clk),
	.rst(rst),
	.read_weight_signal(layer7_read_weight_signal),
	.read_weight_addr1(read_weight_addr_data),
	.read_weight_addr2(read_weight_addr_data),
	
	.write_weight_data(write_weight_mem_data),
	.write_weight_signal(layer7_mem5_write),
	.write_weight_addr(write_weight_mem_addr),
	//IN OUT
	
	.read_weight_data1(read_weight_data_channel9),
	.read_weight_data2(read_weight_data_channel10)
);




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
	.pipeline_layer1_calculation_done(pipeline_layer1_calculation_done),
	.output_data(layer1_output_data),
	//fix
	//read_pixel_addr,
	.read_col_addr(layer1_read_col),
	.read_row_addr(layer1_read_row),
	//fix
	.read_pixel_signal(read_pixel_signal),
	//.read_weights_buffer_num_sel(),
	.read_weight_addr(layer1_read_weight_addr),
	.read_weight_signal(layer1_read_weight_signal),
	.read_bias_addr(layer1_read_bias_addr),
	.read_bias_signal(layer1_read_bias_signal)
);


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
	.layer4_read_weight_signal(layer4_read_weight_signal),
	.layer4_read_bias_signal(layer4_read_bias_signal),
	.layer4_read_weight_addr(layer4_read_weight_addr),
	.layer4_read_bias_addr(layer4_read_bias_addr),
	.layer5_read_weight_signal(layer5_read_weight_signal),
	.layer5_read_bias_signal(layer5_read_bias_signal),
	.layer5_read_weight_addr(layer5_read_weight_addr),
	.layer5_read_bias_addr(layer5_read_bias_addr),
	.layer7_read_weight_signal(layer7_read_weight_signal),
	.layer7_read_bias_signal(layer7_read_bias_signal),
	.layer7_read_weight_addr(layer7_read_weight_addr),
	.layer7_read_bias_addr(layer7_read_bias_addr),
	
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
	//.pixel_store_done(layer1_calculation_done),
	.pixel_store_done(pipeline_layer1_calculation_done),
	//IN OUT PORT
	.save_enable(layer2_save_enable),
	.output_row(layer2_save_row),
	.output_col(layer2_save_col),
	.layer2_calculation_done(layer2_calculation_done),
	.pipeline_layer2_calculation_done(pipeline_layer2_calculation_done),
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
logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result_even_even;
logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result_even_odd;
logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result_odd_odd;
logic [`LAYER2_OUTPUT_LENGTH-1:0] layer2_result_odd_even;
logic layer2_even_even_save_enable;
logic layer2_even_odd_save_enable;
logic layer2_odd_odd_save_enable;
logic layer2_odd_even_save_enable;
always_comb
begin
	layer2_even_even_save_enable=layer2_save_enable?(layer2_save_row[0]==1'b0&&layer2_save_col[0]==1'b0)?1'b1:1'b0:1'b0;
	layer2_even_odd_save_enable=layer2_save_enable?(layer2_save_row[0]==1'b0&&layer2_save_col[0]==1'b1)?1'b1:1'b0:1'b0;
	layer2_odd_even_save_enable=layer2_save_enable?(layer2_save_row[0]==1'b1&&layer2_save_col[0]==1'b0)?1'b1:1'b0:1'b0;
	layer2_odd_odd_save_enable=layer2_save_enable?(layer2_save_row[0]==1'b1&&layer2_save_col[0]==1'b1)?1'b1:1'b0:1'b0;
end



/////////////////////////////////

layer2_result_one_side_mem layer2_data_mem_even_even(
	.clk(clk),
	.rst(rst),
	.save_enable(layer2_even_even_save_enable),
	.layer2_result_store_data_in(layer2_output_data),
	.save_row_addr(layer2_save_row>>1),
	.save_col_addr(layer2_save_col>>1),
	.read_row_addr(layer3_read_row),
	.read_col_addr(layer3_read_col),
	.layer2_result_read_signal(layer2_result_read_signal),
	//INOUT
	.layer2_result_output(layer2_result_even_even)	
);
layer2_result_one_side_mem layer2_data_mem_even_odd(
	.clk(clk),
	.rst(rst),
	.save_enable(layer2_even_odd_save_enable),
	.layer2_result_store_data_in(layer2_output_data),
	.save_row_addr(layer2_save_row>>1),
	.save_col_addr(layer2_save_col>>1),
	.read_row_addr(layer3_read_row),
	.read_col_addr(layer3_read_col),
	.layer2_result_read_signal(layer2_result_read_signal),
	//INOUT
	.layer2_result_output(layer2_result_even_odd)	
);
layer2_result_one_side_mem layer2_data_mem_odd_even(
	.clk(clk),
	.rst(rst),
	.save_enable(layer2_odd_even_save_enable),
	.layer2_result_store_data_in(layer2_output_data),
	.save_row_addr(layer2_save_row>>1),
	.save_col_addr(layer2_save_col>>1),
	.read_row_addr(layer3_read_row),
	.read_col_addr(layer3_read_col),
	.layer2_result_read_signal(layer2_result_read_signal),
	//INOUT
	.layer2_result_output(layer2_result_odd_even)	
);

layer2_result_one_side_mem layer2_data_mem_odd_odd(
	.clk(clk),
	.rst(rst),
	.save_enable(layer2_odd_odd_save_enable),
	.layer2_result_store_data_in(layer2_output_data),
	.save_row_addr(layer2_save_row>>1),
	.save_col_addr(layer2_save_col>>1),
	.read_row_addr(layer3_read_row),
	.read_col_addr(layer3_read_col),
	.layer2_result_read_signal(layer2_result_read_signal),
	//INOUT
	.layer2_result_output(layer2_result_odd_odd)	
);

/*
layer2_result_mem layer2_data_mem(
	.clk(clk),
	.rst(rst),
	.save_enable(layer2_save_enable),
	.layer2_result_store_data_in(layer2_output_data),
	.save_row_addr(layer2_save_row),
	.save_col_addr(layer2_save_col),
	.read_row_addr(layer3_read_row),
	.read_col_addr(layer3_read_col),
	.layer2_result_read_signal(layer2_result_read_signal),
	//INOUT
	
	.layer2_result_output(layer2_result)
);

layer3_maxpooling layer3(
	.clk(clk),
	.rst(rst),
	.input_data(layer2_result),
	
	.pixel_store_done(pipeline_layer2_calculation_done),
	//IN OUT PORT
	.save_enable(layer3_save_enable),
	.output_row(layer3_save_row),
	.output_col(layer3_save_col),
	
	.layer3_calculation_done(layer3_calculation_done),
	.pipeline_layer3_calculation_done(pipeline_layer3_calculation_done),
	.output_data(layer3_output_data),
	//fix
	//read_pixel_addr,
	.read_col_addr(layer3_read_col),
	.read_row_addr(layer3_read_row),
	//fix
	.read_pixel_signal(layer2_result_read_signal)
);
*/

layer3_maxpooling_v2 layer3(
	.clk(clk),
	.rst(rst),
	.input_data_even_even(layer2_result_even_even),
	.input_data_even_odd(layer2_result_even_odd),
	.input_data_odd_even(layer2_result_odd_even),
	.input_data_odd_odd(layer2_result_odd_odd),
	
	
	.pixel_store_done(pipeline_layer2_calculation_done),
	//IN OUT PORT
	.save_enable(layer3_save_enable),
	.output_row(layer3_save_row),
	.output_col(layer3_save_col),
	
	.layer3_calculation_done(layer3_calculation_done),
	.pipeline_layer3_calculation_done(pipeline_layer3_calculation_done),
	.output_data(layer3_output_data),
	//fix
	//read_pixel_addr,
	.read_col_addr(layer3_read_col),
	.read_row_addr(layer3_read_row),
	//fix
	.read_pixel_signal(layer2_result_read_signal)
);

layer3_result_mem layer3_data_mem(
	.clk(clk),
	.rst(rst),
	.save_enable(layer3_save_enable),
	.layer3_result_store_data_in(layer3_output_data),
	.save_row_addr(layer3_save_row),
	.save_col_addr(layer3_save_col),
	.read_row_addr(layer4_read_row),
	.read_col_addr(layer4_read_col),
	.layer3_result_read_signal(layer3_result_read_signal),
	//INOUT
	
	.layer3_result_output(layer3_result)
);

layer4_cnn layer4(
	.clk(clk),
	.rst(rst),
	.input_data(layer3_result),
	.weight_data(read_weight_data),
	.bias_data(read_bias_data),
	
	.weight_store_done(layer4_weight_store_done),
	.bias_store_done(layer4_bias_store_done),
	.pixel_store_done(pipeline_layer3_calculation_done),
	//IN OUT PORT
	.save_enable(layer4_save_enable),
	.output_row(layer4_save_row),
	.output_col(layer4_save_col),
	
	.layer4_calculation_done(layer4_calculation_done),
	.pipeline_layer4_calculation_done(pipeline_layer4_calculation_done),
	.output_data(layer4_output_data),
	//fix
	//read_pixel_addr(),
	.read_col_addr(layer4_read_col),
	.read_row_addr(layer4_read_row),
	//fix
	.read_pixel_signal(layer3_result_read_signal),
	//read_weights_buffer_num_sel(),
	.read_weight_addr(layer4_read_weight_addr),
	.read_weight_signal(layer4_read_weight_signal),
	.read_bias_addr(layer4_read_bias_addr),
	.read_bias_signal(layer4_read_bias_signal)
	);

layer4_result_mem layer4_data_mem(
	.clk(clk),
	.rst(rst),
	.save_enable(layer4_save_enable),
	.layer4_result_store_data_in(layer4_output_data),
	.save_row_addr(layer4_save_row),
	.save_col_addr(layer4_save_col),
	.read_row_addr(layer5_read_row),
	.read_col_addr(layer5_read_col),
	.layer4_result_read_signal(layer4_result_read_signal),
	//INOUT
	
	.layer4_result_output(layer4_result)
);

layer5_cnn layer5(
	.clk(clk),
	.rst(rst),
	.input_data(layer4_result),
	.weight_data(read_weight_data),
	.bias_data(read_bias_data),
	
	.weight_store_done(layer5_weight_store_done),
	.bias_store_done(layer5_bias_store_done),
	.pixel_store_done(pipeline_layer4_calculation_done),
	//IN OUT PORT
	.save_enable(layer5_save_enable),
	.output_row(layer5_save_row),
	.output_col(layer5_save_col),
	
	.layer5_calculation_done(layer5_calculation_done),
	.pipeline_layer5_calculation_done(pipeline_layer5_calculation_done),
	.output_data(layer5_output_data),
	//fix
	//read_pixel_addr(),
	.read_col_addr(layer5_read_col),
	.read_row_addr(layer5_read_row),
	//fix
	.read_pixel_signal(layer4_result_read_signal),
	//read_weights_buffer_num_sel(),
	.read_weight_addr(layer5_read_weight_addr),
	.read_weight_signal(layer5_read_weight_signal),
	.read_bias_addr(layer5_read_bias_addr),
	.read_bias_signal(layer5_read_bias_signal)
	);
	
	
	
logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_result_even_even;
logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_result_even_odd;
logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_result_odd_odd;
logic [`LAYER5_OUTPUT_LENGTH-1:0] layer5_result_odd_even;
logic layer5_even_even_save_enable;
logic layer5_even_odd_save_enable;
logic layer5_odd_odd_save_enable;
logic layer5_odd_even_save_enable;
always_comb
begin
	layer5_even_even_save_enable=layer5_save_enable?(layer5_save_row[0]==1'b0&&layer5_save_col[0]==1'b0)?1'b1:1'b0:1'b0;
	layer5_even_odd_save_enable=layer5_save_enable?(layer5_save_row[0]==1'b0&&layer5_save_col[0]==1'b1)?1'b1:1'b0:1'b0;
	layer5_odd_even_save_enable=layer5_save_enable?(layer5_save_row[0]==1'b1&&layer5_save_col[0]==1'b0)?1'b1:1'b0:1'b0;
	layer5_odd_odd_save_enable=layer5_save_enable?(layer5_save_row[0]==1'b1&&layer5_save_col[0]==1'b1)?1'b1:1'b0:1'b0;
end



/////////////////////////////////
/*
layer5_result_one_side_mem_v2 layer5_data_mem_even(
	.clk(clk),
	.rst(rst),
	.save_enable1(layer5_even_even_save_enable),
	.save_enable2(layer5_even_odd_save_enable),
	.layer5_result_store_data_in(layer5_output_data),
	.save_row_addr(layer5_save_row>>1),
	.save_col_addr(layer5_save_col>>1),
	.read_row_addr(layer6_read_row),
	.read_col_addr(layer6_read_col),
	.layer5_result_read_signal1(layer5_result_read_signal),
	.layer5_result_read_signal2(layer5_result_read_signal),
	//INOUT
	
	.layer5_result_output1(layer5_result_even_even),
	.layer5_result_output2(layer5_result_even_odd)
);
layer5_result_one_side_mem_v2 layer5_data_mem_odd(
	.clk(clk),
	.rst(rst),
	.save_enable1(layer5_odd_even_save_enable),
	.save_enable2(layer5_odd_odd_save_enable),
	.layer5_result_store_data_in(layer5_output_data),
	.save_row_addr(layer5_save_row>>1),
	.save_col_addr(layer5_save_col>>1),
	.read_row_addr(layer6_read_row),
	.read_col_addr(layer6_read_col),
	.layer5_result_read_signal1(layer5_result_read_signal),
	.layer5_result_read_signal2(layer5_result_read_signal),
	//INOUT
	
	.layer5_result_output1(layer5_result_odd_even),
	.layer5_result_output2(layer5_result_odd_odd)
);
*/

layer5_result_one_side_mem layer5_data_mem_even_even(
	.clk(clk),
	.rst(rst),
	.save_enable(layer5_even_even_save_enable),
	.layer5_result_store_data_in(layer5_output_data),
	.save_row_addr(layer5_save_row>>1),
	.save_col_addr(layer5_save_col>>1),
	.read_row_addr(layer6_read_row),
	.read_col_addr(layer6_read_col),
	.layer5_result_read_signal(layer5_result_read_signal),
	//INOUT
	.layer5_result_output(layer5_result_even_even)	
);
layer5_result_one_side_mem layer5_data_mem_even_odd(
	.clk(clk),
	.rst(rst),
	.save_enable(layer5_even_odd_save_enable),
	.layer5_result_store_data_in(layer5_output_data),
	.save_row_addr(layer5_save_row>>1),
	.save_col_addr(layer5_save_col>>1),
	.read_row_addr(layer6_read_row),
	.read_col_addr(layer6_read_col),
	.layer5_result_read_signal(layer5_result_read_signal),
	//INOUT
	.layer5_result_output(layer5_result_even_odd)	
);
layer5_result_one_side_mem layer5_data_mem_odd_even(
	.clk(clk),
	.rst(rst),
	.save_enable(layer5_odd_even_save_enable),
	.layer5_result_store_data_in(layer5_output_data),
	.save_row_addr(layer5_save_row>>1),
	.save_col_addr(layer5_save_col>>1),
	.read_row_addr(layer6_read_row),
	.read_col_addr(layer6_read_col),
	.layer5_result_read_signal(layer5_result_read_signal),
	//INOUT
	.layer5_result_output(layer5_result_odd_even)	
);

layer5_result_one_side_mem layer5_data_mem_odd_odd(
	.clk(clk),
	.rst(rst),
	.save_enable(layer5_odd_odd_save_enable),
	.layer5_result_store_data_in(layer5_output_data),
	.save_row_addr(layer5_save_row>>1),
	.save_col_addr(layer5_save_col>>1),
	.read_row_addr(layer6_read_row),
	.read_col_addr(layer6_read_col),
	.layer5_result_read_signal(layer5_result_read_signal),
	//INOUT
	.layer5_result_output(layer5_result_odd_odd)	
);
/*
layer5_result_mem layer5_data_mem(
	.clk(clk),
	.rst(rst),
	.save_enable(layer5_save_enable),
	.layer5_result_store_data_in(layer5_output_data),
	.save_row_addr(layer5_save_row),
	.save_col_addr(layer5_save_col),
	.read_row_addr(layer6_read_row),
	.read_col_addr(layer6_read_col),
	.layer5_result_read_signal(layer5_result_read_signal),
	//INOUT
	
	.layer5_result_output(layer5_result)
);
*/
/*
layer6_maxpooling layer6(
	.clk(clk),
	.rst(rst),
	.input_data(layer5_result),
	
	.pixel_store_done(pipeline_layer5_calculation_done),
	//IN OUT PORT
	.save_enable(layer6_save_enable),
	.output_row(layer6_save_row),
	.output_col(layer6_save_col),
	
	.layer6_calculation_done(layer6_calculation_done),
	.output_data(layer6_output_data),
	//fix
	//read_pixel_addr,
	.read_col_addr(layer6_read_col),
	.read_row_addr(layer6_read_row),
	//fix
	.read_pixel_signal(layer5_result_read_signal)
);
*/
layer6_maxpooling_v2 layer6(
	.clk(clk),
	.rst(rst),
	.input_data_even_even(layer5_result_even_even),
	.input_data_even_odd(layer5_result_even_odd),
	.input_data_odd_even(layer5_result_odd_even),
	.input_data_odd_odd(layer5_result_odd_odd),
	
	
	.pixel_store_done(pipeline_layer5_calculation_done),
	//IN OUT PORT
	.save_enable(layer6_save_enable),
	.output_row(layer6_save_row),
	.output_col(layer6_save_col),
	
	.layer6_calculation_done(layer6_calculation_done),
	.pipeline_layer6_calculation_done(pipeline_layer6_calculation_done),
	.output_data(layer6_output_data),
	//fix
	//read_pixel_addr,
	.read_col_addr(layer6_read_col),
	.read_row_addr(layer6_read_row),
	//fix
	.read_pixel_signal(layer5_result_read_signal)

);
layer6_result_mem layer6_data_mem(
	.clk(clk),
	.rst(rst),
	.save_enable(layer6_save_enable),
	.layer6_result_store_data_in(layer6_output_data),
	.save_row_addr(layer6_save_row),
	.save_col_addr(layer6_save_col),
	.read_row_addr(layer7_read_row),
	.read_col_addr(layer7_read_col),
	.layer6_result_read_signal(layer6_result_read_signal),
	//INOUT
	
	.layer6_result_output(layer6_result)
);

layer7_fc layer7(
	.clk(clk),
	.rst(rst),
	.input_data(layer6_result),
	.weight_data_channel1(read_weight_data),
	.weight_data_channel2(read_weight_data_channel2),
	.weight_data_channel3(read_weight_data_channel3),
	.weight_data_channel4(read_weight_data_channel4),
	.weight_data_channel5(read_weight_data_channel5),
	.weight_data_channel6(read_weight_data_channel6),
	.weight_data_channel7(read_weight_data_channel7),
	.weight_data_channel8(read_weight_data_channel8),
	.weight_data_channel9(read_weight_data_channel9),
	.weight_data_channel10(read_weight_data_channel10),
	.bias_data(read_bias_data),
	
	.weight_store_done(1'b0),
	.bias_store_done(layer7_bias_store_done),
	.pixel_store_done(pipeline_layer6_calculation_done),
	//IN OUT PORT
	.save_enable(layer7_save_enable),
	
	.layer7_calculation_done(layer7_calculation_done),
	.output_data(layer7_output_data),
	//fix
	//read_pixel_addr(),
	.read_col_addr(layer7_read_col),
	.read_row_addr(layer7_read_row),
	//fix
	.read_pixel_signal(layer6_result_read_signal),
	//read_weights_buffer_num_sel(),
	.read_weight_addr(layer7_read_weight_addr),
	.read_weight_signal(layer7_read_weight_signal),
	.read_bias_addr(layer7_read_bias_addr),
	.read_bias_signal(layer7_read_bias_signal)
);


//__________________FINISH_____________________________
always_comb
begin
	//FIX
	//write_result_signal=layer2_calculation_done?1'b1:1'b0;
	read_result_signal=(araddr==32'hd000_0000)?1'b1:1'b0;
	//
end

local_mem_result result_st_mem(
	.clk(clk),
	.rst(rst),
	.read_result_signal(read_result_signal),
	.write_result_data(layer7_output_data),
	.write_result_signal(layer7_calculation_done),
	
	.read_result_data(rdata)
);
endmodule





