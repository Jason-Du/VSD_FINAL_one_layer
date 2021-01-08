`timescale 1ns/10ps
`include "layer7_systolic_rtl.sv"
`include "counter_rtl.sv"
`include "def.svh"

module layer7_cnn(
	clk,
	rst,
	input_data,
	weight_data_channel1,
	weight_data_channel2,
	weight_data_channel3,
	weight_data_channel4,
	weight_data_channel5,
	weight_data_channel6,
	weight_data_channel7,
	weight_data_channel8,
	weight_data_channel9,
	weight_data_channel10,
	bias_data,
	
	weight_store_done,
	bias_store_done,
	pixel_store_done,
	//IN OUT PORT
	save_enable,
	
	layer7_calculation_done,
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
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel1;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel2;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel3;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel4;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel5;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel6;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel7;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel8;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel9;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_data_channel10;
	input        [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] input_data;
	input        [                 `WORDLENGTH-1:0] bias_data;
	
	output logic                                    save_enable;

	output logic [              `WORDLENGTH*10-1:0] output_data;
	output logic                                    layer7_calculation_done;

	
	//output logic  [                `WORDLENGTH-1:0] read_pixel_addr;
	output logic                                    read_pixel_signal;
	output logic  [                `WORDLENGTH-1:0] read_row_addr;
	output logic  [                `WORDLENGTH-1:0] read_col_addr;	
	output logic  [                `WORDLENGTH-1:0] read_weight_addr;
	output logic                                    read_weight_signal;
	
	output logic  [                `WORDLENGTH-1:0] read_bias_addr;
	output logic                                    read_bias_signal;
	
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out1;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out2;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out3;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out4;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out5;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out6;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out7;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out8;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out9;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] weight_register_out10;
	
	logic  [                 `WORDLENGTH-1:0] bias_register_in[10] ;
	logic  [                 `WORDLENGTH-1:0] bias_register_out[10];
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] data_register_in;
	logic  [ `LAYER7_WEIGHT_INPUT_LENGTH-1:0] data_register_out;

	//----------------------------SAVE ADDRESS SIGNAL CONTROL----------------------------//
	//set counter is also col counter
	localparam SAVE_IDLE=2'b00;
	localparam SAVE_SETTING=2'b01;
	localparam SAVE_ENABLE=2'b10;
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
			save_cs=save_ns;
		end
	end
	always_comb
	begin
		read_col_addr=read_pixel_count;
		read_row_addr=read_pixel_row_count;
		case(save_cs)
		SAVE_IDLE:
		begin
			layer7_calculation_done=1'b0;
			read_pixel_signal=1'b0;
			
			read_pixel_clear=1'b1;
			read_pixel_row_clear=1'b1;
			read_pixel_row_keep=1'b1;
			save_enable=1'b0;

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
			layer7_calculation_done=1'b0;
			read_pixel_signal=1'b1;
			
			read_pixel_clear=1'b0;
			read_pixel_row_clear=1'b0;
			read_pixel_row_keep=1'b1;
			save_ns=SAVE_ENABLE;
			save_enable=1'b0;
		end
		SAVE_ENABLE:
		begin
			read_pixel_signal=1'b1;
			read_pixel_row_clear=1'b0;
			if (read_pixel_count==16'd`LAYER7_WIDTH-1)
			begin
				read_pixel_clear=1'b1;
				read_pixel_row_keep=1'b0;
			end
			else
			begin
				read_pixel_clear=1'b0;
				read_pixel_row_keep=1'b1;
			end
			if(read_pixel_row_count==6'd`LAYER7_WIDTH-1&&read_pixel_count==6'd`LAYER7_WIDTH-1)
			begin
				save_ns=SAVE_IDLE;
				layer7_calculation_done=1'b1;
				save_enable=1'b1;
			end
			else
			begin
				save_ns=SAVE_ENABLE;
				layer7_calculation_done=1'b0;
				save_enable=1'b0;
			end
			
		end
		default:
		begin
			layer7_calculation_done=1'b0;
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

	counter read_col_counter(
	.clk(clk),
	.rst(rst),
	.count(read_pixel_row_count),
	.clear(read_pixel_row_clear),
	.keep(read_pixel_row_keep)
	);
// fix
	counter read_counter(
	.clk(clk),
	.rst(rst),
	.count(read_pixel_count),
	.clear(read_pixel_clear),
	.keep(1'b0)
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
			bias_cs<=SAVE_IDLE;
		end
		else
		begin
			bias_cs=bias_ns;
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
			if(bias_set_count==16'd`LAYER7_OUTPUT_CHANNEL_NUM)
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
	
	counter bias_read_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_read_count),
	.clear(bias_read_clear),
	.keep(1'b0)
	);
	
	counter bias_set_counter(
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
			bias_register_in[`LAYER7_OUTPUT_CHANNEL_NUM-1]=bias_data;
			for (byte i=0;i<=`LAYER7_OUTPUT_CHANNEL_NUM-2;i++)
			begin
				bias_register_in[i]=bias_register_out[i+1];
			end
		end
		else
		begin
			for(byte i=0;i<=`LAYER7_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				bias_register_in[i]=bias_register_out[i];
			end		
		end
	end
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=`LAYER7_OUTPUT_CHANNEL_NUM-1;i++)
			begin
				bias_register_out[i]<=16'd0;
			end	
		end
		else
		begin
			for(byte i=0;i<=`LAYER7_OUTPUT_CHANNEL_NUM-1;i++)
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
	logic [15:0] weight_read_count;
	logic        weight_read_clear;
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			weight_cs<=SAVE_IDLE;
		end
		else
		begin
			weight_cs=weight_ns;
		end
	end
	always_comb
	begin
		read_weight_addr=weight_read_count;
		case(weight_cs)
		WEIGHT_IDLE:
		begin
			if(pixel_store_done)
			begin
				weight_ns=WEIGHT_SET;
				weight_read_clear=1'b0;
				read_weight_signal=1'b1;
			end
			else
			begin
				weight_ns=WEIGHT_IDLE;
				weight_read_clear=1'b1;
				read_weight_signal=1'b0;
			end	
		end
		WEIGHT_SET:
		begin
			if(weight_read_count==16'd24)
			begin
				weight_read_clear=1'b1;
				read_weight_signal=1'b0;
				weight_ns=WEIGHT_IDLE;
			end
			else
			begin
				weight_read_clear=1'b0;
				read_weight_signal=1'b1;
				weight_ns=WEIGHT_SET;
			end
		end
		endcase
	end
	
	counter weight_read_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_read_count),
	.clear(weight_read_clear),
	.keep(1'b0)
	);
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin

			weight_register_out1<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out2<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out3<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out4<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out5<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out6<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out7<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out8<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out9<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
			weight_register_out10<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;

		end
		else
		begin

			weight_register_out1<=weight_data_channel1;
			weight_register_out2<=weight_data_channel2;
			weight_register_out3<=weight_data_channel3;
			weight_register_out4<=weight_data_channel4;
			weight_register_out5<=weight_data_channel5;
			weight_register_out6<=weight_data_channel6;
			weight_register_out7<=weight_data_channel7;
			weight_register_out8<=weight_data_channel8;
			weight_register_out9<=weight_data_channel9;
			weight_register_out10<=weight_data_channel10;
		end
	end
	//----------------------------------------SYSTOLIC_ARRARYY---------------------------------------------//
	layer7_systolic channel10(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out10),
		.bias_data(bias_register_out[9]),
		
		.result_data_out(output_data[159:144])
	);
	
	layer7_systolic channel9(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out9),
		.bias_data(bias_register_out[8]),
		
		.result_data_out(output_data[143:128])
	);
	
	layer7_systolic channel8(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out8),
		.bias_data(bias_register_out[7]),
		
		.result_data_out(output_data[127:112])
	);
	layer7_systolic channel7(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out7),
		.bias_data(bias_register_out[6]),
		
		.result_data_out(output_data[111:96])
	);
	
	layer7_systolic channel6(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out6),
		.bias_data(bias_register_out[5]),
		
		.result_data_out(output_data[95:80])
	);
	
	layer7_systolic channel5(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out5),
		.bias_data(bias_register_out[4]),
		
		.result_data_out(output_data[79:64])
	);
		
		
	layer7_systolic channel4(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out4),
		.bias_data(bias_register_out[3]),
		
		.result_data_out(output_data[63:48])
	);
	
	layer7_systolic channel3(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out3),
		.bias_data(bias_register_out[2]),
		
		.result_data_out(output_data[47:32])
	);
	
	layer7_systolic channel2(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out2),
		.bias_data(bias_register_out[1]),
		
		.result_data_out(output_data[31:16])
	);
	layer7_systolic channel1(
		.clk(clk),
		.rst(rst),
		.input_data(data_register_out),
		.weight_data(weight_register_out1),
		.bias_data(bias_register_out[0]),
		
		.result_data_out(output_data[15:0])
	);
//----------------------------------------BUFFER_CHAIN--------------------------------------------//

	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			data_register_out<=`LAYER7_WEIGHT_INPUT_LENGTH'd0;
		end
		else
		begin
			data_register_out<=data_register_in;
		end
	end
endmodule









