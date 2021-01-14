`timescale 1ns/10ps
//`include "channel8_tree_adder_rtl.sv"
`include "layer1_systolic_rtl.sv"
`include "stage29_fifo_rtl.sv"
//`include "counter_cnn_rtl.sv"
`include "def.svh"

module layer1_cnn(
	clk,
	rst,
	input_data,
	weight_data,
	bias_data,
	
	weight_store_done,
	bias_store_done,
	pixel_store_done,
	//IN OUT PORT
	save_enable,
	output_row,
	output_col,
	
	layer1_calculation_done,
	pipeline_layer1_calculation_done,
	output_data,
	//fix
	//read_pixel_addr,
	read_col_addr,
	read_row_addr,
	//fix
	read_pixel_signal,
	//read_weights_buffer_num_sel,
	read_weight_addr,
	read_weight_signal,
	read_bias_addr,
	read_bias_signal
);
	input                                           clk;
	input                                           rst;
	input                                           weight_store_done;
	input                                           bias_store_done;
	input                                           pixel_store_done;
	input        [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_data;
	input        [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] input_data;
	input        [                 `WORDLENGTH-1:0] bias_data;
	
	output logic                                    save_enable;
	output logic [                 `WORDLENGTH-1:0] output_row;
	output logic [                 `WORDLENGTH-1:0] output_col;
	output logic [       `LAYER1_OUTPUT_LENGTH-1:0] output_data;
	output logic                                    layer1_calculation_done;
	output logic                                    pipeline_layer1_calculation_done;
	
	//output logic  [                `WORDLENGTH-1:0] read_pixel_addr;
	output logic  [                `WORDLENGTH-1:0] read_col_addr;
	output logic  [                `WORDLENGTH-1:0] read_row_addr;
	output logic                                    read_pixel_signal;
	
	output logic  [                `WORDLENGTH-1:0] read_weight_addr;
	output logic                                    read_weight_signal;
	
	output logic  [                `WORDLENGTH-1:0] read_bias_addr;
	output logic                                    read_bias_signal;
	//output logic  [ 4:0] read_weights_buffer_num_sel;
	
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] buffer1_output;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] buffer2_output;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] buffer3_output;

	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_3_3_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_3_2_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_3_1_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_3_3_register_out;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_3_2_register_out;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_3_1_register_out;
	
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_2_3_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_2_2_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_2_1_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_2_3_register_out;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_2_2_register_out;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_2_1_register_out;

	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_1_3_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_1_2_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_1_1_register_in;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_1_3_register_out;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_1_2_register_out;
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] col_1_1_register_out;
	
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in1[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in2[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in3[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in4[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in5[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in6[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in7[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in8[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_in9[`LAYER1_OUTPUT_CHANNEL_NUM];
	
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out1[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out2[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out3[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out4[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out5[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out6[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out7[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out8[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [ `LAYER1_WEIGHT_INPUT_LENGTH-1:0] weight_register_out9[`LAYER1_OUTPUT_CHANNEL_NUM];
	
	logic  [`WORDLENGTH-1:0] bias_register_in [`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] bias_register_out[`LAYER1_OUTPUT_CHANNEL_NUM];
	
	logic  [`WORDLENGTH-1:0] systolic1_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic2_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic3_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic4_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic5_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic6_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic7_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic8_output[`LAYER1_OUTPUT_CHANNEL_NUM];
	logic  [`WORDLENGTH-1:0] systolic9_output[`LAYER1_OUTPUT_CHANNEL_NUM];


	//----------------------------SAVE ADDRESS SIGNAL CONTROL----------------------------//
	//set counter is also col counter
	localparam SAVE_IDLE=2'b00;
	localparam SAVE_SETTING=2'b01;
	localparam SAVE_ENABLE=2'b10;
	logic  [15:0] save_address_row_count;
	logic         save_address_row_clear;
	logic         save_address_row_keep;
	logic         pipeline_layer1_calculation_done_stage1;
	logic         pipeline_layer1_calculation_done_stage2;
	logic         pipeline_layer1_calculation_done_stage3;

	logic  [15:0] read_pixel_count;
	logic  read_pixel_clear;
	
	logic  [15:0] set_count;
	logic         set_clear;
	logic         set_keep;
	logic  [1:0]  save_cs;
	logic  [1:0]  save_ns;
	//fix 
	logic [15:0] read_pixel_row_count;
	logic        read_pixel_row_clear;
	logic        read_pixel_row_keep;
	//fix
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			save_cs<=SAVE_IDLE;
		end
		else
		begin
			save_cs<=save_ns;
		end
	end
	always_comb
	begin
		//read_pixel_addr=read_pixel_count;
		read_col_addr=read_pixel_count;
		read_row_addr=read_pixel_row_count;
		output_row=save_address_row_count;
		output_col=set_count;
		//read_weights_buffer_num_sel=5'd3;
		case(save_cs)
		SAVE_IDLE:
		begin
			save_address_row_keep=1'b1;
			layer1_calculation_done=1'b0;
			pipeline_layer1_calculation_done=1'b0;
			save_address_row_clear=1'b1;
			save_enable=1'b0;
			set_clear=1'b1;
			read_pixel_signal=1'b0;
			read_pixel_clear=1'b1;
			//keep
			read_pixel_row_clear=1'b1;
			read_pixel_row_keep=1'b1;
			//keep
			if(pixel_store_done)
			begin
				save_ns=SAVE_SETTING;
			end
			else
			begin
				save_ns=SAVE_IDLE;
			end
		end
		SAVE_SETTING:
		begin
			save_address_row_keep=1'b1;
			layer1_calculation_done=1'b0;
			pipeline_layer1_calculation_done=1'b0;
			save_address_row_clear=1'b1;
			read_pixel_signal=1'b1;
			save_enable=1'b0;
			//fix
			//read_pixel_clear=1'b0;
			read_pixel_row_clear=1'b0;
			if (read_pixel_count==`LAYER1_READ_PIXEL_COUNT_COL_END)
			begin
				read_pixel_clear=1'b1;
				read_pixel_row_keep=1'b0;
			end
			else
			begin
				read_pixel_clear=1'b0;
				read_pixel_row_keep=1'b1;
			end
			//fix
			if(set_count==`LAYER1_SET_COUNT)
			begin
				set_clear=1'b1;
				save_ns=SAVE_ENABLE;
			end
			else
			begin
				set_clear=1'b0;
				save_ns=SAVE_SETTING;
			end
		end
		SAVE_ENABLE:
		begin
			save_address_row_clear=1'b0;
			read_pixel_signal=1'b1;
			//fix
			//read_pixel_clear=1'b0;
			read_pixel_row_clear=1'b0;
			if (read_pixel_count==`LAYER1_READ_PIXEL_COUNT_COL_END)
			begin
				read_pixel_clear=1'b1;
				read_pixel_row_keep=1'b0;
			end
			else
			begin
				read_pixel_clear=1'b0;
				read_pixel_row_keep=1'b1;
			end
			//fix
			if(set_count==`LAYER1_READ_PIXEL_COUNT_COL_END)
			begin
				set_clear=1'b1;
				save_address_row_keep=1'b0;
			end
			else
			begin
				set_clear=1'b0;
				save_address_row_keep=1'b1;
			end
			if(save_address_row_count==`LAYER1_PIPELINE_ROW&&set_count==`LAYER1_PIPELINE_COL)
			begin
				pipeline_layer1_calculation_done=1'b1;
			end
			else
			begin
				pipeline_layer1_calculation_done=1'b0;
			end
			if(save_address_row_count==`LAYER1_BUFFER_LENGTH&&set_count==`LAYER1_BUFFER_LENGTH)
			begin
				save_ns=SAVE_IDLE;
				layer1_calculation_done=1'b1;
			end
			else
			begin
				save_ns=SAVE_ENABLE;
				layer1_calculation_done=1'b0;
			end
			
			if(set_count>`LAYER1_BUFFER_LENGTH)
			begin
				save_enable=1'b0;
			end
			else
			begin
				save_enable=1'b1;
			end
		end
		default:
		begin
			set_clear=1'b1;
			save_address_row_clear=1'b1;
			save_address_row_keep=1'b0;
			layer1_calculation_done=1'b0;
			pipeline_layer1_calculation_done=1'b0;
			save_enable=1'b0;
			save_ns=SAVE_IDLE;
			read_pixel_signal=1'b0;
			read_pixel_clear=1'b1;
			//fix
			read_pixel_row_clear=1'b1;
			read_pixel_row_keep=1'b0;
			//fix
		end
		endcase
	end
// fix

	counter_cnn read_col_counter(
	.clk(clk),
	.rst(rst),
	.count(read_pixel_row_count),
	.clear(read_pixel_row_clear),
	.keep(read_pixel_row_keep)
	);
// fix
	counter_cnn read_counter(
	.clk(clk),
	.rst(rst),
	.count(read_pixel_count),
	.clear(read_pixel_clear),
	.keep(1'b0)
	);
	
	counter_cnn set_counter(
	.clk(clk),
	.rst(rst),
	.count(set_count),
	.clear(set_clear),
	.keep(1'b0)
	);
	counter_cnn save_address_row(
	.clk(clk),
	.rst(rst),
	.count(save_address_row_count),
	.clear(save_address_row_clear),
	.keep(save_address_row_keep)
	);
	//----------------------------------------bias_SETTING-----------------------------------------------//
	localparam BIAS_IDLE=1'b0;
	localparam BIAS_SET=1'b1;
	logic      bias_cs;
	logic      bias_ns;
	logic      bias_set_done;
	logic [15:0] bias_set_count;
	logic        bias_set_clear;
	logic        bias_set_keep;
	logic [15:0] bias_read_count;
	logic        bias_read_clear;
	
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			bias_cs<=BIAS_IDLE;
		end
		else
		begin
			bias_cs<=bias_ns;
		end
	end
	always_comb
	begin
		read_bias_addr= bias_read_count;
		case(bias_cs)
		BIAS_IDLE:
		begin
			bias_set_keep=1'b0;
			bias_set_done=1'b0;

			if(bias_store_done)
			begin
				bias_ns=BIAS_SET;
				bias_set_clear=1'b0;
				bias_read_clear=1'b0;
				read_bias_signal=1'b1;

			end
			else
			begin
				bias_ns=BIAS_IDLE;
				bias_set_clear=1'b1;
				bias_read_clear=1'b1;
				read_bias_signal=1'b0;
			end
		end
		BIAS_SET:
		begin
			if(bias_set_count==16'd`LAYER1_OUTPUT_CHANNEL_NUM)
			begin
				bias_set_keep=1'b1;
				bias_set_done=1'b1;
				read_bias_signal=1'b0;
				bias_read_clear=1'b1;
			end
			else
			begin

				bias_set_keep=1'b0;
				bias_set_done=1'b0;
				read_bias_signal=1'b1;
				bias_read_clear=1'b0;
				
			end
			bias_ns=BIAS_SET;
			bias_set_clear=1'b0;
		end
		endcase
	end
	
	counter_cnn bias_read_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_read_count),
	.clear(bias_read_clear),
	.keep(1'b0)
	);
	
	counter_cnn bias_set_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_set_count),
	.clear(bias_set_clear),
	.keep(bias_set_keep)
	);
	
	always_comb
	begin
		if(bias_set_done==1'b0)
		begin
			//bias_register_in[8]=bias_data;
			/*
			bias_register_in[7]=bias_data;
			bias_register_in[6]=bias_register_out[7];
			bias_register_in[5]=bias_register_out[6];
			bias_register_in[4]=bias_register_out[5];
			bias_register_in[3]=bias_register_out[4];
			bias_register_in[2]=bias_register_out[3];
			bias_register_in[1]=bias_register_out[2];
			bias_register_in[0]=bias_register_out[1];
			*/
			bias_register_in[`LAYER1_OUTPUT_CHANNEL_NUM-1]=bias_data;
			for (int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-2;i++)
			begin
				bias_register_in[i]=bias_register_out[i+1];
			end
		end
		else
		begin
			for(int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				bias_register_in[i]=bias_register_out[i];
			end		
		end
	end
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				bias_register_out[i]<=16'd0;
			end	
		end
		else
		begin
			for(int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				bias_register_out[i]<=bias_register_in[i];
			end		
		end
	end
		//----------------------------------------WEIGHT_SETTING---------------------------------------------//
	localparam WEIGHT_IDLE=1'b0;
	localparam WEIGHT_SET=1'b1;
	logic      weight_cs;
	logic      weight_ns;
	logic      weight_set_done;
	logic [15:0] weight_set_count;
	logic        weight_set_clear;
	logic        weight_set_keep;
	logic [15:0] weight_read_count;
	logic        weight_read_clear;
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			weight_cs<=WEIGHT_IDLE;
		end
		else
		begin
			weight_cs<=weight_ns;
		end
	end
	always_comb
	begin
		read_weight_addr=weight_read_count;
		case(weight_cs)
		WEIGHT_IDLE:
		begin
			weight_set_keep=1'b0;
			weight_set_done=1'b0;
			weight_set_clear=1'b1;
			weight_read_clear=1'b1;
			read_weight_signal=1'b0;
			if(weight_store_done)
			begin
				weight_ns=WEIGHT_SET;
				/*
				weight_set_clear=1'b0;
				weight_read_clear=1'b0;
				read_weight_signal=1'b0;
				*/
			end
			else
			begin
				weight_ns=WEIGHT_IDLE;
				/*
				weight_set_clear=1'b1;
				weight_read_clear=1'b1;
				read_weight_signal=1'b0;
				*/
			end	
		end
		WEIGHT_SET:
		begin
			if(weight_set_count==`LAYER1_WEIGHT_SET_COUNT)
			begin
				weight_set_keep=1'b1;
				weight_set_done=1'b1;
				weight_read_clear=1'b1;
				read_weight_signal=1'b0;
			end
			else
			begin
				weight_set_keep=1'b0;
				weight_set_done=1'b0;
				weight_read_clear=1'b0;
				read_weight_signal=1'b1;
			end
			weight_ns=WEIGHT_SET;
			weight_set_clear=1'b0;
		end
		endcase
	end
	
	counter_cnn weight_read_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_read_count),
	.clear(weight_read_clear),
	.keep(1'b0)
	);
	
	counter_cnn weight_set_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_set_count),
	.clear(weight_set_clear),
	.keep(weight_set_keep)
	);
	always_comb
	begin
		if(weight_set_done==1'b0)
		begin
			weight_register_in9[0]=weight_data;
			weight_register_in8[0]=weight_register_out9[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			weight_register_in7[0]=weight_register_out8[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			weight_register_in6[0]=weight_register_out7[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			weight_register_in5[0]=weight_register_out6[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			weight_register_in4[0]=weight_register_out5[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			weight_register_in3[0]=weight_register_out4[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			weight_register_in2[0]=weight_register_out3[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			weight_register_in1[0]=weight_register_out2[`LAYER1_OUTPUT_CHANNEL_NUM-1];
			for(int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-2;i++)
			begin
				weight_register_in9[i+1]=weight_register_out9[i];
				weight_register_in8[i+1]=weight_register_out8[i];
				weight_register_in7[i+1]=weight_register_out7[i];
				weight_register_in6[i+1]=weight_register_out6[i];
				weight_register_in5[i+1]=weight_register_out5[i];
				weight_register_in4[i+1]=weight_register_out4[i];
				weight_register_in3[i+1]=weight_register_out3[i];
				weight_register_in2[i+1]=weight_register_out2[i];
				weight_register_in1[i+1]=weight_register_out1[i];
			end
		end
		else
		begin
			for(int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				weight_register_in1[i]=weight_register_out1[i];
				weight_register_in2[i]=weight_register_out2[i];
				weight_register_in3[i]=weight_register_out3[i];
				weight_register_in4[i]=weight_register_out4[i];
				weight_register_in5[i]=weight_register_out5[i];
				weight_register_in6[i]=weight_register_out6[i];
				weight_register_in7[i]=weight_register_out7[i];
				weight_register_in8[i]=weight_register_out8[i];
				weight_register_in9[i]=weight_register_out9[i];
			end		
		end
	end
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				weight_register_out1[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out2[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out3[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out4[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out5[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out6[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out7[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out8[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
				weight_register_out9[i]<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			end
		end
		else
		begin
			for(int i=0;i<=`LAYER1_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				weight_register_out1[i]<=weight_register_in1[i];
				weight_register_out2[i]<=weight_register_in2[i];
				weight_register_out3[i]<=weight_register_in3[i];
				weight_register_out4[i]<=weight_register_in4[i];
				weight_register_out5[i]<=weight_register_in5[i];
				weight_register_out6[i]<=weight_register_in6[i];
				weight_register_out7[i]<=weight_register_in7[i];
				weight_register_out8[i]<=weight_register_in8[i];
				weight_register_out9[i]<=weight_register_in9[i];
			end
		end
	end
	//----------------------------------------SYSTOLIC_ARRARYY---------------------------------------------//

	layer1_systolic array1(
	.input_channel(col_1_1_register_out),
	
	.output_channel1(systolic1_output[0]),
	.output_channel2(systolic1_output[1]),
	.output_channel3(systolic1_output[2]),
	.output_channel4(systolic1_output[3]),
	.output_channel5(systolic1_output[4]),
	.output_channel6(systolic1_output[5]),
	.output_channel7(systolic1_output[6]),
	.output_channel8(systolic1_output[7]),
	
	.weight1(weight_register_out1[0]),
	.weight2(weight_register_out1[1]),
	.weight3(weight_register_out1[2]),
	.weight4(weight_register_out1[3]),
	.weight5(weight_register_out1[4]),
	.weight6(weight_register_out1[5]),
	.weight7(weight_register_out1[6]),
	.weight8(weight_register_out1[7])
);

	layer1_systolic array2(
	.input_channel(col_1_2_register_out),
	
	.output_channel1(systolic2_output[0]),
	.output_channel2(systolic2_output[1]),
	.output_channel3(systolic2_output[2]),
	.output_channel4(systolic2_output[3]),
	.output_channel5(systolic2_output[4]),
	.output_channel6(systolic2_output[5]),
	.output_channel7(systolic2_output[6]),
	.output_channel8(systolic2_output[7]),
	
	.weight1(weight_register_out2[0]),
	.weight2(weight_register_out2[1]),
	.weight3(weight_register_out2[2]),
	.weight4(weight_register_out2[3]),
	.weight5(weight_register_out2[4]),
	.weight6(weight_register_out2[5]),
	.weight7(weight_register_out2[6]),
	.weight8(weight_register_out2[7])
);
	layer1_systolic array3(
	.input_channel(col_1_3_register_out),
	
	.output_channel1(systolic3_output[0]),
	.output_channel2(systolic3_output[1]),
	.output_channel3(systolic3_output[2]),
	.output_channel4(systolic3_output[3]),
	.output_channel5(systolic3_output[4]),
	.output_channel6(systolic3_output[5]),
	.output_channel7(systolic3_output[6]),
	.output_channel8(systolic3_output[7]),
	
	.weight1(weight_register_out3[0]),
	.weight2(weight_register_out3[1]),
	.weight3(weight_register_out3[2]),
	.weight4(weight_register_out3[3]),
	.weight5(weight_register_out3[4]),
	.weight6(weight_register_out3[5]),
	.weight7(weight_register_out3[6]),
	.weight8(weight_register_out3[7])
);

	layer1_systolic array4(
	.input_channel(col_2_1_register_out),
	
	.output_channel1(systolic4_output[0]),
	.output_channel2(systolic4_output[1]),
	.output_channel3(systolic4_output[2]),
	.output_channel4(systolic4_output[3]),
	.output_channel5(systolic4_output[4]),
	.output_channel6(systolic4_output[5]),
	.output_channel7(systolic4_output[6]),
	.output_channel8(systolic4_output[7]),
	
	.weight1(weight_register_out4[0]),
	.weight2(weight_register_out4[1]),
	.weight3(weight_register_out4[2]),
	.weight4(weight_register_out4[3]),
	.weight5(weight_register_out4[4]),
	.weight6(weight_register_out4[5]),
	.weight7(weight_register_out4[6]),
	.weight8(weight_register_out4[7])
);
	layer1_systolic array5(
	.input_channel(col_2_2_register_out),
	
	.output_channel1(systolic5_output[0]),
	.output_channel2(systolic5_output[1]),
	.output_channel3(systolic5_output[2]),
	.output_channel4(systolic5_output[3]),
	.output_channel5(systolic5_output[4]),
	.output_channel6(systolic5_output[5]),
	.output_channel7(systolic5_output[6]),
	.output_channel8(systolic5_output[7]),
	
	.weight1(weight_register_out5[0]),
	.weight2(weight_register_out5[1]),
	.weight3(weight_register_out5[2]),
	.weight4(weight_register_out5[3]),
	.weight5(weight_register_out5[4]),
	.weight6(weight_register_out5[5]),
	.weight7(weight_register_out5[6]),
	.weight8(weight_register_out5[7])
);
	layer1_systolic array6(
	.input_channel(col_2_3_register_out),
	
	.output_channel1(systolic6_output[0]),
	.output_channel2(systolic6_output[1]),
	.output_channel3(systolic6_output[2]),
	.output_channel4(systolic6_output[3]),
	.output_channel5(systolic6_output[4]),
	.output_channel6(systolic6_output[5]),
	.output_channel7(systolic6_output[6]),
	.output_channel8(systolic6_output[7]),
	
	.weight1(weight_register_out6[0]),
	.weight2(weight_register_out6[1]),
	.weight3(weight_register_out6[2]),
	.weight4(weight_register_out6[3]),
	.weight5(weight_register_out6[4]),
	.weight6(weight_register_out6[5]),
	.weight7(weight_register_out6[6]),
	.weight8(weight_register_out6[7])
);
	layer1_systolic array7(
	.input_channel(col_3_1_register_out),
	
	.output_channel1(systolic7_output[0]),
	.output_channel2(systolic7_output[1]),
	.output_channel3(systolic7_output[2]),
	.output_channel4(systolic7_output[3]),
	.output_channel5(systolic7_output[4]),
	.output_channel6(systolic7_output[5]),
	.output_channel7(systolic7_output[6]),
	.output_channel8(systolic7_output[7]),
	
	.weight1(weight_register_out7[0]),
	.weight2(weight_register_out7[1]),
	.weight3(weight_register_out7[2]),
	.weight4(weight_register_out7[3]),
	.weight5(weight_register_out7[4]),
	.weight6(weight_register_out7[5]),
	.weight7(weight_register_out7[6]),
	.weight8(weight_register_out7[7])
);
	layer1_systolic array8(
	.input_channel(col_3_2_register_out),
	
	.output_channel1(systolic8_output[0]),
	.output_channel2(systolic8_output[1]),
	.output_channel3(systolic8_output[2]),
	.output_channel4(systolic8_output[3]),
	.output_channel5(systolic8_output[4]),
	.output_channel6(systolic8_output[5]),
	.output_channel7(systolic8_output[6]),
	.output_channel8(systolic8_output[7]),
	
	.weight1(weight_register_out8[0]),
	.weight2(weight_register_out8[1]),
	.weight3(weight_register_out8[2]),
	.weight4(weight_register_out8[3]),
	.weight5(weight_register_out8[4]),
	.weight6(weight_register_out8[5]),
	.weight7(weight_register_out8[6]),
	.weight8(weight_register_out8[7])
);
	layer1_systolic array9(
	.input_channel(col_3_3_register_out),
	
	.output_channel1(systolic9_output[0]),
	.output_channel2(systolic9_output[1]),
	.output_channel3(systolic9_output[2]),
	.output_channel4(systolic9_output[3]),
	.output_channel5(systolic9_output[4]),
	.output_channel6(systolic9_output[5]),
	.output_channel7(systolic9_output[6]),
	.output_channel8(systolic9_output[7]),
	
	.weight1(weight_register_out9[0]),
	.weight2(weight_register_out9[1]),
	.weight3(weight_register_out9[2]),
	.weight4(weight_register_out9[3]),
	.weight5(weight_register_out9[4]),
	.weight6(weight_register_out9[5]),
	.weight7(weight_register_out9[6]),
	.weight8(weight_register_out9[7])
);
	//----------------------------------------ADDER_TREE--------------------------------------------//
	channel8_tree_adder channel_1_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[0]),
	.input_data2(systolic2_output[0]),
	.input_data3(systolic3_output[0]),
	.input_data4(systolic4_output[0]),
	.input_data5(systolic5_output[0]),
	.input_data6(systolic6_output[0]),
	.input_data7(systolic7_output[0]),
	.input_data8(systolic8_output[0]),
	.input_data9(systolic9_output[0]),
	.bias(bias_register_out[0]),
	.output_data(output_data[15:0])
	);
	
	channel8_tree_adder channel_2_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[1]),
	.input_data2(systolic2_output[1]),
	.input_data3(systolic3_output[1]),
	.input_data4(systolic4_output[1]),
	.input_data5(systolic5_output[1]),
	.input_data6(systolic6_output[1]),
	.input_data7(systolic7_output[1]),
	.input_data8(systolic8_output[1]),
	.input_data9(systolic9_output[1]),
	.bias(bias_register_out[1]),
	.output_data(output_data[31:16])
	);
	
	channel8_tree_adder channel_3_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[2]),
	.input_data2(systolic2_output[2]),
	.input_data3(systolic3_output[2]),
	.input_data4(systolic4_output[2]),
	.input_data5(systolic5_output[2]),
	.input_data6(systolic6_output[2]),
	.input_data7(systolic7_output[2]),
	.input_data8(systolic8_output[2]),
	.input_data9(systolic9_output[2]),
	.bias(bias_register_out[2]),
	.output_data(output_data[47:32])
	);
	channel8_tree_adder channel_4_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[3]),
	.input_data2(systolic2_output[3]),
	.input_data3(systolic3_output[3]),
	.input_data4(systolic4_output[3]),
	.input_data5(systolic5_output[3]),
	.input_data6(systolic6_output[3]),
	.input_data7(systolic7_output[3]),
	.input_data8(systolic8_output[3]),
	.input_data9(systolic9_output[3]),
	.bias(bias_register_out[3]),
	.output_data(output_data[63:48])
	);
	channel8_tree_adder channel_5_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[4]),
	.input_data2(systolic2_output[4]),
	.input_data3(systolic3_output[4]),
	.input_data4(systolic4_output[4]),
	.input_data5(systolic5_output[4]),
	.input_data6(systolic6_output[4]),
	.input_data7(systolic7_output[4]),
	.input_data8(systolic8_output[4]),
	.input_data9(systolic9_output[4]),
	.bias(bias_register_out[4]),
	.output_data(output_data[79:64])
	);
	channel8_tree_adder channel_6_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[5]),
	.input_data2(systolic2_output[5]),
	.input_data3(systolic3_output[5]),
	.input_data4(systolic4_output[5]),
	.input_data5(systolic5_output[5]),
	.input_data6(systolic6_output[5]),
	.input_data7(systolic7_output[5]),
	.input_data8(systolic8_output[5]),
	.input_data9(systolic9_output[5]),
	.bias(bias_register_out[5]),
	.output_data(output_data[95:80])
	);
	channel8_tree_adder channel_7_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[6]),
	.input_data2(systolic2_output[6]),
	.input_data3(systolic3_output[6]),
	.input_data4(systolic4_output[6]),
	.input_data5(systolic5_output[6]),
	.input_data6(systolic6_output[6]),
	.input_data7(systolic7_output[6]),
	.input_data8(systolic8_output[6]),
	.input_data9(systolic9_output[6]),
	.bias(bias_register_out[6]),
	.output_data(output_data[111:96])
	);
	channel8_tree_adder channel_8_adder_output(
	//.clk(clk),
	//.rst(rst),
	.input_data1(systolic1_output[7]),
	.input_data2(systolic2_output[7]),
	.input_data3(systolic3_output[7]),
	.input_data4(systolic4_output[7]),
	.input_data5(systolic5_output[7]),
	.input_data6(systolic6_output[7]),
	.input_data7(systolic7_output[7]),
	.input_data8(systolic8_output[7]),
	.input_data9(systolic9_output[7]),
	.bias(bias_register_out[7]),
	.output_data(output_data[127:112])
	);
