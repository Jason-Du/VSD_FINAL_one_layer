`timescale 1ns/10ps
module layer1_systolic(
	input_channel,
	
	output_channel1,
	output_channel2,
	output_channel3,
	output_channel4,
	output_channel5,
	output_channel6,
	output_channel7,
	output_channel8,
	weight1,
	weight2,
	weight3,
	weight4,
	weight5,
	weight6,
	weight7,
	weight8
);
	input         [47:0] input_channel;
	input         [47:0] weight1;
	input         [47:0] weight2;
	input         [47:0] weight3;
	input         [47:0] weight4;
	input         [47:0] weight5;
	input         [47:0] weight6;
	input         [47:0] weight7;
	input         [47:0] weight8;
	
	output logic signed [15:0] output_channel1;
	output logic signed [15:0] output_channel2;
	output logic signed [15:0] output_channel3;
	output logic signed [15:0] output_channel4;
	output logic signed [15:0] output_channel5;
	output logic signed [15:0] output_channel6;
	output logic signed [15:0] output_channel7;
	output logic signed [15:0] output_channel8;
	
	logic  signed       [31:0] channel1_data1;
	logic  signed       [31:0] channel1_data2;
	logic  signed       [31:0] channel1_data3;
	
	logic signed        [31:0] channel2_data1;
	logic signed        [31:0] channel2_data2;
	logic signed        [31:0] channel2_data3;
	
	logic signed        [31:0] channel3_data1;
	logic signed        [31:0] channel3_data2;
	logic signed        [31:0] channel3_data3;
	
	logic signed        [31:0] channel4_data1;
	logic signed        [31:0] channel4_data2;
	logic signed        [31:0] channel4_data3;
	
	logic signed        [31:0] channel5_data1;
	logic signed        [31:0] channel5_data2;
	logic signed        [31:0] channel5_data3;
	
	logic signed        [31:0] channel6_data1;
	logic signed        [31:0] channel6_data2;
	logic signed        [31:0] channel6_data3;
	
	logic signed        [31:0] channel7_data1;
	logic signed        [31:0] channel7_data2;
	logic signed        [31:0] channel7_data3;
	
	logic signed        [31:0] channel8_data1;
	logic signed        [31:0] channel8_data2;
	logic signed        [31:0] channel8_data3;
	
	logic  signed       [15:0] channel1_test1;
	logic  signed       [15:0] channel1_test2;
	logic  signed       [15:0] channel1_test3;
	
	logic signed        [15:0] channel2_test1;
	logic signed        [15:0] channel2_test2;
	logic signed        [15:0] channel2_test3;
	
	logic signed        [15:0] channel3_test1;
	logic signed        [15:0] channel3_test2;
	logic signed        [15:0] channel3_test3;
	
	logic signed        [15:0] channel4_test1;
	logic signed        [15:0] channel4_test2;
	logic signed        [15:0] channel4_test3;
	
	logic signed        [15:0] channel5_test1;
	logic signed        [15:0] channel5_test2;
	logic signed        [15:0] channel5_test3;
	
	logic signed        [15:0] channel6_test1;
	logic signed        [15:0] channel6_test2;
	logic signed        [15:0] channel6_test3;
	
	logic signed        [15:0] channel7_test1;
	logic signed        [15:0] channel7_test2;
	logic signed        [15:0] channel7_test3;
	
	logic signed        [15:0] channel8_test1;
	logic signed        [15:0] channel8_test2;
	logic signed        [15:0] channel8_test3;
	always_comb
	begin
		channel1_test1=channel1_data1[25:10];
		channel1_test2=channel1_data2[25:10];
		channel1_test3=channel1_data3[25:10];
		               
		channel2_test1=channel2_data1[25:10];
		channel2_test2=channel2_data2[25:10];
		channel2_test3=channel2_data3[25:10];
		               
		channel3_test1=channel3_data1[25:10];
		channel3_test2=channel3_data2[25:10];
		channel3_test3=channel3_data3[25:10];
		               
		channel4_test1=channel4_data1[25:10];
		channel4_test2=channel4_data2[25:10];
		channel4_test3=channel4_data3[25:10];
		               
		channel5_test1=channel5_data1[25:10];
		channel5_test2=channel5_data2[25:10];
		channel5_test3=channel5_data3[25:10];
		               
		channel6_test1=channel6_data1[25:10];
		channel6_test2=channel6_data2[25:10];
		channel6_test3=channel6_data3[25:10];
		               
		channel7_test1=channel7_data1[25:10];
		channel7_test2=channel7_data2[25:10];
		channel7_test3=channel7_data3[25:10];
		               
		channel8_test1=channel8_data1[25:10];
		channel8_test2=channel8_data2[25:10];
		channel8_test3=channel8_data3[25:10];
	end
	
	always_comb
	begin
		channel1_data1=(signed'(weight1[47:32])*signed'(input_channel[47:32]));
		channel1_data2=(signed'(weight1[31:16])*signed'(input_channel[31:16]));
		channel1_data3=(signed'(weight1[15:0])*signed'(input_channel[15:0]));
		output_channel1=signed'(channel1_data1[25:10])+signed'(channel1_data2[25:10])+signed'(channel1_data3[25:10]);
		
		channel2_data1=(signed'(weight2[47:32])*signed'(input_channel[47:32]));
		channel2_data2=(signed'(weight2[31:16])*signed'(input_channel[31:16]));
		channel2_data3=(signed'(weight2[15:0])*signed'(input_channel[15:0]));
		output_channel2=signed'(channel2_data1[25:10])+signed'(channel2_data2[25:10])+signed'(channel2_data3[25:10]);
		
		channel3_data1=(signed'(weight3[47:32])*signed'(input_channel[47:32]));
		channel3_data2=(signed'(weight3[31:16])*signed'(input_channel[31:16]));
		channel3_data3=(signed'(weight3[15:0])*signed'(input_channel[15:0]));
		output_channel3=signed'(channel3_data1[25:10])+signed'(channel3_data2[25:10])+signed'(channel3_data3[25:10]);	
		
		channel4_data1=(signed'(weight4[47:32])*signed'(input_channel[47:32]));
		channel4_data2=(signed'(weight4[31:16])*signed'(input_channel[31:16]));
		channel4_data3=(signed'(weight4[15:0])*signed'(input_channel[15:0]));
		output_channel4=signed'(channel4_data1[25:10])+signed'(channel4_data2[25:10])+signed'(channel4_data3[25:10]);
		
		channel5_data1=(signed'(weight5[47:32])*signed'(input_channel[47:32]));
		channel5_data2=(signed'(weight5[31:16])*signed'(input_channel[31:16]));
		channel5_data3=(signed'(weight5[15:0])*signed'(input_channel[15:0]));
		output_channel5=signed'(channel5_data1[25:10])+signed'(channel5_data2[25:10])+signed'(channel5_data3[25:10]);
		
		channel6_data1=(signed'(weight6[47:32])*signed'(input_channel[47:32]));
		channel6_data2=(signed'(weight6[31:16])*signed'(input_channel[31:16]));
		channel6_data3=(signed'(weight6[15:0])*signed'(input_channel[15:0]));
		output_channel6=signed'(channel6_data1[25:10])+signed'(channel6_data2[25:10])+signed'(channel6_data3[25:10]);
		
		channel7_data1=(signed'(weight7[47:32])*signed'(input_channel[47:32]));
		channel7_data2=(signed'(weight7[31:16])*signed'(input_channel[31:16]));
		channel7_data3=(signed'(weight7[15:0])*signed'(input_channel[15:0]));
		output_channel7=signed'(channel7_data1[25:10])+signed'(channel7_data2[25:10])+signed'(channel7_data3[25:10]);
		
		channel8_data1=(signed'(weight8[47:32])*signed'(input_channel[47:32]));
		channel8_data2=(signed'(weight8[31:16])*signed'(input_channel[31:16]));
		channel8_data3=(signed'(weight8[15:0])*signed'(input_channel[15:0]));
		output_channel8=signed'(channel8_data1[25:10])+signed'(channel8_data2[25:10])+signed'(channel8_data3[25:10]);
		
		
	/*
		output_channel1=(signed'(weight1[47:32])*signed'(input_channel[47:32]))+(signed'(weight1[31:16])*signed'(input_channel[31:16]))+(signed'(weight1[15:0])*signed'(input_channel[15:0]));
		
		output_channel2=(signed'(weight2[47:32])*signed'(input_channel[47:32]))+(signed'(weight2[31:16])*signed'(input_channel[31:16]))+(signed'(weight2[15:0])*signed'(input_channel[15:0]));
		output_channel3=(signed'(weight3[47:32])*signed'(input_channel[47:32]))+(signed'(weight3[31:16])*signed'(input_channel[31:16]))+(signed'(weight3[15:0])*signed'(input_channel[15:0]));
		output_channel4=(signed'(weight4[47:32])*signed'(input_channel[47:32]))+(signed'(weight4[31:16])*signed'(input_channel[31:16]))+(signed'(weight4[15:0])*signed'(input_channel[15:0]));
		output_channel5=(signed'(weight5[47:32])*signed'(input_channel[47:32]))+(signed'(weight5[31:16])*signed'(input_channel[31:16]))+(signed'(weight5[15:0])*signed'(input_channel[15:0]));
		output_channel6=(signed'(weight6[47:32])*signed'(input_channel[47:32]))+(signed'(weight6[31:16])*signed'(input_channel[31:16]))+(signed'(weight6[15:0])*signed'(input_channel[15:0]));
		output_channel7=(signed'(weight7[47:32])*signed'(input_channel[47:32]))+(signed'(weight7[31:16])*signed'(input_channel[31:16]))+(signed'(weight7[15:0])*signed'(input_channel[15:0]));
		output_channel8=(signed'(weight8[47:32])*signed'(input_channel[47:32]))+(signed'(weight8[31:16])*signed'(input_channel[31:16]))+(signed'(weight8[15:0])*signed'(input_channel[15:0]));
	
	*/
	end
	
endmodule










