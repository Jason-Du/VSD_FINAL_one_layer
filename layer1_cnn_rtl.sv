`include "layer1_tree_adder_rtl.sv"
`include "layer1_systolic_rtl.sv"
`include "layer1_cnn_rtl.sv"
`include "28stage_fifo_rtl.sv"
module layer1_cnn_rtl(
	clk,
	rst,
	input_data,
	output_data,
	weight_data,
	weight_set_done,
);
	input         clk;
	input         rst;
	input         weight_set_done;
	input  [47:0] weight_data;
	input  [47:0] input_data;
	output [128:0] output_data;
	
	
	logic  [47:0] buffer1_output;
	logic  [47:0] buffer2_output;
	logic  [47:0] buffer3_output;

	logic  [47:0] col_3_3_register_in;
	logic  [47:0] col_3_2_register_in;
	logic  [47:0] col_3_1_register_in;
	logic  [47:0] col_3_3_register_out;
	logic  [47:0] col_3_2_register_out;
	logic  [47:0] col_3_1_register_out;
	
	logic  [47:0] col_2_3_register_in;
	logic  [47:0] col_2_2_register_in;
	logic  [47:0] col_2_1_register_in;
	logic  [47:0] col_2_3_register_out;
	logic  [47:0] col_2_2_register_out;
	logic  [47:0] col_2_1_register_out;

	logic  [47:0] col_1_3_register_in;
	logic  [47:0] col_1_2_register_in;
	logic  [47:0] col_1_1_register_in;
	logic  [47:0] col_1_3_register_out;
	logic  [47:0] col_1_2_register_out;
	logic  [47:0] col_1_1_register_out;
	
	logic  [2:0][47:0] weight_register_in1;
	logic  [2:0][47:0] weight_register_in2;
	logic  [2:0][47:0] weight_register_in3;
	logic  [2:0][47:0] weight_register_in4;
	logic  [2:0][47:0] weight_register_in5;
	logic  [2:0][47:0] weight_register_in6;
	logic  [2:0][47:0] weight_register_in7;
	logic  [2:0][47:0] weight_register_in8;
	logic  [2:0][47:0] weight_register_in9;
	
	logic  [2:0][47:0] weight_register_out1;
	logic  [2:0][47:0] weight_register_out2;
	logic  [2:0][47:0] weight_register_out3;
	logic  [2:0][47:0] weight_register_out4;
	logic  [2:0][47:0] weight_register_out5;
	logic  [2:0][47:0] weight_register_out6;
	logic  [2:0][47:0] weight_register_out7;
	logic  [2:0][47:0] weight_register_out8;
	logic  [2:0][47:0] weight_register_out9;
	
	logic  [2:0][16:0] systolic1_output;
	logic  [2:0][16:0] systolic2_output;
	logic  [2:0][16:0] systolic3_output;
	logic  [2:0][16:0] systolic4_output;
	logic  [2:0][16:0] systolic5_output;
	logic  [2:0][16:0] systolic6_output;
	logic  [2:0][16:0] systolic7_output;
	logic  [2:0][16:0] systolic8_output;
	logic  [2:0][16:0] systolic9_output;
		//----------------------------------------WEIGHT_SETTING---------------------------------------------//
	always_comb
	begin
		if(weight_set_done==1'b0)
		begin
			weight_register_in9[0]=weight_data;
			weight_register_in8[0]=weight_register_out9[7];
			weight_register_in7[0]=weight_register_out8[7];
			weight_register_in6[0]=weight_register_out7[7];
			weight_register_in5[0]=weight_register_out6[7];
			weight_register_in4[0]=weight_register_out5[7];
			weight_register_in3[0]=weight_register_out4[7];
			weight_register_in2[0]=weight_register_out3[7];
			weight_register_in1[0]=weight_register_out2[7];
			for(byte i=0;i<=6;i++)
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
			for(byte i=0;i<=7;i++)
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
			for(byte i=0;i<=7;i++)
			begin
				weight_register_out1[i]<=47'd0;
				weight_register_out2[i]<=47'd0;
				weight_register_out3[i]<=47'd0;
				weight_register_out4[i]<=47'd0;
				weight_register_out5[i]<=47'd0;
				weight_register_out6[i]<=47'd0;
				weight_register_out7[i]<=47'd0;
				weight_register_out8[i]<=47'd0;
				weight_register_out9[i]<=47'd0;
			end
		end
		else
		begin
			for(byte i=0;i<=7;i++)
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
	
	always_comb
	begin
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
	end
	//----------------------------------------ADDER_TREE--------------------------------------------//
	always_comb
	begin
	
	end
	//----------------------------------------BUFFER_CHAIN--------------------------------------------//
	always_comb
	begin
		28stage_fifo first_stage(
		.clk(clk),
		.rst(rst),
		.input_data(input_data),
		.output_data(buffer1_output)
		);
		col_3_3_register_in=buffer1_output;
		col_3_2_register_in=col_3_3_register_out;
		col_3_1_register_in=col_3_2_register_out;
		
		28stage_fifo second_stage(
		.clk(clk),
		.rst(rst),
		.input_data(col_3_1_register_out),
		.output_data(buffer2_output)
		);
		
		col_2_3_register_in=buffer2_output;
		col_2_2_register_in=col_2_3_register_out;
		col_2_1_register_in=col_2_2_register_out;
		
		28stage_fifo third_stage(
		.clk(clk),
		.rst(rst),
		.input_data(col_2_1_register_out),
		.output_data(buffer3_output)
		);
		
		col_1_3_register_in=buffer3_output;
		col_1_2_register_in=col_1_3_register_out;
		col_1_1_register_in=col_1_2_register_out;
	);
	end
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			col_3_3_register_out<=16'd0;
			col_3_2_register_out<=16'd0;
			col_3_1_register_out<=16'd0;
			
			col_2_3_register_out<=16'd0;
			col_2_2_register_out<=16'd0;
			col_2_1_register_out<=16'd0;
			
			col_1_3_register_out<=16'd0;
			col_1_2_register_out<=16'd0;
			col_1_1_register_out<=16'd0;
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