//----------------------------------------BUFFER_CHAIN--------------------------------------------//
	stage29_fifo second_stage(
	.clk(clk),
	.rst(rst),
	.input_data(col_3_1_register_out),
	.output_data(buffer2_output)
	);
	stage29_fifo third_stage(
	.clk(clk),
	.rst(rst),
	.input_data(col_2_1_register_out),
	.output_data(buffer3_output)
	);
	always_comb
	begin

		col_3_3_register_in=input_data;
		col_3_2_register_in=col_3_3_register_out;
		col_3_1_register_in=col_3_2_register_out;
		
		
		
		col_2_3_register_in=buffer2_output;
		col_2_2_register_in=col_2_3_register_out;
		col_2_1_register_in=col_2_2_register_out;
		
		
		
		col_1_3_register_in=buffer3_output;
		col_1_2_register_in=col_1_3_register_out;
		col_1_1_register_in=col_1_2_register_out;
	end
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			col_3_3_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			col_3_2_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			col_3_1_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			
			col_2_3_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			col_2_2_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			col_2_1_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			
			col_1_3_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			col_1_2_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
			col_1_1_register_out<=`LAYER1_WEIGHT_INPUT_LENGTH'd0;
		end
		else
		begin
			col_3_3_register_out<=col_3_3_register_in;
			col_3_2_register_out<=col_3_2_register_in;
			col_3_1_register_out<=col_3_1_register_in;
			
			col_2_3_register_out<=col_2_3_register_in;
			col_2_2_register_out<=col_2_2_register_in;
			col_2_1_register_out<=col_2_1_register_in;
			
			col_1_3_register_out<=col_1_3_register_in;
			col_1_2_register_out<=col_1_2_register_in;
			col_1_1_register_out<=col_1_1_register_in;
		end
	end
endmodule








